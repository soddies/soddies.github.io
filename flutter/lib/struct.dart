import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Структура")),
        body: Center(
          child: Container(
            width: 300, // Ширина контейнера
            height: 400, // Высота контейнера
            color: Colors.white, // Цвет фона
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Распределяет детей по вертикали с равными промежутками
              children: [
                // Верхняя часть
                Container(
                  height: 100, // Высота верхнего контейнера
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        color: Colors.blue,
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center, // Центрирует синий блок по вертикали
                  ),
                ),

                // Средняя часть
                Container(
                  height: 100, // Высота среднего контейнера
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          color: Colors.white,
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Распределяет детей по горизонтали с равными промежутками
                  ),
                ),

                // Нижняя часть
                Container(
                  height: 100, // Высота нижнего контейнера
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        color: Colors.red,
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center, // Центрирует красный блок по вертикали
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
