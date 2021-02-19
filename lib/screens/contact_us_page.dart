import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:my_neighbourhood_online/Networking/all_urls.dart';
import 'package:my_neighbourhood_online/api_response_model/contact_us_response.dart';
import 'package:my_neighbourhood_online/widget/base_canvas.dart';
import 'package:my_neighbourhood_online/widget/custom_loader.dart';
import 'package:my_neighbourhood_online/widget/material_rounded_button.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  bool _toggleFingerPrintLogin = false;

  bool isImageSelected;
  bool loading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  var logger = Logger(printer: PrettyPrinter(methodCount: 0));

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: buildAppBar(context),
          body: BaseCanvas(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Center(
                          child: Text(
                        "Please reach out to us for your concerns",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w200,
                            color: Colors.white),
                      )),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    _buildTextField(
                        controller: nameController,
                        hintText: "Full Name *",
                        obscureText: false,
                        labelText: "Full Name"),
                    SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                        controller: emailController,
                        hintText: "Email ID *",
                        obscureText: false,
                        labelText: "Email ID"),
                    SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                        controller: contactController,
                        hintText: "Contact Number *",
                        obscureText: false,
                        labelText: "Contact Number"),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: messageController,
                        obscureText: false,
                        maxLines: 5,
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 5, 20.0, 5),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.8), width: 2),
                          ),
                          hintText: "Message *",
                          alignLabelWithHint: true,
                          labelStyle:
                              TextStyle(fontSize: 15, color: Colors.grey),
                          hintStyle:
                              TextStyle(fontSize: 15, color: Colors.grey),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.3))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              gapPadding: 10,
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.3))),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    submitButton(context),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        loading ? CustomLoader() : Container()
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Color(0xff202427),
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Image.asset('assets/images/back_arrow.png'),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          "Contact Us",
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
      ),
    );
  }

  void contactUsApiCall(
      {String fullName,
      String emailID,
      String contactNumber,
      String message}) async {
    Map<String, dynamic> body = {
      "fullName": fullName,
      "emailID": emailID,
      "contactNumber": contactNumber,
      "message": message,
    };

    logger.d("Contact US body: $body");
    try {
      // final SharedPreferences preferences =
      //     await SharedPreferences.getInstance();

      setState(() {
        loading = true;
      });
      FormData formData = new FormData.fromMap(body);
      Response response =
          await Dio().post(AllUrls().contactUsURL, data: formData);
      logger.d("Contact us API Status code - ${response.statusCode}");
      logger.d("Contact Us API RESP: ${response.data.toString()}");
      if (response.statusCode != 200) {
        setState(() {
          loading = false;
        });
      } else {
        //TODO:------------------SUCCESS RESPONSE--------------------------

        ContactUsResponse contactUsResponse =
            contactUsResponseFromJson(response.data.toString());

        // preferences.setInt(SPKeys.userID, int.parse(loginResponse.data.userid));

        setState(() {
          loading = false;
        });

        if (contactUsResponse.n == 1) {
          Fluttertoast.showToast(
              msg: "Your query has been submitted Successfully!",
              backgroundColor: Color(0xff52BF68),
              textColor: Colors.white,
              toastLength: Toast.LENGTH_LONG);

          //TODO: Reset all the text editing controllers here:

          nameController.clear();
          emailController.clear();
          contactController.clear();
          messageController.clear();
        } else {
          Fluttertoast.showToast(
              msg: contactUsResponse.msg,
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

    if (contactController.text == null || contactController.text.isEmpty) {
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
    if (contactController.text.length != 10) {
      Fluttertoast.showToast(
          msg: "Please enter a valid mobile Number",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    if (messageController.text == null || messageController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter a message",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }

    return true;
  }

  Widget _buildTextField(
      {@required TextEditingController controller,
      String hintText: "",
      String labelText: "",
      bool obscureText: false,
      double height: 60.0}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: height,
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(fontSize: 14.0, color: Colors.white),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 5, 20.0, 5),
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.grey.withOpacity(0.8), width: 2),
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            alignLabelWithHint: true,
            // labelText: labelText,
            labelStyle: TextStyle(fontSize: 15),
            border:
                UnderlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ),
    );
  }

  Widget submitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
          height: 45,
          child: RoundedMaterialButton(
            child: Center(
              child: Text(
                "SUBMIT",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();

              if (validateUserInputs()) {
                contactUsApiCall(
                    fullName: nameController.text,
                    emailID: emailController.text,
                    contactNumber: contactController.text,
                    message: messageController.text);
              }
            },
            elevation: 10,
          )),
    );
  }
}
