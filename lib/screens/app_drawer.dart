import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:my_neighbourhood_online/Networking/all_urls.dart';
import 'package:my_neighbourhood_online/Utilities/key_constants.dart';
import 'package:my_neighbourhood_online/api_response_model/rating_feedback_response.dart';
import 'package:my_neighbourhood_online/route_transitions/dart/route_transitions.dart';
import 'package:my_neighbourhood_online/screens/contact_us_page.dart';
import 'package:my_neighbourhood_online/screens/favourites_page.dart';
import 'package:my_neighbourhood_online/screens/home_page.dart';
import 'package:my_neighbourhood_online/screens/list_your_business_page.dart';
import 'package:my_neighbourhood_online/screens/login.dart';
import 'package:my_neighbourhood_online/screens/user_profile.dart';
import 'package:my_neighbourhood_online/widget/custom_loader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var logger = Logger(printer: PrettyPrinter(methodCount: 0));
  String loginMethod;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void getSharedPreferences() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      loginMethod = pref.getString(SPKeys.loginMethod);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.grey
                .shade100, //This will change the drawer background to blue.
            //other styles
          ),
          child: Drawer(
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        const Color(0xFF333542),
                        const Color(0xFF0D0D11),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.001, 1.0],
                      tileMode: TileMode.repeated)),
              child: Stack(
                children: [
                  buildTitleContainer(),
                  Positioned.fill(
                    top: Platform.isAndroid
                        ? MediaQuery.of(context).size.height * 0.12
                        : MediaQuery.of(context).size.height <= 670
                            ? MediaQuery.of(context).size.width * 0.3
                            : MediaQuery.of(context).size.width * 0.18,
                    left: 30,
                    child: buildOptionsListView(context),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: Container(
                        width: double.infinity,
                        child: RaisedButton(
                          color: Color(0xff3B3D4B),
                          shape: StadiumBorder(),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              child: Text(
                                "SHARE THE APP",
                                style: TextStyle(color: Colors.white),
                              )),
                          onPressed: () {
                            Platform.isAndroid
                                ? Share.share(
                                    "Hey there!... Please download our Android App from Play Store to get your guide to the luxurious lifestyle Properties.\nhttps://play.google.com/store/apps/details?id=com.ortclient.my_neighborhood_online",
                                    subject: "MNO Share")
                                : Share.share(
                                    "Hey there!... Please download our iOS App from App Store to get your guide to the luxurious lifestyle Properties.\nhttps://play.google.com/store/apps/details?id=com.ortclient.my_neighborhood_online",
                                    subject: "MNO Share");
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildOptionsListView(BuildContext context) {
    print(GlobalUserDetails.profileImageURL);
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GlobalUserDetails.profileImageURL == null
                ? CircleAvatar(
                    minRadius: 40,
                    backgroundColor: Colors.grey.shade300,
                    child: Center(
                        child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                    )),
                  )
                : CircleAvatar(
                    minRadius: 40,
                    backgroundImage:
                        NetworkImage(GlobalUserDetails.profileImageURL),
                    backgroundColor: Colors.grey.shade300,
                    // child: Center(
                    //   child: IconButton(
                    //     icon: Icon(
                    //       Icons.camera_alt_outlined,
                    //       color: Colors.grey,
                    //     ),
                    //   ),
                    // ),
                  ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    GlobalUserDetails.userName ?? "",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  (GlobalUserDetails.userContact == null)
                      ? Text(
                          GlobalUserDetails.userEmail,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.4)),
                        )
                      : Text(
                          GlobalUserDetails.userContact.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.6)),
                        )
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
            padding: EdgeInsets.only(left: 5),
            child: ListTile(
              title: Text("Home",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onTap: () {
                Navigator.push(context, FadeRoute(page: HomePage()));
              },
            )),
        Padding(
            padding: EdgeInsets.only(left: 5),
            child: ListTile(
              title: Text("My Profile",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onTap: () {
                Navigator.push(context, FadeRoute(page: UseProfilePage()));
              },
            )),
        Padding(
            padding: EdgeInsets.only(left: 5),
            child: ListTile(
              title: Text("Favourite Properties",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, FadeRoute(page: FavouritesPage()));
              },
            )),
        Padding(
            padding: EdgeInsets.only(left: 5),
            child: ListTile(
              title: Text("List your Business",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context, FadeRoute(page: ListYourBusinessPage()));
              },
            )),
        Padding(
            padding: EdgeInsets.only(left: 5),
            child: ListTile(
              title: Text("Contact Us",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, FadeRoute(page: ContactUsPage()));
              },
            )),
        Padding(
            padding: EdgeInsets.only(left: 5),
            child: ListTile(
              title: Text("Give app feedback",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onTap: () {
                _openCustomDialog(context);
              },
            )),
        Padding(
            padding: EdgeInsets.only(left: 5),
            child: ListTile(
              title: Text("Logout",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onTap: () {
                _openLogoutConfirmationDialog(context);
              },
            )),
      ],
    );
  }

  void _openCustomDialog(BuildContext context) {
    double rating = 0.5;
    TextEditingController feedbackController = TextEditingController();
    bool loading = false;
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Material(
            color: Colors.transparent,
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: Center(
                  child: Stack(
                    overflow: Overflow.visible,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          height: 300,
                          width: 500,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Center(
                                  child: Text(
                                    "Give Feedback",
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text(
                                    "Rate the App",
                                    style: TextStyle(
                                        color: Colors.blueGrey, fontSize: 15),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: RatingBar.builder(
                                    initialRating: 0.5,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.black,
                                    ),
                                    onRatingUpdate: (newRating) {
                                      print(rating);
                                      setState(() {
                                        rating = newRating;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: feedbackController,
                                  keyboardType: TextInputType.text,
                                  obscureText: false,
                                  maxLines: 5,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black.withOpacity(0.6)),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20.0, 5, 20.0, 5),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black.withOpacity(0.8),
                                          width: 2),
                                    ),
                                    hintText: "Feedback ",
                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(fontSize: 15),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                loading
                                    ? CustomLoader()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RaisedButton(
                                            color: Colors.blueGrey,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Center(
                                              child: Text(
                                                "CANCEL",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          RaisedButton(
                                            color: Colors.black,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Center(
                                              child: Text(
                                                "SUBMIT",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            onPressed: () async {
                                              Map<String, dynamic> body = {
                                                "userID": GlobalUserDetails
                                                    .userID
                                                    .toString(),
                                                "rating": rating.toString(),
                                                "feedback":
                                                    feedbackController.text,
                                              };

                                              logger
                                                  .d("Contact US body: $body");
                                              try {
                                                // final SharedPreferences preferences =
                                                //     await SharedPreferences.getInstance();

                                                setState(() {
                                                  loading = true;
                                                });
                                                FormData formData =
                                                    new FormData.fromMap(body);
                                                Response response = await Dio()
                                                    .post(
                                                        AllUrls()
                                                            .ratingFeedbackURL,
                                                        data: formData);
                                                logger.d(
                                                    "Feedback Rating Status code - ${response.statusCode}");
                                                logger.d(
                                                    "Feedback Rating API RESP: ${response.data.toString()}");
                                                if (response.statusCode !=
                                                    200) {
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                } else {
                                                  //TODO:------------------SUCCESS RESPONSE--------------------------

                                                  RatingFeedbackResponse
                                                      ratingFeedbackResponse =
                                                      ratingFeedbackResponseFromJson(
                                                          response.data
                                                              .toString());

                                                  // preferences.setInt(SPKeys.userID, int.parse(loginResponse.data.userid));

                                                  setState(() {
                                                    loading = false;
                                                  });

                                                  if (ratingFeedbackResponse
                                                          .n ==
                                                      1) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Feedback has been submitted Successfully!",
                                                        backgroundColor:
                                                            Color(0xff52BF68),
                                                        textColor: Colors.white,
                                                        toastLength:
                                                            Toast.LENGTH_LONG);

                                                    //TODO: Reset all the text editing controllers here:
                                                    feedbackController.clear();
                                                    Navigator.pop(context);
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Could not fetch feedback...Please try again.",
                                                        backgroundColor:
                                                            Color(0xffBF3B38),
                                                        textColor: Colors.white,
                                                        toastLength:
                                                            Toast.LENGTH_LONG);
                                                  }
                                                }
                                              } on DioError catch (e) {
                                                if (DioErrorType.DEFAULT ==
                                                    e.type) {
                                                  if (e.message.contains(
                                                      'SocketException')) {
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Please check your Internet connection.",
                                                        backgroundColor:
                                                            Color(0xffBF3B38),
                                                        textColor: Colors.white,
                                                        toastLength:
                                                            Toast.LENGTH_SHORT);
                                                  }
                                                } else {
                                                  Logger(
                                                          printer:
                                                              PrettyPrinter())
                                                      .wtf(e);
                                                  setState(() {
                                                    loading = false;
                                                  });

                                                  Fluttertoast.showToast(
                                                      msg: e.toString(),
                                                      backgroundColor:
                                                          Color(0xffBF3B38),
                                                      textColor: Colors.white,
                                                      toastLength:
                                                          Toast.LENGTH_SHORT);
                                                }
                                              }
                                            },
                                          )
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  void _openLogoutConfirmationDialog(BuildContext context) {
    double rating = 0.5;
    TextEditingController feedbackController = TextEditingController();
    bool loading = false;

    void logout() async {
      setState(() {
        loading = true;
      });
      try {
        final SharedPreferences pref = await SharedPreferences.getInstance();
        String loginMethod = pref.getString(SPKeys.loginMethod);
        print("You Used login method: $loginMethod");
        if (loginMethod == "LoginMethod.GOOGLE_LOGIN") {
          print("Googel Logout");
          await FirebaseAuth.instance.signOut();
          pref.clear();
          _deleteCacheDir();
          setState(() {
            loading = false;
          });
        } else if (loginMethod == "LoginMethod.API_LOGIN") {
          print("API logout");
          pref.clear();
          _deleteCacheDir();
          setState(() {
            loading = false;
          });
        } else if (loginMethod == "LoginMethod.FACEBOOK_LOGIN") {
          print("FACEBOOK LOGOUT");
          await FacebookAuth.instance.logOut();

          pref.clear();
          _deleteCacheDir();
          setState(() {
            loading = false;
          });
        }

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
            (Route<dynamic> route) => false);
      } catch (e) {
        setState(() {
          loading = false;
        });
        print(e.toString());
        Fluttertoast.showToast(
            msg: "Could not logout..Try again later!",
            backgroundColor: Color(0xffBF3B38),
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
      }
    }

    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Material(
            color: Colors.transparent,
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: Center(
                  child: Stack(
                    overflow: Overflow.visible,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          height: 150,
                          width: 500,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text(
                                    "Confirm Logout",
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text(
                                      "Are you sure, you want to logout ?"),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                loading
                                    ? CustomLoader()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RaisedButton(
                                            color: Colors.blueGrey,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Center(
                                              child: Text(
                                                "CANCEL",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          RaisedButton(
                                            color: Colors.black,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Center(
                                              child: Text(
                                                "LOGOUT",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            onPressed: () {
                                              logout();
                                            },
                                          )
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  Widget buildTitleContainer() {
    return Container(
      height: 150,
      width: double.infinity,
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "MY NEIGHBOURHOOD",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 1,
                  width: 20,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("ONLINE",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Baske9',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 7)),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 1,
                  width: 20,
                  color: Colors.white,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }
}
