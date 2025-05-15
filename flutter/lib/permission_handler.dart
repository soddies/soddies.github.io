import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Запрос на разрешение. Тест'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('Запросить разрешения'),
            onPressed: () async {
              print('Button pressed'); // Отладочное сообщение

              // Запрос разрешения на доступ к микрофону
              var microphoneStatus = await Permission.microphone.request();
              print('Microphone permission status: $microphoneStatus'); // Отладочное сообщение
              _showPermissionDialog(
                  context,
                  microphoneStatus.isGranted
                      ? 'Разрешение на доступ к микрофону получено'
                      : 'Разрешение на доступ к микрофону отклонено');

              // Запрос разрешения на доступ к геолокации
              var locationStatus = await Permission.location.request();
              print('Location permission status: $locationStatus'); // Отладочное сообщение
              _showPermissionDialog(
                  context,
                  locationStatus.isGranted
                      ? 'Разрешение на доступ к геолокации получено'
                      : 'Разрешение на доступ к геолокации отклонено');
            },
          ),
        ),
      ),
    );
  }

  void _showPermissionDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Запрос разрешения'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
