import 'package:fitness/components/NavButton.dart';
import 'package:fitness/constants.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import './components/CircularDial.dart';
import './components/VerticalDial.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return MaterialApp(
      title: 'FITNESS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'FITNESS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final values = [
    {
      'val': 82,
      'name': 'Relax',
    },
    {
      'val': 0,
      'name': 'Cardio',
    },
    {
      'val': 54,
      'name': 'Strength',
    },
    {
      'val': 91,
      'name': 'Stretch',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffe3f1fb),
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(color: TEXT_COLOR, letterSpacing: 10.0),
          ),
          backgroundColor: Colors.black45.withAlpha(0),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(icon: Icon(Icons.scatter_plot), onPressed: null),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.account_box), onPressed: null),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Statistics',
                    style: TextStyle(fontSize: 30, color: TEXT_COLOR),
                  )
                ],
              ),
              CircularDial(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: values
                    .asMap()
                    .map((index, v) {
                      return MapEntry(
                        index,
                        VerticalDial(
                          name: v['name'],
                          percentage: v['val'],
                          index: index,
                        ),
                      );
                    })
                    .values
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  NavButton(
                    icon: Icons.home,
                  ),
                  NavButton(
                    icon: Icons.fitness_center,
                  ),
                  NavButton(
                    icon: Icons.insert_chart,
                    pressed: true,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
