import 'package:flutter/cupertino.dart';

class WidgetsPool<S extends State<StatefulWidget>> {
  final List<GlobalKey<S>> _pool;
  late final List<GlobalKey<S>> _available;

  WidgetsPool({int initialSize = 10})
      : _pool = List<GlobalKey<S>>.generate(initialSize, (_) {
          return GlobalKey();
        }) {
    _available = [..._pool];
  }

  List<GlobalKey<S>> get pool => _pool;

  void acquire({
    required void Function(S state) onCall,
  }) {
    if (_available.isNotEmpty) {
      final last = _available.removeLast();
      onCall(last.currentState!);
    }
  }

  void release(GlobalKey<S> obj) {
    _available.add(obj);
  }
}
