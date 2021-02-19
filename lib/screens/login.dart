import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:my_neighbourhood_online/Networking/all_urls.dart';
import 'package:my_neighbourhood_online/Utilities/key_constants.dart';
import 'package:my_neighbourhood_online/api_response_model/login_response.dart';
import 'package:my_neighbourhood_online/api_response_model/social_login_api_response.dart';
import 'package:my_neighbourhood_online/main.dart';
import 'package:my_neighbourhood_online/route_transitions/dart/route_transitions.dart';
import 'package:my_neighbourhood_online/screens/forgot_password_screen.dart';
import 'package:my_neighbourhood_online/screens/home_page.dart';
import 'package:my_neighbourhood_online/widget/base_canvas.dart';
import 'package:my_neighbourhood_online/widget/custom_color.dart';
import 'package:my_neighbourhood_online/widget/custom_loader.dart';
import 'package:my_neighbourhood_online/widget/formLabel.dart';
import 'package:my_neighbourhood_online/widget/form_theme.dart';
import 'package:my_neighbourhood_online/widget/headline.dart';
import 'package:my_neighbourhood_online/widget/material_rounded_button.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextStyle style = TextStyle(fontSize: 12.0, color: Colors.white);

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loading = false;
  bool isPasswordVisible = false;

  var logger = Logger(printer: PrettyPrinter(methodCount: 0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BaseCanvas(
            child: Center(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // shrinkWrap: true,ook
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomHeadline(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
                        child: Container(
                          height: 50,
                          child: formTheme(
                            child: TextField(
                              controller: usernameController,
                              obscureText: false,
                              cursorColor: Colors.white,
                              style: style,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 5, 20.0, 5),
                                hintText: "Enter registered email",
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                        child: Container(
                          height: 50,
                          child: formTheme(
                              child: TextField(
                            controller: passwordController,
                            obscureText: !isPasswordVisible,
                            style: style,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 5, 20.0, 5),
                                hintText: "Password",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                )),
                          )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context, FadeRoute(page: ForgotPassword()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 28, top: 10, bottom: 4),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: FormLabel(
                              text: 'Forgot Password ?',
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.6),
                              labelColor: customcolor.forgetpasscolor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                        child: Container(
                            height: 45,
                            child: RoundedMaterialButton(
                              elevation: 10,
                              child: Center(
                                child: Text(
                                  "SIGN IN",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Future Light'),
                                ),
                              ),
                              onPressed: () {
                                if (validateInputs()) {
                                  makeLoginApiCall(
                                      email: usernameController.text,
                                      password: passwordController.text);
                                }
                              },
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FormLabel(
                            text: 'New User?  ',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8),
                            labelColor: Colors.white,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/signup");
                            },
                            child: FormLabel(
                              text: 'Sign Up',
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(1.8),
                              labelColor: customcolor.skyblue,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 15, bottom: 10),
                        child: Image.asset(
                          'assets/images/form_divider.png',
                          scale: 1.1,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                facebookLogin();
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Color(0xff4267B2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 6, bottom: 8),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/facebook.png",
                                        // width: 25,
                                        // height: 30,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      FormLabel(
                                        text: 'FACEBOOK',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(2),
                                        labelColor: Colors.white,
                                        fontweight: FontWeight.w400,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                signInWithGoogle();
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 6, bottom: 8),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/googleicon.png",
                                        // width: 43,
                                        // height: 43,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      FormLabel(
                                        text: 'GOOGLE',
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(2),
                                        labelColor: Colors.grey,
                                        fontweight: FontWeight.w700,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )),
          ),
          loading ? CustomLoader() : Container()
        ],
      ),
    );
  }

  bool validateInputs() {
    if (usernameController.text == null || usernameController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter a valid email",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    if (passwordController.text == null || passwordController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter a valid password",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }

    return true;
  }

  void makeLoginApiCall({String email, String password}) async {
    Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };
    logger.d("Login API body: $body");
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      setState(() {
        loading = true;
      });
      FormData formData = new FormData.fromMap(body);
      Response response = await Dio().post(AllUrls().loginURL, data: formData);
      logger.d("Login API: Status code - ${response.statusCode}");
      logger.d("Login API RESPO: ${response.data.toString()}");
      if (response.statusCode != 200) {
        setState(() {
          loading = false;
        });
      } else {
        //TODO:------------------SUCCESS RESPONSE--------------------------

        LoginResponse loginResponse =
            loginResponseFromJson(response.data.toString());

        //TODO: SET THE USER DETAILS GLOBALLY

        setState(() {
          loading = false;
        });

        if (loginResponse.n == 1) {
          List<String> nameList = loginResponse.data.username.split(' ');
          preferences.setInt(SPKeys.userID, loginResponse.data.userid);
          preferences.setInt(SPKeys.userContact, loginResponse.data.mobile);
          preferences.setString(SPKeys.firstName, nameList[0]);
          preferences.setString(SPKeys.lastName, nameList[nameList.length - 1]);
          preferences.setString(SPKeys.userEmail, loginResponse.data.email);
          preferences.setString(
              SPKeys.profileImageURL, loginResponse.data.profileImage);
          preferences.setString(
              SPKeys.loginMethod, LoginMethod.GOOGLE_LOGIN.toString());

          preferences.setString(
              SPKeys.loginMethod, LoginMethod.API_LOGIN.toString());
          setState(() {
            GlobalUserDetails.userID = loginResponse.data.userid;
            GlobalUserDetails.userName = loginResponse.data.username;
            GlobalUserDetails.userContact = loginResponse.data.mobile;
            GlobalUserDetails.userEmail = loginResponse.data.email;
            GlobalUserDetails.profileImageURL = loginResponse.data.profileImage;
          });
          Fluttertoast.showToast(
              msg: "Logged in successfully",
              backgroundColor: Color(0xff52BF68),
              textColor: Colors.white,
              toastLength: Toast.LENGTH_LONG);
          Navigator.of(context).pushAndRemoveUntil(
            // the  new route
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            (Route route) => false,
          );
        } else {
          Fluttertoast.showToast(
              msg: loginResponse.msg,
              backgroundColor: Color(0xffBF3B38),
              textColor: Colors.white,
              toastLength: Toast.LENGTH_LONG);
        }
      }
    } on DioError catch (e) {
      if (DioErrorType.DEFAULT == e.type) {
        if (e.message.contains('SocketException')) {
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(
              msg: "Please check your Internet connection.",
              backgroundColor: Color(0xffBF3B38),
              textColor: Colors.white,
              toastLength: Toast.LENGTH_SHORT);
        }
      } else {
        Logger(printer: PrettyPrinter()).wtf(e);
        setState(() {
          loading = false;
        });

        Fluttertoast.showToast(
            msg: e.toString(),
            backgroundColor: Color(0xffBF3B38),
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT);
      }
    }
  }

  //TODO: GOOGLE SIGN IN CODE GOES HERE:

  void signInWithGoogle() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await Firebase.initializeApp();
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential validUser =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (validUser != null) {
        List<String> nameList = validUser.user.displayName.split(' ');
        regCheckSocialUser(
            loginType: 1, //1 stands for Google Login
            firstName: nameList[0] ?? null,
            lastName: nameList[nameList.length - 1] ?? null,
            email: validUser.user.email ?? null,
            mobileNumber: validUser.user.phoneNumber ?? null,
            photoURL: validUser.user.photoURL ?? null);

        Fluttertoast.showToast(
            msg: "Sign in Success",
            backgroundColor: Colors.green,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
      } else {
        Fluttertoast.showToast(
            msg: "Google Sign in failed...Please try again!!",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
      }

      logger.e("The google user email: ${validUser.user.displayName}");
    } on SocketException {
      Fluttertoast.showToast(
          msg: "Please check your Internet connection",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  //TODO: FACAEBOOK FB LOGIN CODE GOES HERE:
  Future<void> facebookLogin() async {
    try {
      // by default the login method has the next permissions ['email','public_profile']
      AccessToken accessToken = await FacebookAuth.instance.login();
      print(" Accestoken  is :${accessToken.toJson()}");
      // get the user data
      if (accessToken != null) {
        final userData = await FacebookAuth.instance.getUserData();
        List<String> nameList = userData['name'].split(' ');
        String profileURL = userData['picture']['data']['url'];
        String email = userData['email'];

        logger.e("Facebook Name: " + userData['name']);
        setState(() {
          loading = true;
        });
        if (email == null) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Center(child: Text("UH-OH!")),
                    content: Container(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                              child: Text(
                                  "Seems like You Do not have an email Registered with Facebook. Please try again with other login methods!")),
                          RaisedButton(
                            color: Color(0xff3B3D4B),
                            shape: StadiumBorder(),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 15),
                                child: Text(
                                  "Okay",
                                  style: TextStyle(color: Colors.white),
                                )),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                  ));
          setState(() {
            loading = false;
          });
        } else {
          regCheckSocialUser(
              loginType: 0,
              firstName: nameList[0],
              lastName: nameList[1],
              photoURL: profileURL,
              mobileNumber: null,
              email: email);
        }
      } else {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
            msg: "Login failed due to some error...Try Again!!",
            backgroundColor: Color(0xffBF3B38),
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT);
      }
    } on FacebookAuthException catch (e) {
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          setState(() {
            loading = false;
          });
          print("You have a previous login operation in progress");
          break;
        case FacebookAuthErrorCode.CANCELLED:
          setState(() {
            loading = false;
          });
          // Fluttertoast.showToast(
          //     msg: "Login Cancelled due to some error...Try Again!!",
          //     backgroundColor: Color(0xffBF3B38),
          //     textColor: Colors.white,
          //     toastLength: Toast.LENGTH_SHORT);
          // print("login cancelled");
          break;
        case FacebookAuthErrorCode.FAILED:
          setState(() {
            loading = false;
          });
          print("FAIL ERROR: ${e.message}");
          Fluttertoast.showToast(
              msg:
                  "$e.toString...Try clearing storage and login again with facebook!",
              backgroundColor: Color(0xffBF3B38),
              textColor: Colors.white,
              toastLength: Toast.LENGTH_SHORT);
          print("FAIL ERROR: ${e.message}");
          break;
      }
    } on SocketException {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: "Please check your Internet Connection!!",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  //TODO: API CALL TO REGISTER A SOCIEAL USERIN TO THE APP DB IN TEH BACKEND

  void regCheckSocialUser(
      {int loginType: 0,
      String firstName,
      String lastName,
      String email,
      String mobileNumber,
      String photoURL}) async {
    Map<String, dynamic> body = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "mobile": mobileNumber != null ? int.parse(mobileNumber) : null,
      "photo": photoURL,
      "gender": "I prefer not to Say",
      "loginType": loginType
    };

    logger.d("Social login body: $body");
    try {
      // final SharedPreferences preferences =
      //     await SharedPreferences.getInstance();

      setState(() {
        loading = true;
      });
      FormData formData = new FormData.fromMap(body);
      logger.d("Social Login URL : ${AllUrls().socialReguserURL}");
      Response response =
          await Dio().post(AllUrls().socialReguserURL, data: formData);
      logger.d("Social Login API Status code - ${response.statusCode}");
      logger.d("Social Login API RESPO: ${response.data.toString()}");
      if (response.statusCode != 200) {
        setState(() {
          loading = false;
        });
      } else {
        //TODO:------------------SUCCESS RESPONSE--------------------------

        SocialLoginResponse socialLoginResponse =
            socialLoginResponseFromJson(response.data.toString());

        // preferences.setInt(SPKeys.userID, int.parse(loginResponse.data.userid));

        setState(() {
          loading = false;
        });

        if (socialLoginResponse.n == 1) {
          final SharedPreferences preferences =
              await SharedPreferences.getInstance();
          if (loginType == 1) {
            preferences.setString(
                SPKeys.loginMethod, LoginMethod.GOOGLE_LOGIN.toString());
          } else {
            print("hellp");
            preferences.setString(
                SPKeys.loginMethod, LoginMethod.FACEBOOK_LOGIN.toString());
            String loginMethodName = preferences.getString(SPKeys.loginMethod);
            print("Login METhOD: $loginMethodName");
          }
          preferences.setInt(
              SPKeys.userContact, socialLoginResponse.userdata.mobile);
          preferences.setString(
              SPKeys.firstName, socialLoginResponse.userdata.firstName);
          preferences.setString(
              SPKeys.lastName, socialLoginResponse.userdata.lastName);
          preferences.setString(
              SPKeys.userEmail, socialLoginResponse.userdata.email);
          preferences.setString(
              SPKeys.profileImageURL, socialLoginResponse.userdata.photo);
          print("Set Image URl as: ${socialLoginResponse.userdata.photo}");

          preferences.setString(
              SPKeys.gender, socialLoginResponse.userdata.gender);
          preferences.setInt(SPKeys.userID, socialLoginResponse.userdata.id);
          setState(() {
            GlobalUserDetails.userID = socialLoginResponse.userdata.id;
            String lastName = socialLoginResponse.userdata.lastName ?? "";

            GlobalUserDetails.userName =
                socialLoginResponse.userdata.firstName + lastName;

            GlobalUserDetails.userContact = socialLoginResponse.userdata.mobile;
            GlobalUserDetails.userEmail = socialLoginResponse.userdata.email;
            GlobalUserDetails.profileImageURL =
                socialLoginResponse.userdata.photo;

            controller.add(false);

            print(
                "THE PROFILE IMAGE URL IS: ${GlobalUserDetails.profileImageURL}");
          });

          Navigator.push(context, FadeRoute(page: HomePage()));
        } else {
          Fluttertoast.showToast(
              msg: "Could not update user details ... Please try again!",
              backgroundColor: Color(0xffBF3B38),
              textColor: Colors.white,
              toastLength: Toast.LENGTH_LONG);
        }
      }
    } on DioError catch (e) {
      if (DioErrorType.DEFAULT == e.type) {
        if (e.message.contains('SocketException')) {
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(
              msg: "Please check your Internet connection.",
              backgroundColor: Color(0xffBF3B38),
              textColor: Colors.white,
              toastLength: Toast.LENGTH_SHORT);
        }
      } else {
        Logger(printer: PrettyPrinter()).wtf(e);
        setState(() {
          loading = false;
        });

        Fluttertoast.showToast(
            msg: e.toString(),
            backgroundColor: Color(0xffBF3B38),
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT);
      }
    }
  }
}
