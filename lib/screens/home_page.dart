import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:my_neighbourhood_online/BLOC/categories_bloc.dart';
import 'package:my_neighbourhood_online/Networking/all_urls.dart';
import 'package:my_neighbourhood_online/Networking/response_status.dart';
import 'package:my_neighbourhood_online/Networking/set_count_api_call.dart';
import 'package:my_neighbourhood_online/Utilities/googleMapLauncher.dart';
import 'package:my_neighbourhood_online/Utilities/key_constants.dart';
import 'package:my_neighbourhood_online/api_response_model/add_favourite_response.dart';
import 'package:my_neighbourhood_online/api_response_model/blog_response.dart'
    as blog;
import 'package:my_neighbourhood_online/api_response_model/categories_response.dart';
import 'package:my_neighbourhood_online/api_response_model/category_wise_properties.dart';
import 'package:my_neighbourhood_online/api_response_model/get_favourite_response.dart';
import 'package:my_neighbourhood_online/api_response_model/get_location_response.dart'
    as gl;
import 'package:my_neighbourhood_online/api_response_model/get_properties_response.dart'
    as gt;
import 'package:my_neighbourhood_online/api_response_model/remove_favourite_response.dart';
import 'package:my_neighbourhood_online/main.dart';
import 'package:my_neighbourhood_online/route_transitions/dart/route_transitions.dart';
import 'package:my_neighbourhood_online/screens/app_drawer.dart';
import 'package:my_neighbourhood_online/screens/blog_details.dart';
import 'package:my_neighbourhood_online/screens/category_wise_properties.dart';
import 'package:my_neighbourhood_online/screens/login.dart';
import 'package:my_neighbourhood_online/screens/notifications_page.dart';
import 'package:my_neighbourhood_online/screens/single_property_view.dart';
import 'package:my_neighbourhood_online/widget/base_canvas.dart';
import 'package:my_neighbourhood_online/widget/custom_loader.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  ScrollController categoriesScrollController =
      ScrollController(keepScrollOffset: true);
  AnimationController animationController;
  bool _menuShown = false;

  // List<BusinessCategory> cateogryLabelList = [];
  // CategoriesStatus categoriesStatus = CategoriesStatus.NONE;
  //
  // List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  // ListItem _selectedItem;

  var logger = Logger(printer: PrettyPrinter(methodCount: 0));
  bool loading = false;
  String location = "Select Location";
  //TODO: CATEGORIES BLOC
  ChuckCategoryBloc _bloc;
  final searchBarController = FloatingSearchBarController();
  List<gt.Data> placeNearBy = [];
  List<blog.Result> blogData = [];
  List<gl.Datum> locationData = [];

  @override
  void initState() {
    // getCurrentLocation(context);
    getLocationAPICALL();
    // TODO: implement initState
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    // getLocation(context);

    setuserProfile();
    getPropertiesAPICall();
    getFavouritesList(userID: GlobalUserDetails.userID);
    getBlogApiCall();
    super.initState();
    _bloc = ChuckCategoryBloc();
  }

  void getCurrentLocation(BuildContext context) async {
    Location _location = Location();

    LocationData _locationData;

    _locationData = await _location.getLocation();

    final coordinates =
        new Coordinates(_locationData.latitude, _locationData.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    setState(() {
      location = addresses[0].subLocality + ', ' + addresses[0].locality;
    });
  }

  void setuserProfile() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      GlobalUserDetails.userID = preferences.getInt(SPKeys.userID);
      GlobalUserDetails.userName = preferences.getString(SPKeys.firstName);
      GlobalUserDetails.userContact = preferences.getInt(SPKeys.userContact);
      GlobalUserDetails.profileImageURL =
          preferences.getString(SPKeys.profileImageURL);
    });
  }

  void updateNotificationStatus(bool status) {
    setState(() {
      GlobalUserDetails.newNotification = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Timer(Duration(seconds: 1), () {
    //   getLocation(context);
    // });
    //     Provider.of<LocationProvider>(context).currentLocation;

    return WillPopScope(
      onWillPop: () async {
        // _openLogoutConfirmationDialog(context);
        exit(0);
        return true;
      },
      child: Stack(
        children: [
          Scaffold(
            drawer: AppDrawer(),
            appBar: AppBar(
              backgroundColor: Color(0xff202427),
              leading: Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Image.asset(
                    "assets/images/app_drawer_icon.png",
                    scale: 3,
                  ),
                ),
              ),
              actions: [
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () async {
                      String selectedLocation = location;
                      int value = locationData
                          .indexWhere((element) => element.fldName == location);
                      selectedLocation = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(child: Text('Locations')),
                                  content: Container(
                                    height:
                                        300.0, // Change as per your requirement
                                    width: 300.0, //
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            15)), // Change as per your requirement
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: locationData.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return RadioListTile(
                                          controlAffinity:
                                              ListTileControlAffinity.trailing,
                                          title: Text(
                                            locationData[index]
                                                .fldName
                                                .capitalize(),
                                            textAlign: TextAlign.start,
                                          ),
                                          value: index,
                                          groupValue: value,
                                          onChanged: (ind) {
                                            setState(() => value = ind);
                                            Navigator.pop(context,
                                                locationData[index].fldName);
                                          },
                                          activeColor: Colors.blueGrey,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }) ??
                          location;
                      setState(() {
                        location = selectedLocation;
                      });
                      getPropertiesAPICall();
                    },
                    child: Container(
                      width: 150.0,
                      height: 35.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xff383A47), Color(0xff272934)])),
                      child: Center(
                          child: Text(
                        location.isEmpty
                            ? "Select Location"
                            : location.capitalize(),
                        textAlign: TextAlign.center,
                      )),
                    ),
                  ),
                ),
                // Adobe XD layer: 'Dropdown' (group)

                SizedBox(
                  width: 10,
                ),

                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 50,
                    width: 50,
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            width: 35.0,
                            height: 35.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xff383A47),
                                      Color(0xff272934)
                                    ])),
                            child: Center(
                                child: GestureDetector(
                                    onTap: () {
                                      controller.add(false);
                                      Navigator.push(context,
                                          FadeRoute(page: NotificationsPage()));
                                    },
                                    child: Icon(Icons.notifications))),
                          ),
                        ),
                        StreamBuilder(
                            stream: controller.stream,
                            initialData: false,
                            builder: (context, snapshot) => snapshot.data
                                ? Positioned(
                                    top: 2,
                                    right: 2,
                                    child: Container(
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red),
                                    ),
                                  )
                                : Container())
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            body: BaseCanvas(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 20),
                          //   child: Container(
                          //       padding: EdgeInsets.symmetric(horizontal: 3),
                          //       decoration: BoxDecoration(
                          //           color: Colors.white,
                          //           borderRadius: BorderRadius.circular(10)),
                          //       height: 40,
                          //       child: Row(
                          //         children: [
                          //           Expanded(
                          //             child: Padding(
                          //               padding:
                          //                   const EdgeInsets.symmetric(horizontal: 10),
                          //               child: Container(
                          //                 decoration: BoxDecoration(
                          //                     color: Colors.white,
                          //                     borderRadius: BorderRadius.circular(5)),
                          //                 padding: EdgeInsets.symmetric(horizontal: 3),
                          //                 height: 30,
                          //                 child: Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.spaceBetween,
                          //                   children: [
                          //                     Expanded(
                          //                       child: TextField(
                          //                         controller: TextEditingController(),
                          //                         decoration: InputDecoration.collapsed(
                          //                             hintText: "Search Places ...",
                          //                             hintStyle: TextStyle(
                          //                                 color: Colors.grey,
                          //                                 fontSize: 14)),
                          //                       ),
                          //                     ),
                          //                     Container(
                          //                       height: 30,
                          //                       width: 30,
                          //                       decoration: BoxDecoration(
                          //                           color: Colors.black,
                          //                           borderRadius:
                          //                               BorderRadius.circular(5)),
                          //                       child: Icon(
                          //                         Icons.search,
                          //                         size: 16,
                          //                         color: Colors.white,
                          //                       ),
                          //                     )
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           )
                          //         ],
                          //       )),
                          // ),
                          SizedBox(
                            height: 50,
                          ),
                          buildCategories(),
                          SizedBox(
                            height: 10,
                          ),
                          // buildFiveReasonsListView()
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "MNO DISCOVER".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(2.2),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              width: double.maxFinite,
                              height: 220,
                              child: blogData == null || blogData.isEmpty
                                  ? Center(
                                      child: Text(
                                        "No new blogs yet...",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : buildFiveReasonsListView()),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Places  near  by".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(2.2),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          placeNearBy.isEmpty
                              ? Container(
                                  height: 250,
                                  child: Center(
                                    child: Text(
                                      location == "Select Location"
                                          ? "Please select a location"
                                          : "No places near by ${location.capitalize()}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10),
                                  child: buildPlacesListView(),
                                ),
                        ],
                      ),
                    ),
                  ),
                  StatefulBuilder(
                      builder: (context, setState) => buildSearchBarUI())
                ],
              ),
            ),
          ),
          loading ? CustomLoader() : Container()
        ],
      ),
    );
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
          setState(() {
            loading = false;
          });
        } else if (loginMethod == "LoginMethod.API_LOGIN") {
          print("API logout");
          pref.clear();
          setState(() {
            loading = false;
          });
        } else if (loginMethod == "LoginMethod.FACEBOOK_LOGIN") {
          print("FACEBOOK LOGOUT");
          await FacebookAuth.instance.logOut();
          pref.clear();
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

  ListView buildFiveReasonsListView() {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: blogData.length,
        itemBuilder: (context, i) => Padding(
              padding: EdgeInsets.only(top: 0, left: 20, right: 20),
              child: Neumorphic(
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    depth: 3,
                    lightSource: LightSource.topLeft,
                    shadowLightColorEmboss: Colors.white,
                    shadowLightColor: Colors.white60,
                    shadowDarkColor: Colors.white54),
                child: Container(
                  height: 200,
                  width: 250,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                FadeRoute(
                                    page: BlogDetailsScreen(
                                  blogDetails: blogData[i],
                                )));
                          },
                          child: FancyShimmerImage(
                            imageUrl: blogData[i].blogimage,
                            height: 220,
                            width: double.infinity,
                            boxFit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            color: Colors.black.withOpacity(0.8),
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Visit ',
                                        style: TextStyle(
                                            fontSize:
                                                ResponsiveFlutter.of(context)
                                                    .fontSize(1.5),
                                            fontWeight: FontWeight.w500)),
                                    TextSpan(
                                        text: blogData[i].propertyName,
                                        style: TextStyle(
                                            fontSize:
                                                ResponsiveFlutter.of(context)
                                                    .fontSize(2),
                                            color: Color(0xffD89635),
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: ' for',
                                        style: TextStyle(
                                            fontSize:
                                                ResponsiveFlutter.of(context)
                                                    .fontSize(1.5),
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  void launchWhatsApp({
    @required String phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      Fluttertoast.showToast(
          msg: "Could not send message to $phone",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      throw 'Could not launch ${url()}';
    }
  }

  Widget buildPlacesListView() {
    return ListView.builder(
        shrinkWrap: true,
        physics: RangeMaintainingScrollPhysics(),
        itemCount: placeNearBy.length,
        itemBuilder: (context, i) => Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              child: Neumorphic(
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    depth: 6,
                    lightSource: LightSource.topLeft,
                    shadowLightColorEmboss: Colors.white,
                    shadowLightColor: Colors.white60,
                    shadowDarkColor: Colors.white54),
                child: Container(
                  height: 255,
                  width: 180,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 255,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: GestureDetector(
                              onTap: () {
                                print("inside");
                                Navigator.push(
                                    context,
                                    FadeRoute(
                                        page: SinglePropertyView(
                                      property: placeNearBy[i],
                                    )));
                              },
                              child: FancyShimmerImage(
                                imageUrl: placeNearBy[i].blogCoverImage,
                                boxFit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () async {
                              print(AllProperties.favouritePropertiesID);
                              print(
                                  "Check property: ${AllProperties.checkFavouritesAvailability(placeNearBy[i].propertyid)}");

                              if (AllProperties.checkFavouritesAvailability(
                                  placeNearBy[i].propertyid)) {
                                removeFavouriteApiCall(
                                    userID: GlobalUserDetails.userID,
                                    propertyID: placeNearBy[i].propertyid);
                              } else {
                                markAsFavouriteApiCall(
                                  businessPropertyID: placeNearBy[i].propertyid,
                                  userID: GlobalUserDetails.userID,
                                );
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 10, top: 10),
                              child: StatefulBuilder(
                                builder: (context, setState) => Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Center(
                                      child: Icon(
                                        Icons.star,
                                        color: AllProperties
                                                .checkFavouritesAvailability(
                                                    placeNearBy[i].propertyid)
                                            ? Colors.red.shade800
                                            : Colors.grey,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          top: 190,
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                              Color(0xff191921),
                              Color(0xff3A3A43)
                            ])),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(height: 10),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                FadeRoute(
                                                    page: SinglePropertyView(
                                                  property: placeNearBy[i],
                                                )));
                                          },
                                          child: Text(
                                            " ${placeNearBy[i].propertyName}",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: ResponsiveFlutter.of(
                                                        context)
                                                    .fontSize(2),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                GoogleMapLauncher.openMap(
                                                    placeNearBy[i].googleMap);
                                              },
                                              child: Icon(
                                                Icons.place,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                GoogleMapLauncher.openMap(
                                                    placeNearBy[i].googleMap);
                                              },
                                              child: Text(
                                                placeNearBy[i]
                                                        .location
                                                        .capitalize() ??
                                                    "",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Text(
                                              " . ${placeNearBy[i].categoryName.capitalize()}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w200,
                                                  color: Colors.white),
                                            ),

                                            SizedBox(
                                              width: 5,
                                            ),
                                            // Text(
                                            //   "12.6 Km",
                                            //   style: TextStyle(
                                            //       color: Colors.black,
                                            //       fontSize: 13),
                                            // )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final SharedPreferences pref =
                                          await SharedPreferences.getInstance();
                                      SetClickCountApiCall(
                                          2,
                                          placeNearBy[i].propertyid,
                                          pref.getInt(SPKeys.userID));
                                      if (placeNearBy[i].blogAvailable == 1) {
                                        List<String> imageUrls = placeNearBy[i]
                                            .blogMultipleImage
                                            .split(',');
                                        showImageCarouselDialog(
                                            context, imageUrls);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "No Images Available !",
                                            backgroundColor: Color(0xffBF3B38),
                                            textColor: Colors.white,
                                            toastLength: Toast.LENGTH_SHORT);
                                      }
                                    },
                                    child: Image.asset(
                                      'assets/images/gallery_icon.png',
                                      scale: 2,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () async {
                                      final SharedPreferences pref =
                                          await SharedPreferences.getInstance();
                                      SetClickCountApiCall(
                                          4,
                                          placeNearBy[i].propertyid,
                                          pref.getInt(SPKeys.userID));
                                      if (placeNearBy[i].callingNumber !=
                                          null) {
                                        launch(
                                            "tel://${placeNearBy[i].callingNumber}");
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                "This property has no contact number!",
                                            backgroundColor: Color(0xffBF3B38),
                                            textColor: Colors.white,
                                            toastLength: Toast.LENGTH_SHORT);
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Image.asset(
                                        'assets/images/call_icon.png',
                                      ),
                                    ),
                                  ),
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
            ));
  }

  void showImageCarouselDialog(BuildContext context, List<String> imageList) {
    double rating = 0.5;
    TextEditingController feedbackController = TextEditingController();
    bool loading = false;
    GlobalKey _sliderKey = GlobalKey();
    showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {},
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.4),
        barrierLabel: '',
        transitionBuilder: (context, anim1, anim2, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                color: Colors.transparent,
                child: CarouselSlider.builder(
                    key: _sliderKey,
                    scrollDirection: Axis.vertical,
                    unlimitedMode: false,
                    viewportFraction: 0.4,
                    slideBuilder: (index) {
                      return Container(
                        alignment: Alignment.topCenter,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: imageList[index],
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          ),
                        ),
                      );
                    },
                    itemCount: imageList.length),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 300));
  }

  Widget buildCategories() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 100,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              categoriesScrollController.animateTo(
                  categoriesScrollController.position.maxScrollExtent,
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 300));
            },
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey.shade200),
              height: 20,
              width: 20,
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.black,
                  size: 10,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          StreamBuilder<ResponseStatus<CategoriesResponse>>(
            stream: _bloc.chuckListStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case Status.LOADING:
                    return Center(child: CircularProgressIndicator());
                    break;
                  case Status.COMPLETED:
                    return Expanded(
                      child: ListView.builder(
                        controller: categoriesScrollController,
                        shrinkWrap: true,
                        reverse: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.data.data.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: GestureDetector(
                            onTap: () {
                              getPropertiesByCategories(
                                  categoryID: int.parse(snapshot
                                      .data.data.data[index].categoryId),
                                  category: snapshot
                                      .data.data.data[index].categoryName);
                            },
                            child: Container(
                              height: 100,
                              child: Column(
                                children: [
                                  FancyShimmerImage(
                                    height: 35,
                                    width: 35,
                                    imageUrl: snapshot
                                        .data.data.data[index].categoryImage,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 80,
                                    child: Center(
                                      child: Text(
                                        snapshot
                                            .data.data.data[index].categoryName
                                            .capitalize(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                ResponsiveFlutter.of(context)
                                                    .fontSize(1.5)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                    break;
                  case Status.ERROR:
                    return Text("error");
                    break;
                }
              }
              return Container();
            },
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              categoriesScrollController.animateTo(0.0,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300));
            },
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey.shade200),
              height: 20,
              width: 20,
              child: Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 10,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  //
  // void getLocation(BuildContext context) {
  //   Provider.of<LocationProvider>(context, listen: false)
  //       .getCurrentLocation(context);
  // }

  Widget buildSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: FloatingSearchBar(
        controller: searchBarController,
        hint: 'Search for Location or Place ...',
        hintStyle: TextStyle(fontSize: 12, color: Colors.blueGrey),
        onFocusChanged: (isFocusChanged) {
          if (isFocusChanged) {
            print("AllProperties.searchMatchList.clear()");
            setState(() {
              AllProperties.searchMatchList.clear();
            });
          }
        },
        openAxisAlignment: 0.0,
        maxWidth: 600,
        axisAlignment: 0.0,
        scrollPadding: EdgeInsets.only(top: 16, bottom: 20),
        elevation: 10,
        scrollController: ScrollController(keepScrollOffset: false),
        clearQueryOnClose: true,
        onQueryChanged: (query) {
          //Your methods will be here
          print("Inside query $query");
          AllProperties.searchMatchList.clear();
          AllProperties.allProperties.forEach((property) {
            print("searcing ");
            if (property.location
                    .trim()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                property.propertyName
                    .trim()
                    .toLowerCase()
                    .contains(query.toLowerCase())) {
              setState(() {
                AllProperties.searchMatchList.add(property);
                logger.d("Searlist: ${AllProperties.searchMatchList.length}");
              });
            }
          });
        },
        showDrawerHamburger: false,
        transitionCurve: Curves.easeInOut,
        transitionDuration: Duration(milliseconds: 500),
        transition: CircularFloatingSearchBarTransition(),
        debounceDelay: Duration(milliseconds: 500),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: Icon(Icons.search_rounded),
              onPressed: () {
                print('Places Pressed');
                setState(() {
                  AllProperties.searchMatchList.clear();
                });
              },
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: 600.0,
                color: Colors.white,
                child: AllProperties.searchMatchList.isEmpty
                    ? Center(
                        child:
                            Text("No locations matched your search results!"),
                      )
                    : ListView.separated(
                        itemCount: AllProperties.searchMatchList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, i) => ListTile(
                          title: Text(
                              AllProperties.searchMatchList[i].propertyName),
                          subtitle: Text(AllProperties
                              .searchMatchList[i].location
                              .toString()
                              .capitalize()),
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              searchBarController.hide();
                            });
                            Navigator.push(
                                context,
                                FadeRoute(
                                    page: SinglePropertyView(
                                  property: AllProperties.searchMatchList[i],
                                )));
                          },
                          trailing: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: FancyShimmerImage(
                              imageUrl: AllProperties
                                  .searchMatchList[i].blogCoverImage,
                              height: 60,
                              width: 80,
                              boxFit: BoxFit.cover,
                            ),
                          ),
                        ),
                        separatorBuilder: (context, i) => Divider(),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  //TODO: APi call to get all the business properties
  Future<void> getPropertiesAPICall() async {
    logger.d("Get pROperties api call");
    try {
      Response response = await Dio().get(AllUrls().getPropertiesURL);
      logger.d("Get properties  status code - ${response.statusCode}");
      logger.d("Get properties API RESPO: ${response.data.toString()}");
      if (response.statusCode != 200) {
        setState(() {
          loading = false;
        });
      } else {
        //TODO:------------------SUCCESS RESPONSE--------------------------

        gt.GetPropertiesResponse getPropertiesResponse =
            gt.getPropertiesResponseFromJson(response.data.toString());

        // preferences.setInt(SPKeys.userID, int.parse(loginResponse.data.userid));

        setState(() {
          loading = false;
        });

        if (getPropertiesResponse.n == 1) {
//TODO: Set the Global properties in the app

          setState(() {
            placeNearBy.clear();
            AllProperties.allProperties = getPropertiesResponse.data;
            print(
                "THIs is the location;${location.split(',')[0].toLowerCase()}");
          });

          getPropertiesResponse.data.forEach((element) {
            if (element.location
                .toLowerCase()
                .contains(location.toLowerCase())) {
              setState(() {
                placeNearBy.add(element);
              });
            }
          });
        } else {
          Fluttertoast.showToast(
              msg:
                  "Could not fetch the properties from db ... Please try again.",
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

  //TODO: API call to get the favourite properties
  void getFavouritesList({int userID}) async {
    Map<String, dynamic> body = {"UserID": userID.toString()};

    logger.d("Get FavouritesList: $body");
    try {
      // final SharedPreferences preferences =
      //     await SharedPreferences.getInstance();

      setState(() {
        loading = true;
      });
      FormData formData = new FormData.fromMap(body);
      Response response =
          await Dio().post(AllUrls().getFavouritesURL, data: formData);
      logger.d("Get Favourites Status code - ${response.statusCode}");
      logger.d("Get Favourites RESP: ${response.data.toString()}");
      if (response.statusCode != 200) {
        setState(() {
          loading = false;
        });
      } else {
        //TODO:------------------SUCCESS RESPONSE--------------------------

        GetFavouritesResponse getFavouritesResponse =
            getFavouritesResponseFromJson(response.data.toString());

        setState(() {
          loading = false;
          AllProperties.favouritePropertiesID.clear();
        });

        if (getFavouritesResponse.n == 1) {
          setState(() {
            getFavouritesResponse.data.forEach((property) {
              AllProperties.favouritePropertiesID.add(property.propertyid);
            });
          });
          logger
              .e("T favourite list is ${AllProperties.favouritePropertiesID}");
        } else {
          //TODO: If there are no favourites, then the n will be 0 and data would be null from the API

          setState(() {
            AllProperties.favouritePropertiesID = [];
            AllProperties.favouritePropertiesID.clear();
          });
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
    } catch (e) {
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

  //TODO: get the blog api

  void getBlogApiCall() async {
    logger.d("Get BLOG api call");
    try {
      Response response = await Dio().get(AllUrls().blogURL);
      logger.d("Get BLOG  status code - ${response.statusCode}");
      logger.d("Get BLOG API RESPO: ${response.data.toString()}");
      if (response.statusCode != 200) {
        setState(() {
          loading = false;
        });
      } else {
        //TODO:------------------SUCCESS RESPONSE--------------------------

        blog.GetBlog getBlogResponse =
            blog.getBlogFromJson(response.data.toString());

        // preferences.setInt(SPKeys.userID, int.parse(loginResponse.data.userid));

        setState(() {
          loading = false;
        });

        if (getBlogResponse.n == 1) {
//TODO: Set the Global properties in the app
          setState(() {
            blogData = getBlogResponse.data.result;
          });
        } else {
          Fluttertoast.showToast(
              msg:
                  "Could not fetch the properties from db ... Please try again.",
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
  //TODO: Category wise properties

  void getPropertiesByCategories({int categoryID, String category}) async {
    Map<String, dynamic> body = {
      "catid": categoryID,
    };

    logger.d("Update profile body: $body");
    try {
      // final SharedPreferences preferences =
      //     await SharedPreferences.getInstance();

      setState(() {
        loading = true;
      });
      FormData formData = new FormData.fromMap(body);
      Response response = await Dio()
          .post(AllUrls().categoryWisePropertiesAPICall, data: formData);
      logger.d("Get catefory properties  status code - ${response.statusCode}");
      logger
          .d("Get categories properties API RESP: ${response.data.toString()}");
      if (response.statusCode != 200) {
        setState(() {
          loading = false;
        });
      } else {
        //TODO:------------------SUCCESS RESPONSE--------------------------

        GetCategoryWiseResponse getPropertiesResponse =
            getCategoryWiseResponseFromJson(response.data.toString());

        // preferences.setInt(SPKeys.userID, int.parse(loginResponse.data.userid));

        setState(() {
          loading = false;
        });

        if (getPropertiesResponse.n == 1) {
//TODO: Set the Global properties in the app
          Navigator.push(
              context,
              FadeRoute(
                  page: CategoryWiseProperties(
                categoryName: category,
                properties: getPropertiesResponse.data,
              )));
        } else {
          Fluttertoast.showToast(
              msg:
                  "Could not fetch the properties for $category ... Please try again.",
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

  //TODO: Api to call the mark as favourite api call
  void markAsFavouriteApiCall({int businessPropertyID, int userID}) async {
    Map<String, dynamic> body = {
      "userid": userID,
      "businessPropertyID": businessPropertyID,
      "favourite": "true"
    };

    logger.d("add fav API body: $body");
    try {
      setState(() {
        loading = true;
      });
      FormData formData = new FormData.fromMap(body);
      Response response =
          await Dio().post(AllUrls().addFavouriteURL, data: formData);
      logger.d("Add favourite API Status code - ${response.statusCode}");
      logger.d("Add favourite API API RESPO: ${response.data.toString()}");
      if (response.statusCode != 200) {
        setState(() {
          loading = false;
        });
      } else {
        //TODO:------------------SUCCESS RESPONSE--------------------------

        AddFavouriteResponse addFavouriteResponse =
            addFavouriteResponseFromJson(response.data.toString());

        // preferences.setInt(SPKeys.userID, int.parse(loginResponse.data.userid));

        setState(() {
          loading = false;
        });

        if (addFavouriteResponse.n == 1) {
          Fluttertoast.showToast(
              msg: "Added as favourites, check favourites section",
              backgroundColor: Colors.green,
              textColor: Colors.white,
              toastLength: Toast.LENGTH_LONG);
          getFavouritesList(userID: userID);
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

  //TODO: API CALL to remove a property from favourites
  void removeFavouriteApiCall({int propertyID, int userID}) async {
    Map<String, dynamic> body = {
      "userID": userID,
      "property_ID": propertyID,
    };

    logger.d("Remove API body: $body");
    try {
      setState(() {
        loading = true;
      });
      FormData formData = new FormData.fromMap(body);
      Response response =
          await Dio().post(AllUrls().removeFavouriteURL, data: formData);
      logger.d("Remove favourite API Status code - ${response.statusCode}");
      logger.d("Remove favourite API API RESPO: ${response.data.toString()}");
      if (response.statusCode != 200) {
        setState(() {
          loading = false;
        });
      } else {
        //TODO:------------------SUCCESS RESPONSE--------------------------

        RemoveFavouriteResponse removeFavouriteResponse =
            removeFavouriteResponseFromJson(response.data.toString());

        // preferences.setInt(SPKeys.userID, int.parse(loginResponse.data.userid));

        setState(() {
          loading = false;
        });

        if (removeFavouriteResponse.n == 1) {
          Fluttertoast.showToast(
              msg: "Removed the property from favourites!!",
              backgroundColor: Colors.green,
              textColor: Colors.white,
              toastLength: Toast.LENGTH_LONG);
          getFavouritesList(userID: userID);
        } else {
          Fluttertoast.showToast(
              msg: "Could not remove the property from favourites!",
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

  //TODO: Get Locations List
  Future<void> getLocationAPICALL() async {
    logger.d("Get Location api call");
    try {
      Response response = await Dio().get(AllUrls().getLocationURL);
      logger.d("Get Location  status code - ${response.statusCode}");
      logger.d("Get location API RESPO: ${response.data.toString()}");
      if (response.statusCode != 200) {
        setState(() {
          loading = false;
        });
      } else {
        //TODO:------------------SUCCESS RESPONSE--------------------------

        gl.GetLocationResponse getLocationResponse =
            gl.getLocationResponseFromJson(response.data.toString());

        // preferences.setInt(SPKeys.userID, int.parse(loginResponse.data.userid));

        setState(() {
          loading = false;
        });

        if (getLocationResponse.n == 1) {
//TODO: Set the Global properties in the app
          setState(() {
            locationData = getLocationResponse.data;
          });
        } else {
          Fluttertoast.showToast(
              msg:
                  "Could not fetch the properties from db ... Please try again.",
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

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class CategoryLabel {
  String iamgeUrl;
  String cateogryName;

  CategoryLabel({this.iamgeUrl, this.cateogryName});
}
