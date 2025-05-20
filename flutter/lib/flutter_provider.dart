import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TimerModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Provider пример'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Consumer<TimerModel>(
                builder: (context, timerModel, child) {
                  return Text('Счет: ${timerModel.counter}');
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<TimerModel>(context, listen: false).incrementCounter();
                },
                child: Text('Изменить счет'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimerModel extends ChangeNotifier {
  int _counter = 0;

  TimerModel() {
    _loadCounter();
  }

  int get counter => _counter;

  void incrementCounter() async {
    _counter++;
    notifyListeners();
    await _saveCounter();
  }

  Future<void> _saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', _counter);
  }

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('counter') ?? 0;
    notifyListeners();
  }
}
