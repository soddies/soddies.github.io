import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(PainterApp());
}

class PainterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Приложение для рисования',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PainterScreen(),
    );
  }
}

class PainterScreen extends StatefulWidget {
  @override
  _PainterScreenState createState() => _PainterScreenState();
}

class _PainterScreenState extends State<PainterScreen> {
  List<DrawingPoint> _points = [];
  double _strokeWidth = 10.0;
  Color _selectedColor = Colors.black;

  void _updateStrokeWidth(double increment) {
    setState(() {
      _strokeWidth += increment;
      if (_strokeWidth < 5) _strokeWidth = 5;
      if (_strokeWidth > 50) _strokeWidth = 50;
    });
  }

  void _clearCanvas() {
    setState(() {
      _points.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Painter App'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => _updateStrokeWidth(-5),
                ),
                Text('$_strokeWidth'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _updateStrokeWidth(5),
                ),
                SizedBox(width: 20),
                ColorPickerButton(
                  selectedColor: _selectedColor,
                  onColorChanged: (color) {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: _clearCanvas,
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  Offset localPosition = renderBox.globalToLocal(details.globalPosition);
                  print('Adding point at: $localPosition'); // Debug output
                  _points.add(DrawingPoint(
                    localPosition,
                    _strokeWidth,
                    _selectedColor,
                  ));
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _points.add(DrawingPoint(Offset(-1, -1), _strokeWidth, _selectedColor));
                });
              },
              child: CustomPaint(
                painter: Painter(_points),
                child: Container(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawingPoint {
  final Offset offset;
  final double strokeWidth;
  final Color color;

  DrawingPoint(this.offset, this.strokeWidth, this.color);
}

class Painter extends CustomPainter {
  final List<DrawingPoint> points;

  Painter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    print('Painting ${points.length} points'); // Debug output
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].offset != Offset(-1, -1) && points[i + 1].offset != Offset(-1, -1)) {
        Paint paint = Paint()
          ..color = points[i].color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = points[i].strokeWidth;

        canvas.drawLine(points[i].offset, points[i + 1].offset, paint);
      } else if (points[i].offset != Offset(-1, -1) && points[i + 1].offset == Offset(-1, -1)) {
        Paint paint = Paint()
          ..color = points[i].color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = points[i].strokeWidth;

        canvas.drawCircle(points[i].offset, points[i].strokeWidth / 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ColorPickerButton extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;

  ColorPickerButton({required this.selectedColor, required this.onColorChanged});

  void _pickColor(BuildContext context) {
    print('Opening color picker dialog'); // Debug output
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                print('Color changed to: $color'); // Debug output
                onColorChanged(color);
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.color_lens, color: selectedColor),
      onPressed: () => _pickColor(context),
    );
  }
}
