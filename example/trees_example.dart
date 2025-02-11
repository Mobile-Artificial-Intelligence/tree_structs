import 'package:tree_structs/tree_structs.dart';

void main() {
  final root = GeneralTreeNode('root');
  root.addChild('child1');
  root.addChild('child2');

  root.currentChild!.addChild('grandchild1');
  root.currentChild!.addChild('grandchild2');

  root.currentChild!.nextChild();

  root.currentChild!.currentChild!.addChild('great-grandchild1');

  print(root.chainData); // [root, child2]
}
