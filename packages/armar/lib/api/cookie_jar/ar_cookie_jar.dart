import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:universal_io/io.dart' show Cookie;

import '../../logger.dart';

class ArPersistCookieJar extends DefaultCookieJar {
  ArPersistCookieJar({
    required List<String> forceDecodeCookiesByKey,
    this.persistSession = true,
    bool ignoreExpires = false,
    Storage? storage,
    this.deleteHostCookiesWhenLoadFailed = true,
  })  : storage = storage ?? FileStorage(),
        forceDecodeCookiesByKey =
            forceDecodeCookiesByKey.map((e) => e.toLowerCase()).toList(),
        super(ignoreExpires: ignoreExpires);

  final List<String> forceDecodeCookiesByKey;

  /// Whether persisting cookies without "expires" or "max-age" attribute.
  final bool persistSession;
  final Storage storage;
  final bool deleteHostCookiesWhenLoadFailed;

  static const _indexKey = '.index';
  static const _domainsKey = '.domains';

  Set<String> _hostSet = {};

  bool _initialized = false;

  Future<void> forceInit() => _checkInitialized(force: true);

  Future<void> _checkInitialized({bool force = false}) async {
    if (!force && _initialized) {
      return;
    }

    await storage.init(persistSession, ignoreExpires);
    // Load domain cookies.
    String? str = await storage.read(_domainsKey);

    if (str != null && str.isNotEmpty) {
      try {
        final Map<String, dynamic> jsonData = json.decode(str);
        final Map<String, Map<String, Map<String, SerializableCookie>>>
            cookies = jsonData.map((domain, cookies) {
          final domainCookies = cookies
              .cast<String, dynamic>()
              .map<String, Map<String, SerializableCookie>>(
            (path, map) {
              final cookieForPath = map.cast<String, String>();
              final realCookies = cookieForPath.map<String, SerializableCookie>(
                (
                  String cookieName,
                  String cookie,
                ) {
                  return MapEntry<String, SerializableCookie>(
                    cookieName,
                    SerializableCookie.fromJson(
                      forceDecodeCookiesByKey.contains(cookieName.toLowerCase())
                          ? Uri.decodeComponent(cookie)
                          : Uri.encodeComponent(cookie),
                    ),
                  );
                },
              );
              return MapEntry<String, Map<String, SerializableCookie>>(
                path,
                realCookies,
              );
            },
          );
          return MapEntry<String, Map<String, Map<String, SerializableCookie>>>(
            domain,
            domainCookies,
          );
        });
        domainCookies
          ..clear()
          ..addAll(cookies);
      } catch (e) {
        await storage.delete(_domainsKey);
      }
    }
    str = await storage.read(_indexKey);
    if ((str != null && str.isNotEmpty)) {
      try {
        final list = json.decode(str);
        _hostSet = Set<String>.from(list);
      } catch (e) {
        await storage.delete(_indexKey);
      }
    } else {
      _hostSet = <String>{};
    }
    _initialized = true;
  }

  @override
  Future<List<Cookie>> loadForRequest(Uri uri) async {
    await _checkInitialized();
    await _load(uri);
    return super.loadForRequest(uri);
  }

  @override
  Future<void> saveFromResponse(Uri uri, List<Cookie> cookies) async {
    await _checkInitialized();
    if (cookies.isNotEmpty) {
      await super.saveFromResponse(uri, cookies);
      if (cookies.every((Cookie e) => e.domain == null)) {
        await _save(uri);
      } else {
        await _save(uri, true);
      }
    }
  }

  Map<String, Map<String, SerializableCookie>> _filter(
    Map<String, Map<String, SerializableCookie>> domain,
  ) {
    return domain.cast<String, Map<String, dynamic>>().map(
      (path, cookies) {
        final result = cookies.cast<String, SerializableCookie>().map(
          (key, cookie) {
            final isSession =
                cookie.cookie.expires == null && cookie.cookie.maxAge == null;
            if ((isSession && persistSession) ||
                (persistSession && !cookie.isExpired())) {
              return MapEntry(key, cookie);
            } else {
              return MapEntry(null, cookie);
            }
          },
        )..removeWhere((k, v) => k == null);
        return MapEntry(path, result.cast<String, SerializableCookie>());
      },
    );
  }

  @override
  Future<void> delete(Uri uri, [bool withDomainSharedCookie = false]) async {
    await _checkInitialized();
    await super.delete(uri, withDomainSharedCookie);
    final host = uri.host;
    if (_hostSet.remove(host)) {
      await storage.write(_indexKey, json.encode(_hostSet.toList()));
    }
    await storage.delete(host);
    if (withDomainSharedCookie) {
      await storage.write(_domainsKey, json.encode(domainCookies));
    }
  }

  @override
  Future<void> deleteAll() async {
    await _checkInitialized();
    await super.deleteAll();
    final keys = _hostSet.toList(growable: true)
      ..addAll([_indexKey, _domainsKey]);
    await storage.deleteAll(keys);
    _hostSet.clear();
  }

  Future<void> _save(Uri uri, [bool withDomainSharedCookie = false]) async {
    final host = uri.host;
    if (!_hostSet.contains(host)) {
      _hostSet.add(host);
      await storage.write(_indexKey, json.encode(_hostSet.toList()));
    }
    final cookies = hostCookies[host];
    if (cookies != null) {
      await storage.write(host, json.encode(_filter(cookies)));
    }
    if (withDomainSharedCookie) {
      final filterDomainCookies = domainCookies.map(
        (key, value) => MapEntry(key, _filter(value)),
      );
      await storage.write(_domainsKey, json.encode(filterDomainCookies));
    }
  }

  Future<void> _load(Uri uri) async {
    final host = uri.host;
    if (!_hostSet.contains(host) || hostCookies[host] != null) {
      return;
    }
    final str = await storage.read(host);
    if (str == null || str.isEmpty) {
      return;
    }
    try {
      final cookies = json.decode(str).cast<String, Map<String, dynamic>>();
      cookies.forEach((String path, Map<String, dynamic> map) {
        map.forEach((String k, dynamic v) {
          map[k] = SerializableCookie.fromJson(v);
        });
      });

      hostCookies[host] =
          cookies.cast<String, Map<String, SerializableCookie>>();
    } catch (e) {
      if (deleteHostCookiesWhenLoadFailed) {
        await storage.delete(host);
      }
      rethrow;
    }
  }
}
