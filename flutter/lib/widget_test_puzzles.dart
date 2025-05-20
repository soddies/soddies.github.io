import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firstproject/main.dart'; // Убедись, что путь корректен

void main() {
  testWidgets('Each puzzle piece appears after tap', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PuzzleScreen(),
    ));

    // Найдём все GestureDetector (их должно быть rows * cols = 9)
    final puzzlePieces = find.byType(GestureDetector);
    expect(puzzlePieces, findsNWidgets(9));

    // Тап по первому пазлу
    await tester.tap(puzzlePieces.first);
    await tester.pumpAndSettle(); // Ждём завершения анимации

    // Проверка: у нас нет явного способа узнать, что opacity поменялся
    // Поэтому можно проверить, что AnimatedOpacity с opacity 1.0 теперь есть хотя бы один
    final visiblePiece = tester.widgetList<AnimatedOpacity>(
      find.byType(AnimatedOpacity),
    ).where((w) => w.opacity == 1.0);

    expect(visiblePiece.length, greaterThan(0));
  });
}
