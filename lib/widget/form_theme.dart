import 'package:flutter/material.dart';

Theme formTheme({Widget child}) {
  return Theme(
    data: new ThemeData(
        primaryColor: Color(0xff71727b),
        accentColor: Color(0xff71727B),
        hintColor: Colors.white60),
    child: child,
  );
}
