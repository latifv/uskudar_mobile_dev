import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:payinall/core/error/exceptions.dart';

abstract class BaseLocalDataSource {
  BaseLocalDataSource(this.boxName);
  final String boxName;

  Box<dynamic> get box => Hive.box(boxName);

  T read<T>(String key) {
    final value = box.get(key) as T?;
    if (value == null) {
      throw const CacheException();
    }
    return value;
  }

  Future<void> write<T>(String key, T value) async {
    await box.put(key, value);
  }

  bool hasKey(String key) {
    return box.containsKey(key);
  }

  Future<void> removeKey(String key) async {
    await box.delete(key);
  }

  Future<void> clear() async {
    await box.clear();
  }
}
