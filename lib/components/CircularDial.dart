import 'dart:math';

import 'package:fitness/decorations/concaveDecoration.dart';
import 'package:flutter/material.dart';

class CircularDial extends StatefulWidget {
  @override
  _CircularDialState createState() => _CircularDialState();
}

class _CircularDialState extends State<CircularDial> {
  double percentage;

  @override
  void initState() {
    super.initState();
    setState(() {
      percentage = 73.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffe3f1fb),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            blurRadius: 25.0,
            spreadRadius: 2,
            offset: Offset(-10.0, -10.0),
          ),
          BoxShadow(
            color: Color(0xffB8D6E7),
            blurRadius: 25.0,
            spreadRadius: 2,
            offset: Offset(10.0, 10.0),
          ),
        ],
      ),
      height: 220,
      width: 220,
      child: Padding(
        padding: EdgeInsets.all(16),
        // child: InsetCircle(
        //   percentage: percentage,
        // ),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: InsetCircle(
                percentage: percentage,
              ),
            ),
            Align(
              child: Text(
                '${percentage.round()}%',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: percentage > 45 ? Colors.white : Colors.black),
              ),
              heightFactor: 7.7,
              alignment: Alignment.bottomCenter,
            )
          ],
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;
  MyPainter({
    this.lineColor,
    this.completeColor,
    this.completePercent,
    this.width,
  });

  final Gradient gradient = new LinearGradient(
    colors: <Color>[
      Color(0xff717ae4),
      Color(0xff9c5bcd),
    ],
  );

  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    final rect = new Rect.fromCircle(center: center, radius: radius);

    Paint line = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, convertRadiusToSigma(15))
      ..strokeWidth = width;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..shader = gradient.createShader(rect)
      ..strokeWidth = width;

    double arcAngle = 2 * pi * (completePercent / 100);
    canvas.drawArc(rect, -pi / 2, arcAngle, false, line);
    canvas.drawArc(rect, -pi / 2, arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class InsetCircle extends StatelessWidget {
  const InsetCircle({Key key, this.percentage}) : super(key: key);

  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(23.0),
        child: new CustomPaint(
          foregroundPainter: new MyPainter(
            lineColor: Colors.transparent,
            completeColor: Colors.blueAccent,
            completePercent: percentage,
            width: 42.0,
          ),
          child: Center(
            child: NotchCircle(
              text: '${percentage.round()}%',
            ),
          ),
        ),
      ),
      decoration: ConcaveDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(190),
        ),
        colors: [
          Colors.white70,
          Color(0xffB8D6E7),
        ],
        depth: 10,
      ),
      height: 190,
      width: 190,
    );
  }
}

class NotchCircle extends StatelessWidget {
  const NotchCircle({
    Key key,
    this.text,
  }) : super(key: key);

  final text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(''),
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffe3f1fb),
        boxShadow: [
          BoxShadow(
              color: Colors.white,
              blurRadius: 25.0,
              spreadRadius: 2,
              offset: Offset(-10.0, -10.0)),
          BoxShadow(
              color: Color(0xffB8D6E7),
              blurRadius: 25.0,
              spreadRadius: 2,
              offset: Offset(10.0, 10.0)),
        ],
      ),
      height: 100,
      width: 100,
    );
  }
}
