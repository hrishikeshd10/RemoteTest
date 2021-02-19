import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:my_neighbourhood_online/Networking/all_urls.dart';
import 'package:my_neighbourhood_online/Utilities/key_constants.dart';
import 'package:my_neighbourhood_online/api_response_model/get_user_details_response.dart';
import 'package:my_neighbourhood_online/widget/base_canvas.dart';
import 'package:my_neighbourhood_online/widget/custom_loader.dart';
import 'package:my_neighbourhood_online/widget/material_rounded_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UseProfilePage extends StatefulWidget {
  @override
  _UseProfilePageState createState() => _UseProfilePageState();
}

class _UseProfilePageState extends State<UseProfilePage> {
  var logger = Logger(printer: PrettyPrinter(methodCount: 0));
//Vars for images picked using multipicker
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  Asset image;

  bool _toggleFingerPrintLogin = false;
  bool isImageSelected = false;
  bool loading = false;
  final _imagePicker = ImagePicker();
  File profileImage;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  String imageURL;
  String imagePath;
  GetUserDetailsResponse userDetails = GetUserDetailsResponse();

  DateTime selectedDate = DateTime(1950);

  List<String> genderData = [
    "Male",
    "Female",
    "Non-Binary",
    "Transgender",
    "I prefer not to say"
  ];

  @override
  void initState() {
    // TODO: implement initState
    SharedPreferences.getInstance().then((sopInstance) async {
      var userID = await sopInstance.getInt(SPKeys.userID);
      makeGetUserAPICall(userID: GlobalUserDetails.userID);
    });
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
                    Stack(
                      overflow: Overflow.visible,
                      children: [
                        // isPlatformAndroid()
                        //     ?
                        !isImageSelected &&
                                GlobalUserDetails.profileImageURL != null &&
                                GlobalUserDetails.profileImageURL.isNotEmpty
                            ? onlineImageWidget(
                                GlobalUserDetails.profileImageURL)
                            : profileImageWidgetANDROID(),
                        // : Container(),
                        Positioned(
                          top: 90,
                          right: imagePath == null && imageURL == null
                              ? 115
                              : imagePath.isNotEmpty && imageURL == null
                                  ? -10
                                  : 115,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(10)),
                            child: IconButton(
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  final photosPermissionStatus =
                                      await checkStatus();
                                  if (photosPermissionStatus) {
                                    selectImageOnIOS();
                                  }
                                }),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                        controller: firstNameController,
                        hintText: "First Name *",
                        obscureText: false,
                        labelText: "First Name"),
                    SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                        controller: lastNameController,
                        hintText: "Last Name",
                        obscureText: false,
                        labelText: "Last Name"),
                    SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                        controller: emailController,
                        hintText: "Email ID",
                        obscureText: false,
                        labelText: "Email ID"),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _selectDate(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          height: 60,
                          child: TextField(
                            onTap: () {},
                            enabled: false,
                            controller: dobController,
                            obscureText: false,
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.white),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 5, 20.0, 5),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.8),
                                    width: 2),
                              ),
                              hintText: "D.O.B",
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
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        String selectedGender = genderController.text;
                        int value = genderData.indexWhere(
                            (element) => element == genderController.text);
                        selectedGender = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(child: Text('Select Gender')),
                                    content: Container(
                                      height:
                                          300.0, // Change as per your requirement
                                      width: 300.0, //
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              15)), // Change as per your requirement
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: genderData.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return RadioListTile(
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            title: Text(
                                              genderData[index].capitalize(),
                                              textAlign: TextAlign.start,
                                            ),
                                            value: index,
                                            groupValue: value,
                                            onChanged: (ind) {
                                              setState(() => value = ind);
                                              Navigator.pop(
                                                  context, genderData[index]);
                                            },
                                            activeColor: Colors.blueGrey,
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }) ??
                            selectedGender;
                        setState(() {
                          genderController.text = selectedGender;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          height: 60,
                          child: TextField(
                            onTap: () {},
                            enabled: false,
                            controller: genderController,
                            obscureText: false,
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.white),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 5, 20.0, 5),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.8),
                                    width: 2),
                              ),
                              hintText: "Gender",
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
                    SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                        onTap: () {},
                        enabled: true,
                        controller: businessNameController,
                        hintText: "Business Name",
                        obscureText: false,
                        labelText: "Business Name"),
                    SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                        controller: addressController,
                        hintText: "Address",
                        obscureText: false,
                        labelText: "Address"),
                    SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                        controller: pinCodeController,
                        hintText: "Pin-Code",
                        obscureText: false,
                        labelText: "Pin-Code"),
                    SizedBox(
                      height: 10,
                    ),
                    // ListTileSwitch(
                    //   value: _toggleFingerPrintLogin,
                    //   leading: Icon(
                    //     Icons.fingerprint,
                    //     color: Colors.white,
                    //   ),
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _toggleFingerPrintLogin = value;
                    //     });
                    //   },
                    //   switchActiveColor: Colors.blueGrey,
                    //   title: Text(
                    //     'Enable FingerPrint Login ',
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    editProfileButton(),
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
      bool enabled: true,
      bool obscureText: false,
      Function onTap,
      double height: 60.0}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: height,
        child: TextField(
          onTap: onTap,
          enabled: enabled,
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

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xff202427),
      elevation: 0.0,
      leading: Builder(
        builder: (buildContext) => GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            'assets/images/back_arrow.png',
            scale: 1,
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          "My Profile",
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget editProfileButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RoundedMaterialButton(
        child: Center(
          child: Text(
            "SUBMIT",
            style: TextStyle(
                color: Colors.white, fontFamily: 'Future Light', fontSize: 17),
          ),
        ),
        elevation: 10,
        onPressed: () {
          if (validateUserInputs()) {
            updateProfileAPICALL(
                name: firstNameController.text,
                lname: lastNameController.text,
                gender: genderController.text,
                email: emailController.text,
                contactNumber: contactController.text,
                businessName: businessNameController.text,
                address: addressController.text,
                pinCode: pinCodeController.text,
                profilePic: profileImage,
                dob: dobController.text,
                userID: GlobalUserDetails.userID);
          }
        },
      ),
    );
  }

  picker() async {
    try {
      final pickedFile =
          await _imagePicker.getImage(source: ImageSource.gallery);
      File file = File(pickedFile.path);
      print("the picked file path is: ${file.path}");
      setState(() {
        profileImage = file;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  image_picker() async {
    print('picker is called');
    PickedFile img = await ImagePicker().getImage(source: ImageSource.gallery);
    //

    File image = File(img.path);

    print(image.path);
    setState(() {
      profileImage = image;
    });
  }

  Future<bool> checkStatus() async {
    var status = await Permission.photos.status;
    print(status.isDenied);
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      openAppSettings();
      status = await Permission.photos.status;
      return status.isGranted;
    } else {
      try {
        PermissionStatus statusPermission = await Permission.photos.request();
        return statusPermission.isGranted;
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Widget onlineImageWidget(String imgURL) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blueGrey,
          shape: BoxShape.circle,
          image:
              DecorationImage(image: NetworkImage(imgURL), fit: BoxFit.cover)),
      width: 150,
      height: 150,
    );
  }

  Widget noImageWidget() {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage('assets/images/unSelectedImage.jpg'),
              fit: BoxFit.cover)),
      width: 150,
      height: 150,
    );
  }

  selectImageOnIOS() async {
    List<Media> res = await ImagesPicker.pick(
      cropOpt: CropOption(cropType: CropType.circle),
      count: 1,
      pickType: PickType.image,
      // cropOpt: CropOption(aspectRatio: CropAspectRatio.wh16x9),
    );
    if (res != null) {
      print(res[0]?.path);
      setState(() {
        profileImage = File(res[0].path);
        isImageSelected = true;
      });
    }
  }

  //TODO: GET USER PROFILE DETAILS
  void makeGetUserAPICall({int userID, bool calledAfterUpdate: false}) async {
    Map<String, dynamic> body = {
      "userID": userID.toString(),
    };

    logger.d("Login API body: $body");
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      setState(() {
        loading = true;
      });
      FormData formData = new FormData.fromMap(body);
      Response response =
          await Dio().post(AllUrls().getUserURL, data: formData);
      logger.d("Get User API Status code - ${response.statusCode}");
      logger.d("Get User API RESPO: ${response.data.toString()}");
      if (response.statusCode != 200) {
        setState(() {
          loading = false;
        });
      } else {
        //TODO:------------------SUCCESS RESPONSE--------------------------

        GetUserDetailsResponse userDetailsResponse =
            getUserDetailsResponseFromJson(response.data.toString());

        // preferences.setInt(SPKeys.userID, int.parse(loginResponse.data.userid));

        setState(() {
          loading = false;
          userDetails = userDetailsResponse;
        });

        if (userDetailsResponse.n == 1) {
          setState(() {
//TODO: Setthe user details in the app
            preferences.setInt(
                SPKeys.userID, userDetailsResponse.data[0].userId);
            preferences.setString(
                SPKeys.gender, userDetailsResponse.data[0].gender);
            preferences.setInt(
                SPKeys.userContact, userDetailsResponse.data[0].contactNumber);
            preferences.setString(
                SPKeys.userEmail, userDetailsResponse.data[0].emailId);
            preferences.setString(SPKeys.profileImageURL,
                userDetailsResponse.data[0].profilePictureUrl);
            preferences.setString(SPKeys.profileImageURL,
                userDetailsResponse.data[0].profilePictureUrl);

            GlobalUserDetails.userID = userDetailsResponse.data[0].userId;
            String lastName = userDetailsResponse.data[0].lname ?? "";
            GlobalUserDetails.userName =
                userDetailsResponse.data[0].name + lastName;
            GlobalUserDetails.userContact =
                userDetailsResponse.data[0].contactNumber;
            GlobalUserDetails.profileImageURL =
                userDetailsResponse.data[0].profilePictureUrl;
            GlobalUserDetails.userEmail = userDetailsResponse.data[0].emailId;

            if (userDetailsResponse.data[0].profilePictureUrl != null) {
              isImageSelected = false;
            }

            if (calledAfterUpdate) {
              firstNameController.clear();
              lastNameController.clear();
              emailController.clear();
              addressController.clear();
              businessNameController.clear();
              pinCodeController.clear();
              dobController.clear();
            }

            firstNameController.text = userDetailsResponse.data[0].name;
            lastNameController.text = userDetailsResponse.data[0].lname;
            genderController.text = userDetailsResponse.data[0].gender != ""
                ? userDetailsResponse.data[0].gender
                : "I prefer not to say";

            emailController.text = userDetailsResponse.data[0].emailId;
            contactController.text =
                userDetailsResponse.data[0].contactNumber.toString();
            addressController.text = userDetailsResponse.data[0].addres;
            businessNameController.text =
                userDetailsResponse.data[0].businesName;
            pinCodeController.text = userDetailsResponse.data[0].pincode != null
                ? userDetailsResponse.data[0].pincode.toString()
                : "";
            dobController.text = userDetailsResponse.data[0].dateOfBirth;
            if (calledAfterUpdate) {
              Fluttertoast.showToast(
                msg: "User details Updated SuccessFully!!",
              );
            }
          });
        } else {
          Fluttertoast.showToast(
              msg: "User details could not be fetched!!",
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

  //TODO:  UPDATE USER API CALL
  void updateProfileAPICALL(
      {String name,
      String email,
      String contactNumber,
      String businessName,
      String address,
      String pinCode,
      String dob,
      File profilePic,
      int userID,
      String lname,
      String gender}) async {
    Map<String, dynamic> body = {
      "name": name,
      "emailID": email,
      "contact_number": contactNumber,
      "businesName": businessName,
      "addres": address,
      "pincode": pinCode,
      "profile_picture_URL": profilePic == null
          ? null
          : await MultipartFile.fromFile(profilePic.path,
              filename: profilePic.path.split('/').last),
      "userID": userID.toString(),
      "dob": dob,
      "lname": lname,
      "gender": gender
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
          await Dio().post(AllUrls().updateUserProfile, data: formData);
      logger.d("Update User API Status code - ${response.statusCode}");
      logger.d("Update User API RESPO: ${response.data.toString()}");
      if (response.statusCode != 200) {
        setState(() {
          loading = false;
        });
      } else {
        //TODO:------------------SUCCESS RESPONSE--------------------------

        GetUserDetailsResponse updateUserDetailsResponse =
            getUserDetailsResponseFromJson(response.data.toString());

        // preferences.setInt(SPKeys.userID, int.parse(loginResponse.data.userid));

        setState(() {
          loading = false;
        });

        if (updateUserDetailsResponse.n == 1) {
          makeGetUserAPICall(userID: userID, calledAfterUpdate: true);
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

    if (firstNameController.text == null || firstNameController.text.isEmpty) {
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

    // if (contactController.text == null || contactController.text.isEmpty) {
    //   Fluttertoast.showToast(
    //       msg: "Please mention mobile Number",
    //       backgroundColor: Color(0xffBF3B38),
    //       textColor: Colors.white,
    //       toastLength: Toast.LENGTH_SHORT);
    //   return false;
    // }

    if (!nameRegex.hasMatch(firstNameController.text)) {
      Fluttertoast.showToast(
          msg: "Name field should not contain special characters",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }

    if (lastNameController.text != null && lastNameController.text.isNotEmpty) {
      if (!nameRegex.hasMatch(firstNameController.text)) {
        Fluttertoast.showToast(
            msg: "Last name field should not contain special characters",
            backgroundColor: Color(0xffBF3B38),
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT);
        return false;
      }
    }
    if (!emailRegex.hasMatch(emailController.text)) {
      Fluttertoast.showToast(
          msg: "Please enter a valid Email-ID",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }

    if (genderController.text == null || genderController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please choose your gender",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    //
    // if (contactController.text.length != 10) {
    //   Fluttertoast.showToast(
    //       msg: "Please enter a valid mobile Number",
    //       backgroundColor: Color(0xffBF3B38),
    //       textColor: Colors.white,
    //       toastLength: Toast.LENGTH_SHORT);
    //   return false;
    // }

    if (pinCodeController.text.isNotEmpty &&
        pinCodeController.text.length != 6) {
      Fluttertoast.showToast(
          msg: "Please enter a valid pin-code",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }

    return true;
  }

  Widget profileImageWidgetANDROID() {
    if (profileImage == null && imageURL == null) {
      return noImageWidget();
    } else if (profileImage.path.isNotEmpty && imageURL == null) {
      return CircleAvatar(
        minRadius: 80,
        backgroundImage: Image.file(
          profileImage,
          fit: BoxFit.contain,
        ).image,
      );
    } else
      return Container();
  }

  bool isPlatformAndroid() => Platform.isAndroid;

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year - 80), // Refer step 1
        firstDate: DateTime(DateTime.now().year - 80),
        lastDate: DateTime(DateTime.now().year - 15),
        helpText: "Select Date of Birth",
        builder: (BuildContext context, Widget child) {
          return Material(
            color: Colors.transparent,
            child: Theme(
              child: child,
              data: ThemeData(primarySwatch: Colors.blueGrey),
            ),
          );
        });

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dobController.text = DateFormat('dd-MMM-yyyy').format(selectedDate);
      });
  }
}
