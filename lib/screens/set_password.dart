import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:my_neighbourhood_online/Networking/all_urls.dart';
import 'package:my_neighbourhood_online/api_response_model/set_password_response.dart';
import 'package:my_neighbourhood_online/screens/login.dart';
import 'package:my_neighbourhood_online/widget/base_canvas.dart';
import 'package:my_neighbourhood_online/widget/custom_dialog_box.dart';
import 'package:my_neighbourhood_online/widget/formLabel.dart';
import 'package:my_neighbourhood_online/widget/form_theme.dart';
import 'package:my_neighbourhood_online/widget/headline.dart';
import 'package:my_neighbourhood_online/widget/material_rounded_button.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class SetPassword extends StatefulWidget {
  final String userName;

  const SetPassword({Key key, this.userName}) : super(key: key);
  @override
  _SetpasswordState createState() => _SetpasswordState();
}

class _SetpasswordState extends State<SetPassword> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isConfirmopasswordVisible = false;
  bool isPasswordVisible = false;

  TextStyle style = TextStyle(fontSize: 14.0, color: Colors.white);

  var logger = Logger(printer: PrettyPrinter(methodCount: 0));
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //TODO: Set username(email)
    userNameController.text = widget.userName ?? "";
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
                text: "Set Password",
                fontSize: ResponsiveFlutter.of(context).fontSize(2),

                //  fontweight: FontWeight.w500,
                labelColor: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Container(
                  // height: 50,
                  child: formTheme(
                    child: TextField(
                      obscureText: false,
                      controller: userNameController,
                      enabled: false,
                      style: style,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0.0, -16),
                        hintText: "Username",
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
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      style: style,
                      decoration: InputDecoration(
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
                        ),
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0.0, -16),
                        hintText: "Set Password",
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
                      controller: confirmPasswordController,
                      obscureText: !isConfirmopasswordVisible,
                      style: style,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0.0, -16),
                        hintText: "Confirm password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isConfirmopasswordVisible =
                                  !isConfirmopasswordVisible;
                            });
                          },
                          icon: Icon(
                            isConfirmopasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
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
                          setPasswordAPICALL(
                              email: widget.userName,
                              password: passwordController.text);
                        }
                      },
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialogBox(
                            title: "Password Rules",
                            descriptions:
                                "Your password should contain:\n \nat least one Uppercase ( Capital ) letter\nat least one lowercase character\nat least digit and\nspecial character\nat least 6 characters long",
                            text: "Okay",
                          );
                        });
                  },
                  child: Text(
                    "Password Policy",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                ),
              )
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
    if (passwordController.text == null || passwordController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter password.",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    if (confirmPasswordController.text == null ||
        confirmPasswordController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please confirm your password",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Fluttertoast.showToast(
          msg: "Your entered pasword and confirm password does not match!",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
      return false;
    }

    if (!isPasswordCompliant(passwordController.text)) {
      Fluttertoast.showToast(
          msg: "Your password does not match our password policy",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
      return false;
    }

    return true;
  }

  void setPasswordAPICALL({String email, String password}) async {
    Map<String, dynamic> body = {
      "username": email,
      "password": password,
    };
    logger.d("OTP VERIFICATION API : body: $body");
    try {
      setState(() {
        loading = true;
      });
      FormData formData = new FormData.fromMap(body);
      Response response =
          await Dio().post(AllUrls().setPasswordURL, data: formData);
      logger.d("Set Password   API: Status code - ${response.statusCode}");
      logger.d("Set Password API RESPO: ${response.data.toString()}");
      if (response.statusCode != 200) {
        setState(() {
          loading = false;
        });
      } else {
        //TODO:------------------SUCCESS RESPONSE--------------------------

        SetPasswordResponse setPasswordResponse =
            setPasswordResponseFromJson(response.data.toString());
        setState(() {
          loading = false;
        });

        if (setPasswordResponse.n == 1) {
          Fluttertoast.showToast(
              msg: "Password Set Succesfully...Please Login to proceed",
              backgroundColor: Color(0xff52BF68),
              textColor: Colors.white,
              toastLength: Toast.LENGTH_LONG);
          Navigator.of(context).pushAndRemoveUntil(
            // the new route
            MaterialPageRoute(builder: (BuildContext context) => Login()),
            (Route route) => false,
          );
        } else {
          Fluttertoast.showToast(
              msg: "Could not set password...Please try again!!",
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
