import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:my_neighbourhood_online/Networking/all_urls.dart';
import 'package:my_neighbourhood_online/api_response_model/list_business_response.dart';
import 'package:my_neighbourhood_online/widget/base_canvas.dart';
import 'package:my_neighbourhood_online/widget/custom_loader.dart';
import 'package:my_neighbourhood_online/widget/material_rounded_button.dart';

class ListYourBusinessPage extends StatefulWidget {
  @override
  _ListYourBusinessPageState createState() => _ListYourBusinessPageState();
}

class _ListYourBusinessPageState extends State<ListYourBusinessPage> {
  bool _toggleFingerPrintLogin = false;
  bool isImageSelected;
  bool loading = false;
  File profileImage;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController businessNoController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController commentsController = TextEditingController();

  var logger = Logger(printer: PrettyPrinter(methodCount: 0));
  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: buildAppBar(),
          body: BaseCanvas(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 10,
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
                        textInputType: TextInputType.number,
                        obscureText: false,
                        labelText: "Contact Number"),
                    SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                        controller: businessNoController,
                        hintText: "Busineess No. (optional)",
                        obscureText: false,
                        labelText: "Business No."),
                    SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                        controller: businessNameController,
                        hintText: "Business Name*",
                        obscureText: false,
                        labelText: "Business Name"),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // _buildTextField(
                    //     controller: addressController,
                    //     hintText: "Type of Business",
                    //     obscureText: false,
                    //     labelText: "Industry"),
                    SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                        controller: designationController,
                        hintText: "Your Designation (Optional)",
                        obscureText: false,
                        labelText: "Position"),
                    SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                        controller: locationController,
                        hintText: 'Store Location *',
                        obscureText: false,
                        labelText: "Store Location"),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: commentsController,
                        obscureText: false,
                        maxLines: 5,
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 5, 20.0, 5),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.8), width: 2),
                          ),
                          hintText: "Enter your requirements (optional)",
                          alignLabelWithHint: true,
                          labelText: "Comments",
                          labelStyle:
                              TextStyle(fontSize: 15, color: Colors.grey),
                          hintStyle:
                              TextStyle(fontSize: 12, color: Colors.grey),
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
                    SizedBox(height: 10),
                    submitButton(),
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

  Widget _buildTextField(
      {@required TextEditingController controller,
      String hintText: "",
      String labelText: "",
      bool obscureText: false,
      TextInputType textInputType: TextInputType.text,
      double height: 60.0}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: height,
        child: TextField(
          keyboardType: textInputType,
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
    if (businessNameController.text == null ||
        businessNameController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter your BUSINESS NAME",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }

    if (locationController.text == null || locationController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please mention your Store Location",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }

    return true;
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xff202427),
      elevation: 0.0,
      leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset('assets/images/back_arrow.png')),
      title: Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Text(
          "List Your Business with Us".toUpperCase(),
          style: GoogleFonts.montserrat(color: Colors.white, fontSize: 18),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget submitButton() {
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
              print(businessNameController.text);
              if (validateUserInputs()) {
                registerBusinessAPICall(
                    fullName: nameController.text,
                    emailID: emailController.text,
                    contactNumber: contactController.text,
                    businessNumber: businessNoController.text,
                    businessName: businessNameController.text,
                    designation: designationController.text,
                    location: locationController.text,
                    comments: commentsController.text);
              }
            },
            elevation: 10,
          )),
    );
  }

  void registerBusinessAPICall(
      {String fullName,
      String emailID,
      String contactNumber,
      String businessNumber,
      String businessName,
      String designation,
      String location,
      String comments}) async {
    Map<String, dynamic> body = {
      "fullName": fullName,
      "emailID": emailID,
      "contactNumber": contactNumber,
      "businessNO": businessNumber,
      "businessName": businessName,
      "designmation": designation,
      "storeLocation": location,
      "comments": comments
    };

    logger.d("Update profile body: $body");
    try {
      // final SharedPreferences preferences =
      //     await SharedPreferences.getInstance();

      setState(() {
        loading = true;
      });
      FormData formData = new FormData.fromMap(body);
      Response response =
          await Dio().post(AllUrls().listBusinessURL, data: formData);
      logger.d("Update User API Status code - ${response.statusCode}");
      logger.d("Update User API RESPO: ${response.data.toString()}");
      if (response.statusCode != 200) {
        setState(() {
          loading = false;
        });
      } else {
        //TODO:------------------SUCCESS RESPONSE--------------------------

        ListBusinessResponse listBusinessResponse =
            listBusinessResponseFromJson(response.data.toString());

        // preferences.setInt(SPKeys.userID, int.parse(loginResponse.data.userid));

        setState(() {
          loading = false;
        });

        if (listBusinessResponse.n == 1) {
          Fluttertoast.showToast(
              msg: listBusinessResponse.msg,
              backgroundColor: Color(0xff52BF68),
              textColor: Colors.white,
              toastLength: Toast.LENGTH_LONG);

          //TODO: Reset all the text editing controllers here:

          nameController.clear();
          emailController.clear();
          contactController.clear();
          businessNoController.clear();
          businessNameController.clear();
          designationController.clear();
          locationController.clear();
          commentsController.clear();
        } else {
          Fluttertoast.showToast(
              msg: listBusinessResponse.msg,
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
