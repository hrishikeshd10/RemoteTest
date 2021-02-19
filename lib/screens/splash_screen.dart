import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_neighbourhood_online/Utilities/key_constants.dart';
import 'package:my_neighbourhood_online/route_transitions/dart/route_transitions.dart';
import 'package:my_neighbourhood_online/screens/home_page.dart';
import 'package:my_neighbourhood_online/screens/login.dart';
import 'package:my_neighbourhood_online/widget/base_canvas.dart';
import 'package:my_neighbourhood_online/widget/headline.dart';
import 'package:my_neighbourhood_online/widget/material_rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

int finalUserID;
String finalUserName;
String finalUserEmail;
String finalUserContact;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _checkPermission().then((bool isGranted) {
      if (isGranted ?? true) {
        getValidatinData().whenComplete(() async {
          loadData();
        });
      } else {
        showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Location Permission '),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                        'Please grant the location permission from the app settings to use the app.'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () => exit(0),
                ),
              ],
            );
          },
        );
      }
    });
  }

  Future<bool> _checkPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return false;
      }
    } else {
      return true;
    }
  }

  Future getValidatinData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    var userIDFromSP = await preferences.getInt(SPKeys.userID);
    var userNameFromSP = await preferences.getString(SPKeys.firstName);
    var userEmailFromSP = await preferences.getString(SPKeys.userEmail);
    var userContactFromSP = await preferences.getInt(SPKeys.userContact);
    var userProfileFromSP = await preferences.getString(SPKeys.profileImageURL);

    setState(() {
      GlobalUserDetails.userID = userIDFromSP;
      GlobalUserDetails.userName = userNameFromSP;
      GlobalUserDetails.userContact = userContactFromSP;
      GlobalUserDetails.userEmail = userEmailFromSP;

      GlobalUserDetails.profileImageURL = userProfileFromSP;
      print("Splash Screen : ${GlobalUserDetails.profileImageURL}");
      finalUserID = userIDFromSP;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Height is ${MediaQuery.of(context).size.height}");
    return Material(
      child: BaseCanvas(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 3, child: CustomHeadline()),
              Expanded(
                flex: 1,
                child: AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 250,
                          child: Text("360 tour in and around neighbourhood",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Futura Light',
                                  letterSpacing: 1.2,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60.0),
                          child: RoundedMaterialButton(
                            onPressed: () {
                              Navigator.push(context, FadeRoute(page: Login()));
                            },
                            child: SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  "CONTINUE",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily: 'Futura Light',
                                      fontSize: 16,
                                      color: Colors.white,
                                      letterSpacing: 1.3,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 1), onDoneLoading);
  }

  onDoneLoading() async {
    if (GlobalUserDetails.userID != null) {
      Navigator.push(context, FadeRoute(page: HomePage()));
    } else {
      setState(() {
        _visible = !_visible;
      });
    }
  }
}
