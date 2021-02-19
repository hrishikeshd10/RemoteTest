import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapLauncher {
  GoogleMapLauncher._();

  static Future<void> openMap(String url) async {
    String googleUrl = url;
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      Fluttertoast.showToast(
          msg: "Invalid maps link",
          backgroundColor: Colors.red,
          textColor: Colors.white);
      throw 'Could not open the map.';
    }
  }
}
