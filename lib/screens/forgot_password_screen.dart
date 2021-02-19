import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:my_neighbourhood_online/Networking/all_urls.dart';
import 'package:my_neighbourhood_online/api_response_model/ForgotPasswordApiResponse.dart';
import 'package:my_neighbourhood_online/screens/change_password_screen.dart';
import 'package:my_neighbourhood_online/widget/base_canvas.dart';
import 'package:my_neighbourhood_online/widget/formLabel.dart';
import 'package:my_neighbourhood_online/widget/form_theme.dart';
import 'package:my_neighbourhood_online/widget/headline.dart';
import 'package:my_neighbourhood_online/widget/material_rounded_button.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController userNameController = TextEditingController();

  bool isConfirmopasswordVisible = false;
  bool isPasswordVisible = false;

  TextStyle style = TextStyle(fontSize: 14.0, color: Colors.white);

  var logger = Logger(printer: PrettyPrinter(methodCount: 0));
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseCanvas(
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
                height: 60,
              ),
              FormLabel(
                text: "Forgot Password ?",
                fontSize: ResponsiveFlutter.of(context).fontSize(2.5),

                //  fontweight: FontWeight.w500,
                labelColor: Colors.white,
              ),
              SizedBox(
                height: 30,
              ),
              FormLabel(
                text: "Please enter your Email ID to proceed",
                fontSize: ResponsiveFlutter.of(context).fontSize(2),

                //  fontweight: FontWeight.w500,
                labelColor: Colors.white.withOpacity(0.6),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Container(
                  // height: 50,
                  child: formTheme(
                    child: TextField(
                      obscureText: false,
                      controller: userNameController,
                      enabled: true,
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 5, 20.0, 5),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.8), width: 2),
                        ),
                        hintText: "Enter your email ID",
                        hintStyle: TextStyle(color: Colors.grey),
                        alignLabelWithHint: true,
                        // labelText: labelText,
                        labelStyle: TextStyle(fontSize: 15),
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 35, 20, 25),
                child: Container(
                    height: 40,
                    child: RoundedMaterialButton(
                      child: Center(
                          child: Text(
                        "SUBMIT",
                        style: TextStyle(
                            fontFamily: 'Futura Light',
                            fontSize: 16,
                            color: Colors.white,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold),
                      )),
                      elevation: 20,
                      onPressed: () {
                        // Navigator.push(context, FadeRoute(page: HomePage()));
                        setState(() {
                          isConfirmopasswordVisible = false;
                          isPasswordVisible = false;
                        });

                        if (validateInputs()) {
                          forgotPasswordApiCall(email: userNameController.text);
                        }
                      },
                    )),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ))),
    );
  }

  bool isPasswordCompliant(String password, [int minLength = 6]) {
    if (password == null || password.isEmpty) {
      return false;
    }

    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
        password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length >= minLength;

    return hasDigits &
        hasUppercase &
        hasLowercase &
        hasSpecialCharacters &
        hasMinLength;
  }

  bool validateInputs() {
    if (userNameController.text.isEmpty) {
      return false;
    }
    RegExp nameRegex = new RegExp(r'(^[a-zA-Z0-9! .]+$)');
    Pattern emailPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp emailRegex = new RegExp(emailPattern);

    if (userNameController.text == null || userNameController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please mention your Email ID",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    if (!emailRegex.hasMatch(userNameController.text)) {
      Fluttertoast.showToast(
          msg: "Please enter a valid Email-ID",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    return true;
  }

  void forgotPasswordApiCall({String email}) async {
    Map<String, dynamic> body = {
      "emailID": email,
    };
    logger.d("Forgort password API : body: $body");
    try {
      setState(() {
        loading = true;
      });
      FormData formData = new FormData.fromMap(body);
      Response response =
          await Dio().post(AllUrls().forgotPasswordURL, data: formData);
      logger.d("Set Password   API: Status code - ${response.statusCode}");
      logger.d("Set Password API RESPO: ${response.data.toString()}");
      if (response.statusCode != 200) {
        setState(() {
          loading = false;
        });
      } else {
        //TODO:------------------SUCCESS RESPONSE--------------------------

        ForgotPasswordResponse forgotPasswordResponse =
            forgotPasswordResponseFromJson(response.data.toString());
        setState(() {
          loading = false;
        });

        if (forgotPasswordResponse.n == 1) {
          Fluttertoast.showToast(
              msg: "EmailID verified successfully!",
              backgroundColor: Color(0xff52BF68),
              textColor: Colors.white,
              toastLength: Toast.LENGTH_LONG);
          Navigator.of(context).pushAndRemoveUntil(
            // the new route
            MaterialPageRoute(
                builder: (BuildContext context) => ChangePassword(
                      userName: email,
                    )),
            (Route route) => false,
          );
        } else {
          Fluttertoast.showToast(
              msg: "Could not verify EmailID...Please try again!!",
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
