part of 'package:trees/trees.dart';

class GeneralTreeNode<T> {
  GeneralTreeNode(this.data, [this.parent]);

  final T data;
  final GeneralTreeNode<T>? parent;
  final List<GeneralTreeNode<T>> _children = [];

  int? _currentChildIndex;

  GeneralTreeNode<T>? get currentChild => _currentChildIndex != null ? _children[_currentChildIndex!] : null;

  List<GeneralTreeNode<T>> get children => _children;
  List<T> get childrenData => _children.map((child) => child.data).toList();

  List<GeneralTreeNode<T>> get siblings {
    if (parent == null) {
      return [];
    }
    return parent!.children.where((child) => child != this).toList();
  }
  List<T> get siblingsData => siblings.map((sibling) => sibling.data).toList();

  List<GeneralTreeNode<T>> get chain {
    final List<GeneralTreeNode<T>> chain = [this];

    while (chain.last.currentChild != null) {
      chain.add(chain.last.currentChild!);
    }

    return chain;
  }
  List<T> get chainData => chain.map((node) => node.data).toList();

  void addChild(T newData) {
    _currentChildIndex ??= 0;

    _children.add(GeneralTreeNode(newData, this));
  }

  void removeChild(T removeData) {
    removeWhereChild((childData) => childData == removeData);
  }

  void removeChildNode(GeneralTreeNode<T> removeNode) {
    removeWhereChildNode((child) => child == removeNode);
  }

  void removeWhereChild(bool Function(T) test) {
    removeWhereChildNode((child) => test(child.data));
  }

  void removeWhereChildNode(bool Function(GeneralTreeNode<T>) test) {
    final index = _children.indexWhere(test);

    if (index == -1) {
      throw StateError('Child not found');
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

  void nextChild() {
    _currentChildIndex ??= 0;

    if (_currentChildIndex! < _children.length - 1) {
      _currentChildIndex = _currentChildIndex! + 1;
    }
  }

  void previousChild() {
    _currentChildIndex ??= 0;

    if (_currentChildIndex! > 0) {
      _currentChildIndex = _currentChildIndex! - 1;
    }
  }

  T? bfs(bool Function(T) test) {
    return bfsNode((node) => test(node.data))?.data;
  }

  T? dfs(bool Function(T) test) {
    return dfsNode((node) => test(node.data))?.data;
  }

  GeneralTreeNode<T>? bfsNode(bool Function(GeneralTreeNode<T>) test) {
    if (test(this)) {
      return this;
    }

    for (final child in _children) {
      if (test(child)) {
        return child;
      }
    }

    for (final child in _children) {
      final result = child.bfsNode(test);
      if (result != null) {
        return result;
      }
    }

    return null;
  }

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