import 'package:memoize/memoize.dart';

class TreeNode<T> {
  final T item;
  final TreeNode<T>? parent;
  final List<TreeNode<T>> children = [];

  TreeNode({
    required this.item,
    this.parent,
  });

  List<TreeNode<T>> getNestedParents() => memo0(() {
    List<TreeNode<T>> result = [];

    TreeNode<T>? currentNode = this.parent;

    while (currentNode != null) {
      result.add(currentNode);
      currentNode = currentNode.parent;
    }

    return result;
  })();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TreeNode &&
              runtimeType == other.runtimeType &&
              item == other.item;

  @override
  int get hashCode => item.hashCode;

}
