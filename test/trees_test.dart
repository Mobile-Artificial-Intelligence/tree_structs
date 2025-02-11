import 'package:test/test.dart';
import 'package:trees/trees.dart';

void main() {
  group('GeneralTreeNode', () {
    test('addChild should correctly add child nodes', () {
      final root = GeneralTreeNode('root');
      root.addChild('child1');
      root.addChild('child2');
      root.addChild('child3');

      expect(root.child!.data, 'child1');
      expect(root.child!.nextSibling!.data, 'child2');
      expect(root.child!.nextSibling!.nextSibling!.data, 'child3');
    });

    test('removeChild should remove the correct child', () {
      final root = GeneralTreeNode('root');
      root.addChild('child1');
      root.addChild('child2');
      root.addChild('child3');

      root.removeChild('child2');

      expect(root.child!.data, 'child1');
      expect(root.child!.nextSibling!.data, 'child3');
      expect(root.child!.nextSibling!.nextSibling, isNull);
    });

    test('removeChild throws StateError if child not found', () {
      final root = GeneralTreeNode('root');
      root.addChild('child1');

      expect(() => root.removeChild('child2'), throwsStateError);
    });

    test('switchNextSibling updates the parents child pointer', () {
      final root = GeneralTreeNode('root');
      root.addChild('child1');
      root.addChild('child2');

      final child1 = root.child;
      child1!.switchNextSibling();

      expect(root.child!.data, 'child2');
    });

    test('switchLastSibling updates the parents child pointer', () {
      final root = GeneralTreeNode('root');
      root.addChild('child1');
      root.addChild('child2');

      final child2 = root.child!.nextSibling;
      child2!.switchLastSibling();

      expect(root.child!.data, 'child1');
    });

    test('switchNextSibling throws StateError if there is no next sibling', () {
      final root = GeneralTreeNode('root');
      root.addChild('child1');

      expect(() => root.child!.switchNextSibling(), throwsStateError);
    });

    test('switchNextChild updates child pointer of a node', () {
      final root = GeneralTreeNode('root');
      root.addChild('child1');
      root.child!.addChild('grandchild1');
      root.child!.addChild('grandchild2');

      root.child!.switchNextChild();
      expect(root.child!.child!.data, 'grandchild2');
    });

    test('switchLastChild updates child pointer of a node', () {
      final root = GeneralTreeNode('root');
      root.addChild('child1');
      root.child!.addChild('grandchild1');
      root.child!.addChild('grandchild2');

      root.child!.switchNextChild();
      expect(root.child!.child!.data, 'grandchild2');

      root.child!.switchLastChild();
      expect(root.child!.child!.data, 'grandchild1');
    });

    test('removeChild handles the case when the first child is removed', () {
      final root = GeneralTreeNode('root');
      root.addChild('child1');
      root.addChild('child2');

      root.removeChild('child1');

      expect(root.child!.data, 'child2');
    });

    test('removeChild handles removing all children', () {
      final root = GeneralTreeNode('root');
      root.addChild('child1');

      root.removeChild('child1');

      expect(root.child, isNull);
    });

    test('complex tree structure works correctly', () {
      final root = GeneralTreeNode('root');
      root.addChild('child1');
      root.addChild('child2');
      root.child!.addChild('grandchild1');
      root.child!.addChild('grandchild2');

      expect(root.child!.data, 'child1');
      expect(root.child!.child!.data, 'grandchild1');
      expect(root.child!.child!.nextSibling!.data, 'grandchild2');
    });
  });
}