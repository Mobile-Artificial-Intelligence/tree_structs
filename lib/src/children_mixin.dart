part of 'package:tree_structs/tree_structs.dart';

mixin _ChildrenMixin<T> on _SelectedChildMixin {
  List<T> get _children;

  /// Adds a new child node with the given data to the current node.
  ///
  /// The new child node is created with the provided [newData] and is added
  /// to the list of children of the current node.
  ///
  /// If the `_currentChildIndex` is set to the index of the new child node.
  ///
  /// - Parameter newData: The data for the new child node.
  void addChildNode(T node) {
    _children.add(node);
    _currentChildIndex = _children.length - 1;
  }

  /// Removes a child node from the current node's children.
  ///
  /// This method removes the specified [removeNode] from the list of children
  /// of the current node. It uses the `removeWhereChildNode` method to find
  /// and remove the child node that matches the given [removeNode].
  ///
  /// - Parameter removeNode: The child node to be removed.
  void removeChildNode(T removeNode) {
    removeWhereChildNode((child) => child == removeNode);
  }

  /// Removes a child node from the tree that satisfies the given test function.
  ///
  /// The [test] function is used to find the index of the child node to be removed.
  /// If no child node satisfies the test function, a [StateError] is thrown.
  ///
  /// After removing the child node, the method updates the [_currentChildIndex] if necessary:
  /// - If [_currentChildIndex] is greater than the removed index, it is decremented by 1.
  /// - If [_currentChildIndex] is equal to the removed index, it is set to the last index of the remaining children.
  /// - If [_currentChildIndex] becomes less than 0, it is set to null.
  ///
  /// Example usage:
  /// ```dart
  /// tree.removeWhereChildNode((node) => node.value == someValue);
  /// ```
  void removeWhereChildNode(bool Function(T) test) {
    if (_children.isEmpty) {
      return;
    }

    final index = _children.indexWhere(test);

    if (index == -1) {
      return;
    }

    _children.removeAt(index);

    if (_currentChildIndex == null) return;

    if (_currentChildIndex! > index) {
      _currentChildIndex = _currentChildIndex! - 1;
      return;
    }

    if (_currentChildIndex! == index) {
      _currentChildIndex = _children.length - 1;
    }

    if (_currentChildIndex! < 0) {
      _currentChildIndex = null;
    }
  }
}