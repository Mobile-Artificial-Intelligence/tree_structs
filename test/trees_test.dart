import 'package:test/test.dart';
import 'package:tree_structs/tree_structs.dart';

void main() {
  group('GeneralTreeNode', () {
    test('constructor sets data and parent correctly', () {
      final parent = GeneralTreeNode<int>(1);
      final child = GeneralTreeNode<int>(2, parent);

      expect(child.data, 2);
      expect(child.parent, parent);
      expect(parent.children.isEmpty, true);
    });

    test('addChild adds a new child node', () {
      final root = GeneralTreeNode<int>(1);

      root.addChild(2);
      root.addChild(3);

      expect(root.children.length, 2);
      expect(root.children[0].data, 2);
      expect(root.children[1].data, 3);
    });

    test('removeChild removes a child by data', () {
      final root = GeneralTreeNode<int>(1);
      root.addChild(2);
      root.addChild(3);

      root.removeChild(2);

      expect(root.children.length, 1);
      expect(root.children[0].data, 3);
    });

    test('removeChild throws when child is not found', () {
      final root = GeneralTreeNode<int>(1);
      root.addChild(2);

      expect(() => root.removeChild(3), throwsStateError);
    });

    test('removeChildNode removes a specific child node', () {
      final root = GeneralTreeNode<int>(1);
      final child = GeneralTreeNode<int>(2, root);
      root.children.add(child);

      root.removeChildNode(child);

      expect(root.children.isEmpty, true);
    });

    test('siblings returns all siblings of a node', () {
      final root = GeneralTreeNode<int>(1);
      final child1 = GeneralTreeNode<int>(2, root);
      final child2 = GeneralTreeNode<int>(3, root);
      root.children.addAll([child1, child2]);

      expect(child1.siblings.length, 1);
      expect(child1.siblings[0].data, 3);
    });

    test('chain returns the correct chain of nodes', () {
      final root = GeneralTreeNode<int>(1);
      root.addChild(2);
      root.children[0].addChild(3);

      final chain = root.chain;
      expect(chain.length, 3);
      expect(chain.map((node) => node.data), [1, 2, 3]);
    });

    test('bfs finds a node based on a condition', () {
      final root = GeneralTreeNode<int>(1);
      root.addChild(2);
      root.addChild(3);
      root.children[0].addChild(4);

      final result = root.bfs((data) => data == 4);
      expect(result, 4);
    });

    test('dfs finds a node based on a condition', () {
      final root = GeneralTreeNode<int>(1);
      root.addChild(2);
      root.addChild(3);
      root.children[0].addChild(4);

      final result = root.dfs((data) => data == 4);
      expect(result, 4);
    });

    test('nextChild increments the current child index', () {
      final root = GeneralTreeNode<int>(1);
      root.addChild(2);
      root.addChild(3);

      root.nextChild();

      expect(root.currentChild, root.children[1]);
    });

    test('previousChild decrements the current child index', () {
      final root = GeneralTreeNode<int>(1);
      root.addChild(2);
      root.addChild(3);
      root.nextChild();
      root.previousChild();

      expect(root.currentChild, root.children[0]);
    });

    test('childrenData returns the correct list of data', () {
      final root = GeneralTreeNode<int>(1);
      root.addChild(2);
      root.addChild(3);

      expect(root.childrenData, [2, 3]);
    });

    test('siblingsData returns the correct list of sibling data', () {
      final root = GeneralTreeNode<int>(1);
      root.addChild(2);
      root.addChild(3);

      expect(root.children[0].siblingsData, [3]);
    });

    test('chainData returns the correct list of chain data', () {
      final root = GeneralTreeNode<int>(1);
      root.addChild(2);
      root.children[0].addChild(3);

      expect(root.chainData, [1, 2, 3]);
    });

    test('bfsNode returns the correct node', () {
      final root = GeneralTreeNode<int>(1);
      root.addChild(2);
      root.addChild(3);
      root.children[0].addChild(4);

      final result = root.bfsNode((node) => node.data == 4);
      expect(result?.data, 4);
    });

    test('dfsNode returns the correct node', () {
      final root = GeneralTreeNode<int>(1);
      root.addChild(2);
      root.addChild(3);
      root.children[0].addChild(4);

      final result = root.dfsNode((node) => node.data == 4);
      expect(result?.data, 4);
    });
  });
}
