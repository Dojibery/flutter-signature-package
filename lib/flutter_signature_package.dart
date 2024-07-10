library signature_package;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DragState extends ChangeNotifier {
  List<Offset> drawingPoints = [];
  List<List<Offset>> undoDrawingPoints = [];
  List<List<Offset>> redoDrawingPoints = [];
  bool isDrawing = true; // By default, enable drawing

  void addDrawingPoint(Offset point) {
    drawingPoints.add(point);
    notifyListeners();
  }

  void startNewBatch() {
    _saveDrawingStateForUndo();
    redoDrawingPoints.clear(); // Clear redo history when starting a new batch
  }

  void undo() {
    if (undoDrawingPoints.isNotEmpty) {
      _saveDrawingStateForRedo();
      drawingPoints = undoDrawingPoints.removeLast();
      notifyListeners();
    }
  }

  void redo() {
    if (redoDrawingPoints.isNotEmpty) {
      _saveDrawingStateForUndo();
      drawingPoints = redoDrawingPoints.removeLast();
      notifyListeners();
    }
  }

  void clearAll() {
    _saveDrawingStateForUndo();
    drawingPoints.clear();
    notifyListeners();
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
}

class SignatureCanvas extends StatefulWidget {
  @override
  _SignatureCanvasState createState() => _SignatureCanvasState();
}

class _SignatureCanvasState extends State<SignatureCanvas> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DragState>(
      builder: (context, dragState, child) {
        return GestureDetector(
          onPanStart: (details) {
            dragState.startNewBatch();
          },
          onPanUpdate: (details) {
            if (dragState.isDrawing) {
              final RenderBox renderBox = context.findRenderObject() as RenderBox;
              final point = renderBox.globalToLocal(details.localPosition);
              dragState.addDrawingPoint(point);
            }
          },
          child: CustomPaint(
            size: Size.infinite,
            painter: SignaturePainter(drawingPoints: dragState.drawingPoints),
          ),
        );
      },
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<Offset> drawingPoints;
  final double thresholdDistance;

  SignaturePainter({required this.drawingPoints, this.thresholdDistance = 200.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0 // Adjust the stroke width for a more suitable signature appearance
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
