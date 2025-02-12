part of 'package:tree_structs/tree_structs.dart';

mixin _SelectedChildMixin {
  int? _currentChildIndex;

  /// Gets the index of the current child node.
  ///
  /// Returns `null` if there is no current child node.
  int? get currentChildIndex => _currentChildIndex;

  int? get _childrenCount;

  /// Advances the current child index to the next child in the list of children.
  ///
  /// If the current child index is `null`, it initializes it to `0`. If the
  /// current child index is less than the length of the children list minus one,
  /// it increments the current child index by one.
  void nextChild() {
    _currentChildIndex ??= 0;

    if (_currentChildIndex! < _childrenCount! - 1) {
      _currentChildIndex = _currentChildIndex! + 1;
    }
  }

  /// Moves the current child index to the previous child if possible.
  ///
  /// If the current child index is `null`, it initializes it to `0`.
  /// If the current child index is greater than `0`, it decrements the index by `1`.
  void previousChild() {
    _currentChildIndex ??= 0;

    if (_currentChildIndex! > 0) {
      _currentChildIndex = _currentChildIndex! - 1;
    }
  }
}