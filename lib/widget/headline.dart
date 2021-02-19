import 'package:flutter/material.dart';

class CustomHeadline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "MY NEIGHBOURHOOD",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 7,
              color: Colors.white),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 1,
              width: 30,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text("ONLINE",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Baske9',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 7,
                )),
            SizedBox(
              width: 10,
            ),
            Container(
              height: 1,
              width: 30,
              color: Colors.white,
            )
          ],
        ),
      ],
    );
  }
}
