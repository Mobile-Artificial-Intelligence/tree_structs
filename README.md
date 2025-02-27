# tree_structs

A dart library for working with tree structures.

## Features

- Support for general trees
- bfs and dfs traversal

## Getting started

To use this package, add `tree_structs` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

```yaml
dependencies:
  tree_structs: ^1.0.7
```

Import the package in your code:

```dart
import 'package:tree_structs/tree_structs.dart';
```

## Usage

An example of creating a tree and traversing it:

```dart
final root = GeneralTreeNode<String>('root');

root.chain[0].addChild('child1');
root.chain[0].addChild('child2');
root.chain[1].addChild('grandchild1');
root.chain[1].addChild('grandchild2');
root.chain[2].addChild('greatgrandchild1');
root.chain[2].addChild('greatgrandchild2');

print(root.chainData);
```

## License

```
MIT License

Copyright (c) 2025 Dane Madsen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
