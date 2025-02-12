part of 'package:tree_structs/tree_structs.dart';

typedef Future<T> LazyLoader<T>();

class LazyLoadedGeneralNode<T> with _SelectedChildMixin {
  LazyLoadedGeneralNode(
    this.data, {
    this.parentLoader, 
    this.childrenLoader,
    this.childrenUpdater
  });

  /// The data stored in the node of the tree.
  ///
  /// This is a generic type [T] which allows the tree to store any type of data.
  T data;

  LazyLoadedGeneralNode<T>? _parent;
  bool _parentLoaded = false;

  /// Loads the parent of the current node.
  final LazyLoader<LazyLoadedGeneralNode<T>?>? parentLoader;

  Future<void> _ensureParentLoaded() async {
    assert(parentLoader != null);

    if (!_parentLoaded) {
      _parent = await parentLoader!();
      _parentLoaded = true;
    }
  }

  /// Gets the parent of the current node.
  Future<LazyLoadedGeneralNode<T>?> get parent async {
    await _ensureParentLoaded();
    return _parent;
  }

  @override
  int? get _childrenCount => _children?.length;

  List<LazyLoadedGeneralNode<T>>? _children;
  bool _childrenLoaded = false;

  /// Loads the children of the current node.
  final LazyLoader<List<LazyLoadedGeneralNode<T>>>? childrenLoader;

  /// Updates the children of the current node.
  final Future<void> Function(List<T>)? childrenUpdater;

  Future<void> _ensureChildrenLoaded() async {
    assert(childrenLoader != null);

    if (!_childrenLoaded) {
      _children = await childrenLoader!();
      _childrenLoaded = true;
    }
  }

  /// Gets the children of the current node.
  Future<List<LazyLoadedGeneralNode<T>>> get children async {
    await _ensureChildrenLoaded();
    return _children!;
  }
}