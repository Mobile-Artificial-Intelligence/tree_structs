import 'package:tree_structs/tree_structs.dart';

void main() {
  final tree = GeneralTree<String>([]);
  tree.addRoot('root');
  tree.currentRoot!.chain[0].addChild('child1');
  tree.currentRoot!.chain[0].addChild('child2');
  tree.currentRoot!.chain[1].addChild('grandchild1');
  tree.currentRoot!.chain[1].addChild('grandchild2');
  tree.currentRoot!.chain[2].addChild('greatgrandchild1');
  tree.currentRoot!.chain[2].addChild('greatgrandchild2');

  print(tree.currentRoot!.chainData);
}
