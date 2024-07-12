## Signature Canvas
A Flutter package for drawing signatures on a canvas. This package provides functionality to draw smooth lines based on user input gestures.

## Features
* Draw smooth lines on a canvas.
* Undo and redo drawing actions.
* Clear the canvas.
* Export the drawn signature as PNG bytes.
* Customize Pan Stroke Width on Canvas

## Installation
Add the following line to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  flutter_signature_package:
    git:
      url: https://github.com/Dojibery/flutter-signature-package
```

## Usage
Import the package in your Dart file:

```dart
import 'package:my_signature_package/flutter_signature_package.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
```

## Explanation 
* **SignatureCanvas**: Widget for drawing signatures based on user input.

## Examples 

### Basic Usage

```dart
class MySignaturePage extends StatelessWidget {
  final SignatureCanvasController signatureCanvasController = SignatureCanvasController();

  void _handleSave(Uint8List pngBytes) {
    // Handle the saved PNG bytes here
    print('Saved PNG bytes: $pngBytes');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signature')),
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SignatureCanvas(
                  backgroundColor: Colors.white,
                  controller: signatureCanvasController,
                  onSave: _handleSave,
                ),              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.undo),
                    onPressed: () {
                      signatureCanvasController.undo();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.redo),
                    onPressed: () {
                      signatureCanvasController.redo();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      signatureCanvasController.clearAll();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () {
                      signatureCanvasController.exportDrawing();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Save Signature as PNG Bytes

```dart
SignatureCanvas(
  onSave: (Uint8List pngBytes) {
    // Handle the saved PNG bytes here
    print('Saved PNG bytes: $pngBytes');
  },
)
```

## Contributing

Contributions are welcome! Feel free to open issues and pull requests to suggest new features, report bugs, or improve the codebase.

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/Dojibery/flutter-signature-package/blob/main/LICENSE)
file for details.
