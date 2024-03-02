import 'dart:io';

import 'package:armar/armar.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

import 'cookie_jar/ar_cookie_jar.dart';
import 'inspectors/request_inspector.dart';

sealed class IApiClient {
  static IApiClient get get => Get.find<IApiClient>();

  Dio get dio;

  void setAuthToken(String token);

  void setLanguage(String code);

  void setCurrency(String code);

  void setArCookies(ArCookie cookies);

  void setCsrfToken(String token);

  void updateCookies(void Function(Map<String, dynamic> cookies) func);

  void setHeaders(Map<String, dynamic> map);

  void removeAuthToken();

  void refreshCsrfFromResponse(Response<dynamic> response);

  Future<void> refreshCsrfFromUriResponse();

  Map<String, dynamic> get dioHeaders;

  ArCookie getSetResponseCookies(
    Response response, {
    String setCookieKey = "set-cookie",
  });
}

class ArApiClient implements IApiClient {
  final void Function(DioException, ErrorInterceptorHandler)? onError;
  final void Function(RequestOptions, RequestInterceptorHandler)? onRequest;
  final void Function(Response<dynamic>, ResponseInterceptorHandler)?
      onResponse;

  late final String _baseApiUrl;

  late final Dio _dio;

  final String csrfHref;
  final String hostEndPoint;
  final String apiEndPoint;
  final Map<String, dynamic>? headers;

  ArApiClient({
    required this.hostEndPoint,
    this.apiEndPoint = "/v1",
    required this.headers,
    required this.csrfHref,
    required this.forceDecodeCookiesByKey,
    this.onError,
    this.onRequest,
    this.onResponse,
  }) {
    _baseApiUrl = "$hostEndPoint$apiEndPoint";

    final cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
      hitCacheOnErrorExcept: [401, 403],
      maxStale: const Duration(days: 7),
      priority: CachePriority.normal,
      cipher: null,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      allowPostMethod: false,
    );

    _dio = Dio(
      BaseOptions(
        baseUrl: _baseApiUrl,
        connectTimeout: const Duration(seconds: 2),
        receiveTimeout: const Duration(seconds: 2),
        sendTimeout: const Duration(seconds: 2),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
          'Access-Control-Allow-Credential': true,
          ...?headers,
        },
      ),
    );
    // final browserAdapter = BrowserHttpClientAdapter();
    //
    // browserAdapter.withCredentials = true;

    _dio.interceptors.add(
      DioCacheInterceptor(options: cacheOptions),
    );

    _dio.interceptors.add(
      RequestsInspector(
        onRequestHandle: onRequest,
        onResponseHandle: onResponse,
        onErrorHandle: onError,
      ),
    );
  }

  @override
  void refreshCsrfFromResponse(Response<dynamic> response) {
    final cookies = getSetResponseCookies(response);
    if (cookies.data.containsKey("XSRF-TOKEN")) {
      final csrfToken = cookies.data['XSRF-TOKEN']!;
      setCsrfToken(csrfToken);
    }
  }

  @override
  Future<void> refreshCsrfFromUriResponse() async {
    final response = await dio.get(csrfHref);
    final cookies = getSetResponseCookies(response);
    if (cookies.data.containsKey("XSRF-TOKEN")) {
      final csrfToken = cookies.data['XSRF-TOKEN']!;
      setCsrfToken(csrfToken);
    }
  }

  final List<String> forceDecodeCookiesByKey;

  Future<IApiClient> init() async {
    await _prepareJar(_dio);

    return Get.put<IApiClient>(
      this,
      permanent: true,
    );
  }

  Future<void> _prepareJar(Dio dio) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var subDir =
        await Directory('${appDocumentDir.path}/local_storage').create();

    final String appDocPath = subDir.path;
    final jar = ArPersistCookieJar(
      persistSession: true,
      ignoreExpires: true,
      storage: FileStorage("$appDocPath/.cookies/"),
      deleteHostCookiesWhenLoadFailed: false,
      forceDecodeCookiesByKey: [
        "XSRF-TOKEN",
      ],
    );

    dio.interceptors.add(CookieManager(jar));

    await jar.loadForRequest(Uri.parse(csrfHref));

    final arc = getSetResponseCookies(
      await _dio.get(csrfHref),
    );

    arc.data.remove('expires');
    arc.data.remove('cart_id');

    setArCookies(arc);
  }

  @override
  ArCookie getSetResponseCookies(
    Response response, {
    String setCookieKey = "set-cookie",
  }) {
    final headers = response.headers;

    if (headers.map.containsKey(setCookieKey)) {
      final data = headers.map[setCookieKey]!;

      final formattedData = data.asMap().entries.map(
        (e) {
          return (e.key < data.length - 1
                  ? e.value.substring(0, e.value.length - 1)
                  : e.value)
              .replaceAll('\n', '');
        },
      );

      Map<String, dynamic> mapData = {};

      for (final item in formattedData) {
        mapData.addAll(
          ArCookie.parseCookies(
            item.split("; "),
          ),
        );
      }

      return ArCookie.fromMap(mapData);
    }

    return ArCookie({});
  }

  @override
  Dio get dio => _dio;

  @override
  void removeAuthToken() {
    _dio.options.headers.remove("Authorization");
  }

  @override
  void setAuthToken(String token) {
    _dio.options.headers["Authorization"] = token;
  }

  @override
  void setLanguage(String code) {
    _dio.options.headers["X-Localization"] = code;

    setCookies({'slang': code});
  }

  @override
  void setCurrency(String code) {
    _dio.options.headers["X-Currency"] = code;

    setCookies({'currency': code});
  }

  void setCookies(Map<String, dynamic> data) {
    final headerCookies = _dio.options.headers["Cookie"];

    final cookies = headerCookies != null
        ? ArCookie.fromHeaderCookie(_dio.options.headers["Cookie"])
        : ArCookie({});

    data.forEach((key, value) {
      cookies.data[key] = value;
    });
    setHeaders({
      'Cookie': cookies.toHeaderCookie(),
    });
  }

  @override
  void setArCookies(ArCookie cookies) {
    if (cookies.data.containsKey("XSRF-TOKEN")) {
      final csrfToken = cookies.data['XSRF-TOKEN']!;
      setCsrfToken(csrfToken);
    }
    setCookies(cookies.data);
  }

  @override
  void setCsrfToken(String token) {
    setHeaders({
      'X-Xsrf-Token': Uri.decodeComponent(token),
    });
  }

  @override
  Map<String, dynamic> get dioHeaders => Map.unmodifiable(_dio.options.headers);

  @override
  void setHeaders(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  @override
  void updateCookies(void Function(Map<String, dynamic> cookies) func) {
    final arCookies = ArCookie.fromHeaderCookie(_dio.options.headers['Cookie']);
    func(
      arCookies.data,
    );
    setArCookies(arCookies);
  }
}

class ArCookie {
  ArCookie(this.data);

  final Map<String, dynamic> data;

  factory ArCookie.fromHeaderCookie(String data) {
    List<String> keyValuePairs = data.split('; ');

    Map<String, dynamic> parsedValues = parseCookies(keyValuePairs);

    return ArCookie(parsedValues);
  }

  factory ArCookie.fromMap(Map<String, dynamic> map) {
    return ArCookie(map);
  }

  String toHeaderCookie() {
    return data.entries
        .map((entry) => "${entry.key}=${entry.value}")
        .join('; ');
  }

  static Map<String, dynamic> parseCookies(List<String> keyValuePairs) {
    Map<String, dynamic> parsedValues = {};

    for (String pair in keyValuePairs) {
      List<String> parts = pair.split('=');
      if (parts.length == 2) {
        String key = parts[0];
        String value = parts[1];
        parsedValues[key] = Uri.decodeComponent(value);
      }
    }

    return parsedValues;
  }
}
