import 'dart:async';

abstract interface class IStorageService<T> {
  FutureOr<void> init();

  FutureOr<bool> remove(String key);

  FutureOr<T?> get(String key, {T? defaultValue});

  FutureOr<void> set(String key, T data);

  FutureOr<void> clear();

  FutureOr<bool> has(String key);
}
