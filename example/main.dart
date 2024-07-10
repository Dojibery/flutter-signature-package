import 'package:flutter/material.dart';
import 'package:flutter_signature_package/flutter_signature_package.dart';
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

class ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dragState = Provider.of<DragState>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.undo),
          onPressed: dragState.undo,
        ),
        IconButton(
          icon: Icon(Icons.redo),
          onPressed: dragState.redo,
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: dragState.clearAll,
        ),
      ],
    );
  }
}
