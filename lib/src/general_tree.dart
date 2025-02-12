part of 'package:tree_structs/tree_structs.dart';

/// A class representing a node in a general tree structure.
///
/// Each node contains data of type [T], a reference to its parent node, and a list of its children nodes.
///
/// The class provides methods for tree traversal, manipulation, and querying.
///
/// - [data]: The data contained in the node.
/// - [parent]: The parent node of this node.
/// - [_children]: The list of children nodes of this node.
/// - [_currentChildIndex]: The index of the current child node.
///
/// Methods:
///
/// - [currentChild]: Returns the current child node.
/// - [children]: Returns the list of children nodes.
/// - [childrenData]: Returns the list of data of the children nodes.
/// - [siblings]: Returns the list of sibling nodes.
/// - [siblingsData]: Returns the list of data of the sibling nodes.
/// - [chain]: Returns the chain of nodes starting from this node and following the current child nodes.
/// - [chainData]: Returns the list of data of the nodes in the chain.
/// - [addChild]: Adds a new child node with the given data.
/// - [removeChild]: Removes a child node with the given data.
/// - [removeChildNode]: Removes the given child node.
/// - [removeWhereChild]: Removes a child node that satisfies the given test.
/// - [removeWhereChildNode]: Removes a child node that satisfies the given test.
/// - [nextChild]: Moves to the next child node.
/// - [previousChild]: Moves to the previous child node.
/// - [bfs]: Performs a breadth-first search and returns the data of the first node that satisfies the given test.
/// - [dfs]: Performs a depth-first search and returns the data of the first node that satisfies the given test.
/// - [bfsNode]: Performs a breadth-first search and returns the first node that satisfies the given test.
/// - [dfsNode]: Performs a depth-first search and returns the first node that satisfies the given test.
class GeneralTreeNode<T> with _SelectedChildMixin {
  /// Creates a [GeneralTreeNode] with the given [data] and an optional [parent].
  ///
  /// The [data] parameter is the value stored in the node.
  /// The [parent] parameter is the parent node of this node, if any.
  GeneralTreeNode(this.data, [this.parent]);

  /// The data stored in the node of the tree.
  ///
  /// This is a generic type [T] which allows the tree to store any type of data.
  final T data;

  /// The parent node of the current node in the general tree.
  ///
  /// This property holds a reference to the parent node of type `GeneralTreeNode<T>?`.
  /// It can be `null` if the current node is the root of the tree.
  GeneralTreeNode<T>? parent;

  final List<GeneralTreeNode<T>> _children = [];

  @override
  int? get _childrenCount => _children.length;

  /// Gets the current child node of the general tree node.
  ///
  /// Returns the current child node if the `_currentChildIndex` is not null,
  /// otherwise returns null.
  GeneralTreeNode<T>? get currentChild =>
      _currentChildIndex != null ? _children[_currentChildIndex!] : null;

  /// Returns the list of child nodes of the current tree node.
  ///
  /// This getter provides access to the `_children` list, which contains
  /// all the direct descendants of this node in the tree.
  ///
  /// Example:
  /// ```dart
  /// var children = node.children;
  /// ```
  ///
  /// Returns a `List<GeneralTreeNode<T>>` representing the child nodes.
  List<GeneralTreeNode<T>> get children => _children;

  /// Returns a list of data from the children nodes.
  ///
  /// This getter maps over the `_children` list and extracts the `data`
  /// property from each child node, returning a list of these data values.
  List<T> get childrenData => _children.map((child) => child.data).toList();

  /// Returns a list of sibling nodes.
  ///
  /// If the current node has no parent, an empty list is returned.
  /// Otherwise, it returns all children of the parent node except the current node.
  List<GeneralTreeNode<T>> get siblings {
    if (parent == null) {
      return [];
    }
    return parent!.children.where((child) => child != this).toList();
  }

  /// Returns a list of data from the sibling nodes.
  ///
  /// This getter maps over the sibling nodes and extracts their data,
  /// returning a list of the data from each sibling.
  List<T> get siblingsData => siblings.map((sibling) => sibling.data).toList();

  /// Returns a list of `GeneralTreeNode<T>` representing the chain of nodes
  /// starting from the current node and following the `currentChild` references
  /// until a node with no `currentChild` is found.
  ///
  /// The first element in the list is the current node, and each subsequent
  /// element is the `currentChild` of the previous node.
  List<GeneralTreeNode<T>> get chain {
    final List<GeneralTreeNode<T>> chain = [this];

    while (chain.last.currentChild != null) {
      chain.add(chain.last.currentChild!);
    }

    return chain;
  }

  /// Returns a list of `GeneralTreeNode<T>` representing the chain of nodes
  /// starting from the current node and following the `parent` references
  /// until a node with no `parent` is found.
  ///
  /// The last element in the list is the root node, and each subsequent
  /// element is the `child` of the previous node.
  List<GeneralTreeNode<T>> get reverseChain {
    final List<GeneralTreeNode<T>> chain = [this];

    while (chain.last.parent != null) {
      chain.add(chain.last.parent!);
    }

    return chain.reversed.toList();
  }

  /// Returns a list of data from the nodes in the chain.
  ///
  /// This getter maps each node in the chain to its data and collects
  /// them into a list.
  List<T> get chainData => chain.map((node) => node.data).toList();

  /// Returns a list of data from the nodes in the reverse chain.
  ///
  /// This getter maps each node in the reverse chain to its data and collects
  /// them into a list.
  List<T> get reverseChainData =>
      reverseChain.map((node) => node.data).toList();

  /// Adds a new child node with the given data to the current node.
  ///
  /// The new child node is created with the provided [newData] and is added
  /// to the list of children of the current node.
  ///
  /// If the `_currentChildIndex` is set to the index of the new child node.
  ///
  /// - Parameter newData: The data for the new child node.
  void addChild(T newData) {
    _children.add(GeneralTreeNode(newData, this));
    _currentChildIndex = _children.length - 1;
  }

  /// Removes a child node from the tree that matches the given data.
  ///
  /// This method searches for a child node with the specified [removeData]
  /// and removes it from the tree if found.
  ///
  /// - Parameter removeData: The data of the child node to be removed.
  void removeChild(T removeData) {
    removeWhereChild((childData) => childData == removeData);
  }

  /// Removes a child node from the current node's children.
  ///
  /// This method removes the specified [removeNode] from the list of children
  /// of the current node. It uses the `removeWhereChildNode` method to find
  /// and remove the child node that matches the given [removeNode].
  ///
  /// - Parameter removeNode: The child node to be removed.
  void removeChildNode(GeneralTreeNode<T> removeNode) {
    removeWhereChildNode((child) => child == removeNode);
  }

  /// Removes child nodes that satisfy the given test function.
  ///
  /// The [test] function is applied to the data of each child node, and if it
  /// returns `true`, the corresponding child node is removed.
  ///
  /// Example usage:
  /// ```dart
  /// tree.removeWhereChild((data) => data.isEmpty);
  /// ```
  ///
  /// This will remove all child nodes whose data is empty.
  ///
  /// - Parameter test: A function that takes a child node's data and returns
  ///   `true` if the child node should be removed, and `false` otherwise.
  void removeWhereChild(bool Function(T) test) {
    removeWhereChildNode((child) => test(child.data));
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
  void removeWhereChildNode(bool Function(GeneralTreeNode<T>) test) {
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

  /// Performs a breadth-first search (BFS) on the tree to find a node that satisfies the given test function.
  ///
  /// The [test] function is applied to the data of each node in the tree. The search stops as soon as a node
  /// satisfying the test is found, and the data of that node is returned. If no such node is found, `null` is returned.
  ///
  /// - Parameter test: A function that takes a node's data and returns `true` if the node satisfies the condition, `false` otherwise.
  ///
  /// - Returns: The data of the first node that satisfies the test function, or `null` if no such node is found.
  T? bfs(bool Function(T) test) {
    return bfsNode((node) => test(node.data))?.data;
  }

  /// Performs a depth-first search (DFS) on the tree and returns the data of the first node
  /// that satisfies the given test function.
  ///
  /// The [test] function is a predicate that takes a node's data and returns `true` if the
  /// node satisfies the condition, otherwise `false`.
  ///
  /// Returns the data of the first node that satisfies the [test] function, or `null` if no
  /// such node is found.
  ///
  /// Example usage:
  /// ```dart
  /// var result = tree.dfs((data) => data == targetValue);
  /// if (result != null) {
  ///   print('Found node with data: $result');
  /// } else {
  ///   print('No node found with the target value.');
  /// }
  /// ```
  T? dfs(bool Function(T) test) {
    return dfsNode((node) => test(node.data))?.data;
  }

  /// Performs a breadth-first search (BFS) on the tree starting from this node
  /// to find a node that satisfies the given test function.
  ///
  /// The search first checks the current node, then its immediate children,
  /// and then recursively checks the children of each child node.
  ///
  /// The [test] function is a predicate that takes a [GeneralTreeNode] and
  /// returns a boolean indicating whether the node satisfies the condition.
  ///
  /// Returns the first node that satisfies the [test] function, or `null` if
  /// no such node is found.
  ///
  /// Example usage:
  /// ```dart
  /// final node = root.bfsNode((node) => node.value == targetValue);
  /// if (node != null) {
  ///   print('Node found: ${node.value}');
  /// } else {
  ///   print('Node not found');
  /// }
  /// ```
  GeneralTreeNode<T>? bfsNode(bool Function(GeneralTreeNode<T>) test) {
    if (test(this)) {
      return this;
    }

    if (_children.isEmpty) {
      return null;
    }

    final queue = Queue<GeneralTreeNode<T>>.from(_children);

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();

      for (final child in current._children) {
        if (test(child)) {
          return child;
        }
        
        if (child._children.isNotEmpty) {
          queue.addAll(child._children);
        }
      }
    }

    return null;
  }

  /// Performs a depth-first search (DFS) on the tree starting from this node.
  ///
  /// Iterates through the tree nodes and returns the first node that satisfies
  /// the given test function.
  ///
  /// The search starts from the current node and proceeds to its children
  /// recursively.
  ///
  /// - Parameter test: A function that takes a `GeneralTreeNode<T>` and returns
  ///   a boolean indicating whether the node satisfies the condition.
  /// - Returns: The first `GeneralTreeNode<T>` that satisfies the test function,
  ///   or `null` if no such node is found.
  GeneralTreeNode<T>? dfsNode(bool Function(GeneralTreeNode<T>) test) {
    if (test(this)) {
      return this;
    }

    for (final child in _children) {
      final result = child.dfsNode(test);
      if (result != null) {
        return result;
      }
    }

    return null;
  }
}

/// A class representing a general tree structure with multiple roots.
///
/// The [GeneralTree] class allows for the creation and manipulation of a tree
/// with multiple root nodes. Each root node can have its own subtree.
///
/// Type parameter [T] specifies the type of data stored in the tree nodes.
class GeneralTree<T> {
  /// Creates a [GeneralTree] with the given list of root nodes.
  ///
  /// If the list of roots is not empty, the current root index is set to 0.
  GeneralTree(this.roots) {
    if (roots.isNotEmpty) {
      _currentRootIndex = 0;
    }
  }

  /// The list of root nodes in the tree.
  final List<GeneralTreeNode<T>> roots;

  /// The index of the current root node.
  ///
  /// This is `null` if there are no root nodes.
  int? _currentRootIndex;

  /// Gets the index of the current root node.
  int? get currentRootIndex => _currentRootIndex;

  /// Gets the current root node.
  ///
  /// Returns `null` if there is no current root node.
  GeneralTreeNode<T>? get currentRoot =>
      _currentRootIndex != null ? roots[_currentRootIndex!] : null;

  /// Returns the chain of `GeneralTreeNode` objects starting from the current root.
  ///
  /// If `_currentRootIndex` is `null`, an empty list is returned.
  /// Otherwise, it returns the chain of nodes from the root at `_currentRootIndex`.
  List<GeneralTreeNode<T>> get chain {
    if (_currentRootIndex == null) {
      return [];
    }

    return roots[_currentRootIndex!].chain;
  }

  /// Returns the list of data from the nodes in the chain.
  List<T> get chainData => chain.map((node) => node.data).toList();

  /// Adds a new root node with the given data.
  ///
  /// The new root node is created with the provided [data] and is added to the list of roots.
  void addRoot(T data) {
    roots.add(GeneralTreeNode(data));
    _currentRootIndex = roots.length - 1;
  }

  /// Removes the root node with the given data.
  void removeRoot(T removeData) {
    removeWhereRoot((rootData) => rootData == removeData);
  }

  /// Removes the specified root node.
  void removeRootNode(GeneralTreeNode<T> removeNode) {
    removeWhereRootNode((node) => node == removeNode);
  }

  /// Removes the root node that satisfies the given test.
  void removeWhereRoot(bool Function(T) test) {
    removeWhereRootNode((node) => test(node.data));
  }

  /// Removes the root node that satisfies the given test.
  void removeWhereRootNode(bool Function(GeneralTreeNode<T>) test) {
    if (roots.isEmpty) {
      return;
    }

    final index = roots.indexWhere(test);

    if (index == -1) {
      return;
    }

    roots.removeAt(index);

    if (_currentRootIndex == null) return;

    if (_currentRootIndex! > index) {
      _currentRootIndex = _currentRootIndex! - 1;
      return;
    }

    if (_currentRootIndex! == index) {
      _currentRootIndex = roots.length - 1;
    }

    if (_currentRootIndex! < 0) {
      _currentRootIndex = null;
    }
  }

  /// Moves to the next root node.
  ///
  /// If the current root index is `null`, it is set to 0.
  /// If the current root index is the last root node, it remains unchanged.
  void nextRoot() {
    if (roots.isEmpty) {
      return;
    }

    _currentRootIndex ??= 0;

    if (_currentRootIndex! < roots.length - 1) {
      _currentRootIndex = _currentRootIndex! + 1;
    }
  }

  /// Moves to the previous root node.
  ///
  /// If the current root index is `null`, it is set to 0.
  /// If the current root index is the first root node, it remains unchanged.
  void previousRoot() {
    if (roots.isEmpty) {
      return;
    }

    _currentRootIndex ??= 0;

    if (_currentRootIndex! > 0) {
      _currentRootIndex = _currentRootIndex! - 1;
    }
  }
}
