import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_signature_package/flutter_signature_package.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MySignaturePage(),
    );
  }
}

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
                  strokeWidth: 3.0,
                ),
              ),
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
