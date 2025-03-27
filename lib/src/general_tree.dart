part of 'package:tree_structs/tree_structs.dart';

String _generateID() {
  final random = Random();
  final codeUnits = List<int>.generate(10, (index) {
    return random.nextInt(33) + 89;
  });

  return String.fromCharCodes(codeUnits);
}

class GeneralTree<T> {
  final String id;

  String _title;

  String get title => _title;

  set title(String title) {
    _title = title;
    _updatedAt = DateTime.now();
  }

  final DateTime _createdAt;

  DateTime get createdAt => _createdAt;

  DateTime _updatedAt;

  DateTime get updatedAt => _updatedAt;

  String? _currentNode;

  String? get __currentNode {
    if (_currentNode == null && _mappings.isNotEmpty) {
      _currentNode = _mappings.values.first.id;
      _updatedAt = DateTime.now();
    }

    return _currentNode;
  }

  set __currentNode(String? currentNode) {
    _currentNode = currentNode;
    _updatedAt = DateTime.now();
  }

  Map<String, dynamic> _properties;

  Map<String, dynamic> get properties => _properties;

  set properties(Map<String, dynamic> properties) {
    _properties = properties;
    _updatedAt = DateTime.now();
  }

  Map<String, GeneralTreeNode<T>> _mappings;

  void addMapping(GeneralTreeNode<T> node) {
    _mappings[node.id] = node;
    _updatedAt = DateTime.now();
  }

  GeneralTree({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? currentNode,
    Map<String, dynamic>? properties,
    Map<String, GeneralTreeNode<T>>? mappings,
  }) : id = id ?? _generateID(),
       _title = title ?? '',
       _createdAt = createdAt ?? DateTime.now(),
       _updatedAt = updatedAt ?? DateTime.now(),
       _currentNode = currentNode,
       _properties = properties ?? {},
       _mappings = mappings ?? {};

  List<GeneralTreeNode<T>> get chain {
    if (__currentNode == null) {
      return [];
    }

    return _mappings[__currentNode]!.history.reversed.toList();
  }

  List<T> get chainData => chain.map((node) => node.data).toList();
}

class GeneralTreeNode<T> {
  final String id;
  final T data;
  final GeneralTree<T> tree;
  final GeneralTreeNode<T>? parent;
  final List<String> children;

  GeneralTreeNode(
    this.data, 
    this.tree, {
      this.parent,
      String? id,
      List<String>? children
    }
  ) : id = id ?? _generateID(), 
      children = children ?? [];

  List<GeneralTreeNode<T>> get history {
    final List<GeneralTreeNode<T>> history = [];

    var current = this;
    while (current.parent != null) {
      history.add(current);
      current = current.parent!;
    }

    return history;
  }

  List<GeneralTreeNode<T>> get siblings {
    if (parent == null) {
      return [];
    }

    final siblingKeys = parent!.children.where((element) => element != id).toList();

    return siblingKeys.map((key) => tree._mappings[key]!).toList();
  }

  void next() {
    if (parent == null) {
      return;
    }

    final index = parent!.children.indexOf(this.id);
    if (index == parent!.children.length - 1) {
      return;
    }

    tree._currentNode = parent!.children[index + 1];
  }

  void last() {
    if (parent == null) {
      return;
    }

    final index = parent!.children.indexOf(this.id);
    if (index == 0) {
      return;
    }

    tree._currentNode = parent!.children[index - 1];
  }

  void addChild(T newData) {
    final node = GeneralTreeNode<T>(
      newData, 
      tree, 
      parent: this
    );

    tree.addMapping(node);
    children.add(node.id);
  }
}