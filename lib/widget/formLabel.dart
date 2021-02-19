import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormLabel extends StatelessWidget {
  String text;
  Color labelColor;
  double fontSize;
  TextAlign textAlignment;
  int maxLines;
  FontWeight fontweight;
  String fontfamily;

  FormLabel(
      {Key key,
      this.text,
      this.labelColor = Colors.white,
      this.fontSize = 15,
      this.textAlignment = TextAlign.left,
      this.fontweight,
      this.maxLines,
      this.fontfamily})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.maxLines == null) {
      maxLines = 1;
    }

    return Text(
      text,
      maxLines: 10,
      textAlign: textAlignment,
      style: TextStyle(
        color: labelColor,
        fontSize: fontSize,
        fontWeight: fontweight,
      ),
    );
  }
}
