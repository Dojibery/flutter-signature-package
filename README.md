## Signature Canvas
A Flutter package for drawing signatures on a canvas. This package provides functionality to draw smooth lines based on user input gestures.

## Features
* Draw smooth lines on a canvas.
* Undo and redo drawing actions.
* Clear the canvas.

## Installation
Add the following line to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  my_signature_package:
    git:
      url: https://github.com/Dojibery/flutter-signature-package
```

## Usage
Import the package in your Dart file:

```dart
import 'package:my_signature_package/flutter_signature_package.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DragState(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Signature Canvas Example'),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(child: SignatureCanvas()),
                ActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## Explanation 
* **DragState**: Manages the state of drawing points, undo, redo operations.
* **SignatureCanvas**: Widget for drawing signatures based on user input.
* **ActionButtons**: Provides UI buttons for undo, redo, and clear actions.

## Examples 

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:my_signature_package/flutter_signature_package.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DragState(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Signature Canvas Example'),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(child: SignatureCanvas()),
                ActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## Customize Stroke Width

```dart
SignaturePainter(
  drawingPoints: dragState.drawingPoints,
  strokeWidth: 4.0, // Adjust stroke width for thicker lines
)
```

## Contributing

Contributions are welcome! Feel free to open issues and pull requests to suggest new features, report bugs, or improve the codebase.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
