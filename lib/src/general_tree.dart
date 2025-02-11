part of 'package:trees/trees.dart';

class GeneralTreeNode<T> {
  GeneralTreeNode(this.data, {this.parent, this.nextSibling, this.lastSibling, this.child});

  final T data;
  final GeneralTreeNode<T>? parent;
  GeneralTreeNode<T>? nextSibling;
  GeneralTreeNode<T>? lastSibling;
  GeneralTreeNode<T>? child;

  void addChild(T data) {
    final newChild = GeneralTreeNode(data, parent: this);
    if (child == null) {
      child = newChild;
      return;
    } 
    
    var currentChild = child;

    while (currentChild!.nextSibling != null) {
      currentChild = currentChild.nextSibling;
    }
    
    currentChild.nextSibling = newChild;
    newChild.lastSibling = currentChild;
  }

  void removeChild(T data) {
    if (child == null) {
      throw StateError('Node has no children');
    }

    if (child!.data == data) {
      if (child!.nextSibling != null) {
        final lastSibling = child!.lastSibling;
        child = child!.nextSibling;
        child!.lastSibling = lastSibling;
      } 
      else if (child!.lastSibling != null) {
        child = child!.lastSibling;
        child!.nextSibling = null;
      } 
      else {
        child = null;
      }
      return;
    }

    var currentChild = child;

    while (currentChild!.lastSibling != null) {
      if (currentChild.lastSibling!.data == data) {
        final lastSibling = currentChild.lastSibling!.lastSibling;
        currentChild.lastSibling = lastSibling;
        if (lastSibling != null) {
          lastSibling.nextSibling = currentChild;
        }
        return;
      }
      currentChild = currentChild.lastSibling;
    }

    currentChild = child;

    while (currentChild!.nextSibling != null) {
      if (currentChild.nextSibling!.data == data) {
        final nextSibling = currentChild.nextSibling!.nextSibling;
        currentChild.nextSibling = nextSibling;
        if (nextSibling != null) {
          nextSibling.lastSibling = currentChild;
        }
        return;
      }
      currentChild = currentChild.nextSibling;
    }

    throw StateError('Node not found');
  }

  void switchNextSibling() {
    if (nextSibling == null) {
      throw StateError('Node has no next sibling');
    }

    if (parent == null) {
      throw StateError('Node has no parent');
    }

    parent!.child = nextSibling;
  }

  void switchLastSibling() {
    if (lastSibling == null) {
      throw StateError('Node has no last sibling');
    }

    if (parent == null) {
      throw StateError('Node has no parent');
    }

    parent!.child = lastSibling;
  }

  void switchNextChild() {
    if (child == null) {
      throw StateError('Node has no children');
    }

    child!.switchNextSibling();
  }

  void switchLastChild() {
    if (child == null) {
      throw StateError('Node has no children');
    }

    child!.switchLastSibling();
  }
}