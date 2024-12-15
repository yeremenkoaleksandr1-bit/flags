part of 'defer_pointer.dart';

/// Holds a list of [_DeferPointerRenderObject]s which the [DeferredPointerHandler] widget uses to perform hit tests.
class DeferredPointerHandlerLink extends ChangeNotifier with EquatableMixin {
  DeferredPointerHandlerLink();

  /// Internal list of registered painters
  final List<_DeferPointerRenderObject> _painters = [];

  /// Notify listeners when any descendant requires painting.
  void descendantNeedsPaint() => notifyListeners();

  /// List of all painters currently attached to this link.
  List<_DeferPointerRenderObject> get painters => UnmodifiableListView(_painters);

  /// Add a render object to the link.
  /// Does nothing if the item is already in the list.
  void add(_DeferPointerRenderObject value) {
    if (value == null) {
      throw ArgumentError('Cannot add null to DeferredPointerHandlerLink.');
    }
    if (!_painters.contains(value)) {
      _painters.add(value);
      notifyListeners();
    }
  }

  /// Remove a render object from the link.
  /// Does nothing if the item is not in the list.
  void remove(_DeferPointerRenderObject value) {
    if (value == null) {
      throw ArgumentError('Cannot remove null from DeferredPointerHandlerLink.');
    }
    if (_painters.contains(value)) {
      _painters.remove(value);
      notifyListeners();
    }
  }

  /// Clears all painters currently attached to this link.
  void removeAll() {
    if (_painters.isNotEmpty) {
      _painters.clear();
      notifyListeners();
    }
  }

  @override
  List<Object?> get props => _painters;
}
