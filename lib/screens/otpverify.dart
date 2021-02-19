import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:my_neighbourhood_online/Networking/all_urls.dart';
import 'package:my_neighbourhood_online/api_response_model/verify_otp_response.dart';
import 'package:my_neighbourhood_online/route_transitions/dart/route_transitions.dart';
import 'package:my_neighbourhood_online/screens/set_password.dart';
import 'package:my_neighbourhood_online/widget/base_canvas.dart';
import 'package:my_neighbourhood_online/widget/custom_loader.dart';
import 'package:my_neighbourhood_online/widget/formLabel.dart';
import 'package:my_neighbourhood_online/widget/headline.dart';
import 'package:my_neighbourhood_online/widget/material_rounded_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

// ignore: must_be_immutable
class OTPVerificationPage extends StatefulWidget {
  int otp;
  String fullName;
  String email;
  String phoneNumber;

  OTPVerificationPage(
      {Key key, this.otp, this.fullName, this.email, this.phoneNumber})
      : super(key: key);
  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState(otp: this.otp);
}

class _PinCodeVerificationScreenState extends State<OTPVerificationPage> {
  var onTapRecognizer;

  TextEditingController inputOTPController = TextEditingController();

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  bool loading = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  final int otp;

  var logger = Logger(printer: PrettyPrinter(methodCount: 0));

  _PinCodeVerificationScreenState({this.otp}) : assert(otp != null);

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          key: scaffoldKey,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: BaseCanvas(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 140),
                      CustomHeadline(),
                      SizedBox(
                        height: 80,
                      ),
                      FormLabel(
                        text: "One Time Password",
                        fontSize: ResponsiveFlutter.of(context).fontSize(2),

                        //fontweight: FontWeight.w500,
                        labelColor: Colors.white,
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      Form(
                        key: formKey,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10),
                            child: PinCodeTextField(
                              appContext: context,
                              pastedTextStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              length: 6,
                              obscureText: false,
                              obscuringCharacter: '*',
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(10),
                                fieldHeight: 60,
                                fieldWidth: 50,
                                activeColor: Colors.green,
                                inactiveFillColor: Colors.transparent,
                                selectedFillColor: Colors.grey[200],
                                selectedColor: Colors.grey[200],
                                inactiveColor: Colors.white,
                                borderWidth: 0.5,
                                activeFillColor:
                                    hasError ? Colors.orange : Colors.white,
                              ),
                              cursorColor: Colors.blue,
                              animationDuration: Duration(milliseconds: 300),
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  height: 1.6,
                                  color: Colors.white,
                                  fontFamily: "Montserrat-Regular"),
                              backgroundColor: Colors.transparent,
                              enableActiveFill: false,

                              errorAnimationController: errorController,
                              controller: inputOTPController,
                              keyboardType: TextInputType.number,

                              // boxShadows: [
                              //   BoxShadow(
                              //     offset: Offset(0, 1),
                              //     color: Colors.black12,
                              //     blurRadius: 10,
                              //   )
                              // ],
                              onCompleted: (v) {
                                print("Completed");
                              },
                              // onTap: () {
                              //   print("Pressed");
                              // },

                              beforeTextPaste: (text) {
                                print("Allowing to paste $text");
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 25),
                        child: Container(
                            height: 40,
                            child: RoundedMaterialButton(
                              onPressed: () {
                                if (validateInput()) {
                                  makeOTPVerificationAPICAll(
                                      email: widget.email,
                                      fullName: widget.fullName,
                                      mobile: widget.phoneNumber.toString(),
                                      inputOTP: inputOTPController.text,
                                      sessionOTP: widget.otp.toString());
                                }
                              },
                              child: Center(
                                child: Text(
                                  "VERIFY OTP",
                                  style: TextStyle(
                                      fontFamily: 'Futura Light',
                                      fontSize: 16,
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              elevation: 10,
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        loading ? CustomLoader() : Container()
      ],
    );
  }

  bool validateInput() {
    if (inputOTPController.text == null ||
        inputOTPController.text.length != 6) {
      Fluttertoast.showToast(
          msg: "Please enter the OTP completely",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    return true;
  }

  void makeOTPVerificationAPICAll(
      {String email,
      String mobile,
      String fullName,
      String inputOTP,
      String sessionOTP}) async {
    Map<String, dynamic> body = {
      "email": email,
      "mobile": mobile,
      "fullName": fullName,
      "inputOTP": inputOTP,
      "sessOTP": sessionOTP
    };
    logger.d("OTP VERIFICATION API : body: $body");
    try {
      setState(() {
        loading = true;
      });
      FormData formData = new FormData.fromMap(body);
      Response response =
          await Dio().post(AllUrls().otpVerificationURL, data: formData);
      logger.d("OTP VERIFICATION API: Status code - ${response.statusCode}");
      logger.d("OTP VERIFICATION API RESPO: ${response.data.toString()}");
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
        //TODO:------------------SUCCESS RESPONSE--------------------------

        OtpVerificationResponse regResp =
            otpVerificationResponseFromJson(response.data.toString());
        setState(() {
          loading = false;
        });

        if (regResp.n == 1) {
          Navigator.push(
              context,
              FadeRoute(
                  page: SetPassword(
                userName: widget.email,
              )));
        } else {
          Fluttertoast.showToast(
              msg:
                  "Could not verify the OTP... Make sure you have entered the correct OTP",
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
