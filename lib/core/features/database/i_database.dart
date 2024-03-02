import 'package:hive/hive.dart';

abstract class Storage<T> {
  Storage(String container) : box = Hive.box<T>(name: container);

  final Box<T> box;
  late T data;
}
