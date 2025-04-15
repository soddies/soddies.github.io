import 'package:flutter/material.dart';

void main() {
  runApp(const Myapp());
}

class Myapp extends StatefulWidget {
  const Myapp(); //конструктор
  @override
  State<Myapp> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Myapp> {
  double x = 100;
  double y = 100;
  @override
  Widget build(BuildContext context) {
    print("building");

    return MaterialApp(
      title: 'Flutter Demo',
      home: Column(
        children: [
          /* GridView.count(
            crossAxisCount: 2,
            children: [
              Center(
                child: Text(
                  'Item 1',
                  style: TextTheme.of(context).headlineSmall,
                ),
              ),
            ],
          ),*/
          //          Padding(padding: ,)
          Container(
            //            padding: EdgeInsets.only(top: 50),
            width: x,
            height: y,
            color: Colors.red,
          ),
          Text("hello!"),
          Text('$x'),
          ElevatedButton(
            onPressed: () {
              //как будто запускает build заново
              setState(() {
                x += 10;
                y += 10;
              });
              print("hello");
            },
            child: Text("click me"),
          ),
        ],
      ),
    );
  }
}
