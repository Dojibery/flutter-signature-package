import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';

class SignatureCanvas extends StatefulWidget {
  final Color backgroundColor;
  final SignatureCanvasController controller;
  final Function(Uint8List)? onSave;

  const SignatureCanvas({
    Key? key,
    this.backgroundColor = Colors.white,
    required this.controller,
    this.onSave,
  }) : super(key: key);

  @override
  _SignatureCanvasState createState() => _SignatureCanvasState();
}

class _SignatureCanvasState extends State<SignatureCanvas> {
  late List<Offset> drawingPoints;
  late List<List<Offset>> undoDrawingPoints;
  late List<List<Offset>> redoDrawingPoints;

  @override
  void initState() {
    super.initState();
    drawingPoints = [];
    undoDrawingPoints = [];
    redoDrawingPoints = [];
    // Attach controller's functions directly
    widget.controller.addDrawingPoint = addDrawingPoint;
    widget.controller.startNewBatch = startNewBatch;
    widget.controller.undo = undo;
    widget.controller.redo = redo;
    widget.controller.clearAll = clearAll;
    widget.controller.exportDrawing = _exportDrawing;
  }

  void addDrawingPoint(Offset point) {
    setState(() {
      drawingPoints.add(point);
    });
  }

  void startNewBatch() {
    setState(() {
      _saveDrawingStateForUndo();
      redoDrawingPoints.clear();
    });
  }

  void undo() {
    if (undoDrawingPoints.isNotEmpty) {
      setState(() {
        _saveDrawingStateForRedo();
        drawingPoints = undoDrawingPoints.removeLast();
      });
    }
  }

  void redo() {
    if (redoDrawingPoints.isNotEmpty) {
      setState(() {
        _saveDrawingStateForUndo();
        drawingPoints = redoDrawingPoints.removeLast();
      });
    }
  }

  void clearAll() {
    setState(() {
      _saveDrawingStateForUndo();
      drawingPoints.clear();
    });
  }

  void _saveDrawingStateForUndo() {
    undoDrawingPoints.add(List.from(drawingPoints));
    if (undoDrawingPoints.length > 10) {
      undoDrawingPoints.removeAt(0);
    }
  }

  void _saveDrawingStateForRedo() {
    redoDrawingPoints.add(List.from(drawingPoints));
    if (redoDrawingPoints.length > 10) {
      redoDrawingPoints.removeAt(0);
    }
  }

  Future<void> _exportDrawing() async {
    if (widget.onSave != null) {
      // Create a picture recorder to capture the drawing
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      // Draw the signature
      final paint = Paint()
        ..color = Colors.black
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      Path path = Path();
      path.moveTo(drawingPoints.first.dx, drawingPoints.first.dy);
      for (int i = 1; i < drawingPoints.length; i++) {
        path.lineTo(drawingPoints[i].dx, drawingPoints[i].dy);
      }
      canvas.drawPath(path, paint);

      // End recording and export to PNG bytes
      final picture = recorder.endRecording();
      final img = await picture.toImage(
        drawingPoints.last.dx.toInt(),
        drawingPoints.last.dy.toInt(),
      );
      final pngBytes = await img.toByteData(format: ImageByteFormat.png);
      widget.onSave!(pngBytes!.buffer.asUint8List());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        widget.controller.startNewBatch();
      },
      onPanUpdate: (details) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final point = renderBox.globalToLocal(details.localPosition);
        widget.controller.addDrawingPoint(point);
      },
      child: ClipRect(
        child: Container(
          color: widget.backgroundColor,
          child: CustomPaint(
            size: Size.infinite,
            painter: SignaturePainter(drawingPoints: drawingPoints),
          ),
        ),
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<Offset> drawingPoints;
  final double thresholdDistance = 200;

  SignaturePainter({required this.drawingPoints});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    if (drawingPoints.isEmpty) return;

    Path path = Path();
    path.moveTo(drawingPoints.first.dx, drawingPoints.first.dy);

    for (int i = 1; i < drawingPoints.length; i++) {
      if ((drawingPoints[i] - drawingPoints[i - 1]).distance > thresholdDistance) {
        path.moveTo(drawingPoints[i].dx, drawingPoints[i].dy);
      } else {
        path.lineTo(drawingPoints[i].dx, drawingPoints[i].dy);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SignatureCanvasController {
  late void Function(Offset) addDrawingPoint;
  late void Function() startNewBatch;
  late void Function() undo;
  late void Function() redo;
  late void Function() clearAll;
  late Future<void> Function() exportDrawing;

  SignatureCanvasController() {
    // Initialize functions with empty implementations
    addDrawingPoint = (Offset point) {};
    startNewBatch = () {};
    undo = () {};
    redo = () {};
    clearAll = () {};
    exportDrawing = () async {};
  }
}
