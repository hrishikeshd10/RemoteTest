import 'package:flutter/material.dart';

class RoundedMaterialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double elevation;

  RoundedMaterialButton(
      {Key key,
      @required this.onPressed,
      @required this.child,
      this.elevation: 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: StadiumBorder(),
      onPressed: onPressed,
      color: Color(0xff3B3D4B),
      child: child,
      elevation: elevation,
    );
  }
}
