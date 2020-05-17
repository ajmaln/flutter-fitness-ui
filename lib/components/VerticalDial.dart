import 'dart:ui';

import 'package:fitness/constants.dart';
import 'package:fitness/decorations/concaveDecoration.dart';
import 'package:flutter/material.dart';

const gradients = [
  [
    Color(0xff66b2f5),
    Color(0xff5cd0db),
  ],
  [
    Color(0xff66b2f5),
    Color(0xff5cd0db),
  ],
  [
    Color(0xfff5cc79),
    Color(0xfff4a780),
  ],
  [
    Color(0xfff68bab),
    Color(0xfff675e1),
  ],
];

class VerticalDial extends StatelessWidget {
  VerticalDial({this.percentage = 0, this.index, this.name});

  final int percentage;
  final int index;
  final String name;

  @override
  Widget build(BuildContext context) {
    final innerShadow = ConcaveDecoration(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      colors: [
        Colors.white70,
        Color(0xffB8D6E7),
      ],
      depth: 10,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Filler(
                    index: index,
                    percentage: this.percentage,
                  ),
                ],
              ),
              height: 188,
              width: 38,
            ),
          ),
          decoration: innerShadow,
          height: 200,
          width: 50,
        ),
        Padding(
          padding: EdgeInsets.all(2),
        ),
        Text(
          name,
          style: TextStyle(
              color: TEXT_COLOR, fontSize: 18, fontWeight: FontWeight.w400),
        ),
        Padding(padding: EdgeInsets.all(3)),
        Text('${this.percentage}%',
            style: TextStyle(fontWeight: FontWeight.w800))
      ],
    );
  }
}

class Filler extends StatelessWidget {
  const Filler({
    Key key,
    this.index,
    this.percentage,
  }) : super(key: key);

  final int index;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(''),
      ),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            color: gradients[index][1],
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
          colors: gradients[index],
        ),
      ),
      height: (190 * this.percentage / 100),
      width: 40,
    );
  }
}
