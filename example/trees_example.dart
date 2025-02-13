import 'package:tree_structs/tree_structs.dart';

void main() {
  final root = GeneralTreeNode<String>('root');
  root.chain[0].addChild('child1');
  root.chain[0].addChild('child2');
  root.chain[1].addChild('grandchild1');
  root.chain[1].addChild('grandchild2');
  root.chain[2].addChild('greatgrandchild1');
  root.chain[2].addChild('greatgrandchild2');

  print(root.chainData);
}
