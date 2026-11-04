import 'package:flags/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import 'storage_service.dart';

final class SecureStorageServiceImpl implements IStorageService<String> {
  static SecureStorageServiceImpl get instance =>
      getIt<SecureStorageServiceImpl>();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  @override
  Future<void> clear() async {
    await _secureStorage.deleteAll();
  }

  @override
  Future<String?> get(String key, {String? defaultValue}) async {
    return await _secureStorage.read(key: key) ?? defaultValue;
  }

  @override
  Future<bool> has(String key) async {
    return await _secureStorage.containsKey(key: key);
  }

  @override
  Future<void> init() async {
    getIt.registerSingleton<SecureStorageServiceImpl>(this);
  }

  @override
  Future<bool> remove(String key) async {
    await _secureStorage.delete(key: key);
    return true;
  }

  @override
  Future<void> set(String key, String data) async {
    await _secureStorage.write(key: key, value: data);
  }
}
