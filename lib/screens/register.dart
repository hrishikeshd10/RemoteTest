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
import 'package:my_neighbourhood_online/api_response_model/registration_api_response.dart';
import 'package:my_neighbourhood_online/api_response_model/social_login_api_response.dart';
import 'package:my_neighbourhood_online/route_transitions/dart/route_transitions.dart';
import 'package:my_neighbourhood_online/screens/home_page.dart';
import 'package:my_neighbourhood_online/screens/login.dart';
import 'package:my_neighbourhood_online/screens/otpverify.dart';
import 'package:my_neighbourhood_online/screens/terms_n_conditions.dart';
import 'package:my_neighbourhood_online/widget/base_canvas.dart';
import 'package:my_neighbourhood_online/widget/custom_color.dart';
import 'package:my_neighbourhood_online/widget/custom_loader.dart';
import 'package:my_neighbourhood_online/widget/formLabel.dart';
import 'package:my_neighbourhood_online/widget/form_theme.dart';
import 'package:my_neighbourhood_online/widget/headline.dart';
import 'package:my_neighbourhood_online/widget/material_rounded_button.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //TODO: TExt Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  //TODO: book variables

  bool loading = false;

  //TODO: Text Styles go here
  TextStyle style = TextStyle(fontSize: 15.0, color: Colors.white);

  var logger = Logger(printer: PrettyPrinter(methodCount: 0, colors: true));
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: BaseCanvas(
              child: Center(
                  child: ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomHeadline(),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          // height: 50,
                          child: formTheme(
                            child: TextField(
                              controller: nameController,
                              obscureText: false,
                              style: style,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 0, 0.0, -16),
                                hintText: "Full Name *",
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                        child: Container(
                          child: formTheme(
                            child: TextField(
                              controller: emailController,
                              obscureText: false,
                              style: style,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 0, 0.0, -16),
                                hintText: "Email *",
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                        child: Container(
                          child: formTheme(
                            child: TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              obscureText: false,
                              style: style,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 0, 0.0, -16),
                                hintText: "Mobile No *",
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 25),
                        child: Container(
                            height: 40,
                            child: RoundedMaterialButton(
                              onPressed: () {
                                if (validateUserInputs()) {
                                  FocusScope.of(context).unfocus();
                                  String phoneControllerText =
                                      phoneController.text;
                                  makeRegistrationAPiCAll(
                                      email: emailController.text,
                                      name: nameController.text,
                                      contactNumber: phoneController.text,
                                      context: context);
                                }
                              },
                              child: Center(
                                child: Text(
                                  " GET OTP",
                                  style: TextStyle(
                                      fontFamily: 'Futura Light',
                                      fontSize: 16,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              elevation: 10,
                            )),
                      ),
                      FormLabel(
                        text: "By continuing, you agree to accept our",
                        fontSize: ResponsiveFlutter.of(context).fontSize(1.5),

                        //  fontweight: FontWeight.w300,
                        labelColor: Colors.white,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context, FadeRoute(page: TermsNConditions()));
                        },
                        child: FormLabel(
                          text: "Privacy Policy & Terms of Service",
                          fontSize: ResponsiveFlutter.of(context).fontSize(1.5),

                          //fontweight: FontWeight.w300,
                          labelColor: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FormLabel(
                            text: 'Already a Member? ',
                            fontSize:
                                ResponsiveFlutter.of(context).fontSize(1.8),
                            labelColor: Colors.white,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                // the new route
                                MaterialPageRoute(
                                  builder: (BuildContext context) => Login(),
                                ),

                                // this function should return true when we're done removing routes
                                // but because we want to remove all other screens, we make it
                                // always return false
                                (Route route) => false,
                              );
                            },
                            child: FormLabel(
                              text: 'Sign In',
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
              )),
            ),
          ),
        ),
        loading ? CustomLoader() : Container()
      ],
    );
  }

  //TODO: FACAEBOOK FB LOGIN CODE GOES HERE:
  Future<void> facebookLogin() async {
    try {
      // by default the login method has the next permissions ['email','public_profile']
      AccessToken accessToken = await FacebookAuth.instance.login();
      print(accessToken.toJson());
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
          Fluttertoast.showToast(
              msg: "Login Cancelled due to some error...Try Again!!",
              backgroundColor: Color(0xffBF3B38),
              textColor: Colors.white,
              toastLength: Toast.LENGTH_SHORT);
          print("login cancelled");
          break;
        case FacebookAuthErrorCode.FAILED:
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(
              msg: "Login FAILED due to some error...Try Again!!",
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

  void makeRegistrationAPiCAll(
      {@required String email,
      @required String name,
      @required String contactNumber,
      BuildContext context}) async {
    try {
      setState(() {
        loading = true;
      });

      FormData formData = new FormData.fromMap(
          {"email": email, "mobile": contactNumber, "fullName": name});
      Response response =
          await Dio().post(AllUrls().registrationURL, data: formData);

      if (response.statusCode != 200) {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
            msg: response.data.toString(),
            backgroundColor: Color(0xffBF3B38),
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT);
      } else {
        //TODO: ------------SUCCESS RESPONSE------------

        RegistrationResponse regResp =
            registrationResponseFromJson(response.data.toString());
        logger.i("Response message: ${response.data.toString()}");
        setState(() {
          loading = false;
        });

        Navigator.push(
            context,
            FadeRoute(
                page: OTPVerificationPage(
              otp: regResp.otp,
              email: email,
              fullName: name,
              phoneNumber: contactNumber,
            )));
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
            loginType: 1,
            firstName: nameList[0],
            lastName: nameList[nameList.length - 1],
            email: validUser.user.email,
            mobileNumber: validUser.user.phoneNumber,
            photoURL: validUser.user.photoURL);

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

      setState(() {
        loading = false;
      });
    }
  }

  //TODO: API CALL TO REGISTER A SOCIEAL USERIN TO THE APP DB IN TEH BACKEND

  void regCheckSocialUser(
      {int loginType: 1,
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
      "gender": "I prefer not to Say"
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
            String loginMEth = preferences.getString(SPKeys.loginMethod);
            print("Login METhOD: ${loginMEth}");
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

  bool validateUserInputs() {
    RegExp nameRegex = new RegExp(r'(^[a-zA-Z0-9! .]+$)');
    Pattern emailPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp emailRegex = new RegExp(emailPattern);

    if (nameController.text == null || nameController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please mention your full name",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }

    if (emailController.text == null || emailController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please mention Email ID",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }

    if (phoneController.text == null || phoneController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please mention mobile Number",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }

    if (!nameRegex.hasMatch(nameController.text)) {
      Fluttertoast.showToast(
          msg: "Name field should not contain special characters",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    if (!emailRegex.hasMatch(emailController.text)) {
      Fluttertoast.showToast(
          msg: "Please enter a valid Email-ID",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    if (phoneController.text.length != 10) {
      Fluttertoast.showToast(
          msg: "Please enter a valid mobile Number",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }

    return true;
  }
}
