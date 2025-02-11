part of 'package:trees/trees.dart';

class GeneralTreeNode<T> {
  GeneralTreeNode(this.data, [this.parent]);

  final T data;
  final GeneralTreeNode<T>? parent;
  GeneralTreeNode<T>? _nextSibling;
  GeneralTreeNode<T>? _lastSibling;
  GeneralTreeNode<T>? _child;

  GeneralTreeNode<T>? get nextSibling => _nextSibling;
  GeneralTreeNode<T>? get lastSibling => _lastSibling;
  GeneralTreeNode<T>? get child => _child;

  List<GeneralTreeNode<T>> get nextSiblings => _nextSibling != null ? [_nextSibling!, ..._nextSibling!.nextSiblings] : [];
  List<GeneralTreeNode<T>> get lastSiblings => _lastSibling != null ? [_lastSibling!, ..._lastSibling!.lastSiblings] : [];
  List<GeneralTreeNode<T>> get siblings => [...lastSiblings, ...nextSiblings];
  List<GeneralTreeNode<T>> get children => _child != null ? [..._child!.lastSiblings, _child!, ..._child!.nextSiblings] : [];
  List<GeneralTreeNode<T>> get descendants => _child != null ? [...children, ..._child!.descendants] : [];
  List<GeneralTreeNode<T>> get descendantsChain => _child != null ? [_child!, ..._child!.descendantsChain] : [];
  List<GeneralTreeNode<T>> get ancestors => parent != null ? [...parent!.lastSiblings, parent!, ...parent!.nextSiblings, ...parent!.ancestors] : [];
  List<GeneralTreeNode<T>> get ancestorsChain => parent != null ? [parent!, ...parent!.ancestorsChain] : [];
  List<GeneralTreeNode<T>> get chain => [...ancestorsChain, this, ...descendantsChain];

  void addSibling(T newData) {
    GeneralTreeNode<T>? currentSibling = this;

    while (currentSibling!._nextSibling != null) {
      currentSibling = currentSibling._nextSibling;
    }

    currentSibling._nextSibling = GeneralTreeNode(newData, parent);
    currentSibling._nextSibling!._lastSibling = currentSibling;
  }

  void removeSibling(T removeData) {
    GeneralTreeNode<T>? currentSibling = this;

    while (currentSibling!._lastSibling != null) {
      if (currentSibling._lastSibling!.data == removeData) {
        final newLastSibling = currentSibling._lastSibling!._lastSibling;
        currentSibling._lastSibling = newLastSibling;
        if (newLastSibling != null) {
          newLastSibling._nextSibling = currentSibling;
        }
        return;
      }
      currentSibling = currentSibling._lastSibling;
    }

    currentSibling = _child;

    while (currentSibling!._nextSibling != null) {
      if (currentSibling._nextSibling!.data == removeData) {
        final newNextSibling = currentSibling._nextSibling!._nextSibling;
        currentSibling._nextSibling = newNextSibling;
        if (newNextSibling != null) {
          newNextSibling._lastSibling = currentSibling;
        }
        return;
      }
      currentSibling = currentSibling._nextSibling;
    }

    throw StateError('Node not found');
  }

  void addChild(T newData) {
    if (_child == null) {
      _child = GeneralTreeNode(newData, this);
    } 
    else {
      _child!.addSibling(newData);
    }
  }

  void removeChild(T removeData) {
    if (_child == null) {
      throw StateError('Node has no children');
    }

    if (_child!.data == removeData) {
      if (_child!._nextSibling != null) {
        final newLastSibling = _child!._lastSibling;
        _child = _child!._nextSibling;
        _child!._lastSibling = newLastSibling;
      } 
      else if (_child!._lastSibling != null) {
        _child = _child!._lastSibling;
        _child!._nextSibling = null;
      } 
      else {
        _child = null;
      }
      return;
    }

    var currentChild = _child;

    while (currentChild!._lastSibling != null) {
      if (currentChild._lastSibling!.data == removeData) {
        final newLastSibling = currentChild._lastSibling!._lastSibling;
        currentChild._lastSibling = newLastSibling;
        if (newLastSibling != null) {
          newLastSibling._nextSibling = currentChild;
        }
        return;
      }
      currentChild = currentChild._lastSibling;
    }

    currentChild = _child;

    while (currentChild!._nextSibling != null) {
      if (currentChild._nextSibling!.data == removeData) {
        final newNextSibling = currentChild._nextSibling!._nextSibling;
        currentChild._nextSibling = newNextSibling;
        if (newNextSibling != null) {
          newNextSibling._lastSibling = currentChild;
        }
        return;
      }
      currentChild = currentChild._nextSibling;
    }

    throw StateError('Node not found');
  }

  void switchNextSibling() {
    if (_nextSibling == null) {
      throw StateError('Node has no next sibling');
    }

    if (parent == null) {
      throw StateError('Node has no parent');
    }

    parent!._child = _nextSibling;
  }

  void switchLastSibling() {
    if (_lastSibling == null) {
      throw StateError('Node has no last sibling');
    }

    if (parent == null) {
      throw StateError('Node has no parent');
    }

    parent!._child = _lastSibling;
  }

  void switchNextChild() {
    if (_child == null) {
      throw StateError('Node has no children');
    }

    _child!.switchNextSibling();
  }

  void switchLastChild() {
    if (_child == null) {
      throw StateError('Node has no children');
    }

    _child!.switchLastSibling();
  }
}