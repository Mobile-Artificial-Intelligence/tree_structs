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
/// - [addChildNode]: Adds a new child node.
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
class GeneralTreeNode<T> with _SelectedChildMixin, _AddAndRemoveChildMixin<GeneralTreeNode<T>> {
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

  @override
  final List<GeneralTreeNode<T>> _children = [];

  @override
  int get _childrenCount => _children.length;

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
    addChildNode(GeneralTreeNode<T>(newData, this));
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