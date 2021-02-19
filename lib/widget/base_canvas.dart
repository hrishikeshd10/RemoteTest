import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BaseCanvas extends StatelessWidget {
  Widget child;

  BaseCanvas({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                const Color(0xFF333542),
                const Color(0xFF0D0D11),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 1.0],
              tileMode: TileMode.clamp)),
      child: child,
    );
  }
}
