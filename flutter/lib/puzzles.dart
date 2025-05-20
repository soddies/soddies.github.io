import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PuzzleScreen(),
    );
  }
}

class PuzzleScreen extends StatefulWidget {
  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  final int rows = 3;
  final int cols = 3;

  late List<bool> _revealed;

  @override
  void initState() {
    super.initState();
    _revealed = List<bool>.filled(rows * cols, false);
  }

  void _revealPiece(int index) {
    setState(() {
      _revealed[index] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Пазлы'),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double size = constraints.maxWidth < constraints.maxHeight
                ? constraints.maxWidth
                : constraints.maxHeight;

            double pieceSize = size / cols;

            return Container(
              width: size,
              height: size,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                ),
                itemCount: rows * cols,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _revealPiece(index);
                    },
                    child: _revealed[index]
                        ? ImagePiece(
                            imagePath: 'assets/space.jpg',
                            rows: rows,
                            cols: cols,
                            index: index,
                            pieceSize: pieceSize,
                          )
                        : Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.black12,
                            ),
                          ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class ImagePiece extends StatelessWidget {
  final String imagePath;
  final int rows;
  final int cols;
  final int index;
  final double pieceSize;

  ImagePiece({
    required this.imagePath,
    required this.rows,
    required this.cols,
    required this.index,
    required this.pieceSize,
  });

  @override
  Widget build(BuildContext context) {
    final int row = index ~/ cols;
    final int col = index % cols;

    return ClipPath(
      clipper: PuzzlePieceClipper(
        row: row,
        col: col,
        rows: rows,
        cols: cols,
        size: pieceSize,
      ),
      child: SizedBox(
        width: pieceSize,
        height: pieceSize,
        child: OverflowBox(
          maxWidth: pieceSize * cols,
          maxHeight: pieceSize * rows,
          alignment: Alignment.topLeft,
          child: Transform.translate(
            offset: Offset(-col * pieceSize, -row * pieceSize),
            child: Image.asset(
              imagePath,
              width: pieceSize * cols,
              height: pieceSize * rows,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class PuzzlePieceClipper extends CustomClipper<Path> {
  final int row;
  final int col;
  final int rows;
  final int cols;
  final double size;

  PuzzlePieceClipper({
    required this.row,
    required this.col,
    required this.rows,
    required this.cols,
    required this.size,
  });

  double get pieceSize => size;
  double get tabSize => pieceSize / 4;

  @override
  Path getClip(Size size) {
    final path = Path();
    double s = pieceSize;
    double t = tabSize;

    path.moveTo(0, 0);

    // Верхняя сторона
    if (row == 0) {
      path.lineTo(s, 0);
    } else {
      bool isTab = (row + col) % 2 == 0;

      path.lineTo(s / 3, 0);

      if (isTab) {
        path.cubicTo(
          s / 3 + t / 2, -t,
          s / 3 * 2 - t / 2, -t,
          s / 3 * 2, 0,
        );
      } else {
        path.cubicTo(
          s / 3 + t / 2, t,
          s / 3 * 2 - t / 2, t,
          s / 3 * 2, 0,
        );
      }

      path.lineTo(s, 0);
    }

    // Правая сторона
    if (col == cols - 1) {
      path.lineTo(s, s);
    } else {
      bool isTab = (row + col) % 2 != 0;
      path.lineTo(s, s / 3);

      if (isTab) {
        path.cubicTo(
          s + t, s / 3 + t / 2,
          s + t, s / 3 * 2 - t / 2,
          s, s / 3 * 2,
        );
      } else {
        path.cubicTo(
          s - t, s / 3 + t / 2,
          s - t, s / 3 * 2 - t / 2,
          s, s / 3 * 2,
        );
      }

      path.lineTo(s, s);
    }

    // Нижняя сторона
    if (row == rows - 1) {
      path.lineTo(0, s);
    } else {
      bool isTab = (row + col) % 2 == 0;
      path.lineTo(s / 3 * 2, s);

      if (isTab) {
        path.cubicTo(
          s / 3 * 2 - t / 2, s + t,
          s / 3 + t / 2, s + t,
          s / 3, s,
        );
      } else {
        path.cubicTo(
          s / 3 * 2 - t / 2, s - t,
          s / 3 + t / 2, s - t,
          s / 3, s,
        );
      }

      path.lineTo(0, s);
    }

    // Левая сторона
    if (col == 0) {
      path.close();
    } else {
      bool isTab = (row + col) % 2 != 0;
      path.lineTo(0, s / 3 * 2);

      if (isTab) {
        path.cubicTo(
          -t, s / 3 * 2 - t / 2,
          -t, s / 3 + t / 2,
          0, s / 3,
        );
      } else {
        path.cubicTo(
          t, s / 3 * 2 - t / 2,
          t, s / 3 + t / 2,
          0, s / 3,
        );
      }

      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
