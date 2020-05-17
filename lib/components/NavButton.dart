import 'package:fitness/constants.dart';
import 'package:fitness/decorations/concaveDecoration.dart';
import 'package:flutter/material.dart';

class NavButton extends StatefulWidget {
  NavButton({
    this.icon,
    this.pressed = false,
  });

  final IconData icon;
  final bool pressed;

  @override
  _NavButtonState createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  bool isPressed;

  @override
  void initState() {
    super.initState();
    setState(() {
      isPressed = widget.pressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // splashColor: Colors.red,
      onTap: () {
        setState(() {
          isPressed = !isPressed;
        });
      },
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
      child: Container(
        height: 60,
        width: 60,
        decoration: isPressed
            ? ConcaveDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                depth: 10,
                colors: [
                  Colors.white70,
                  Color(0xffB8D6E7),
                ],
              )
            : BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
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
        child: Icon(
          widget.icon,
          color: TEXT_COLOR,
        ),
      ),
    );
  }
}
