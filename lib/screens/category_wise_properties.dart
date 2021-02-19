import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:my_neighbourhood_online/Networking/all_urls.dart';
import 'package:my_neighbourhood_online/Networking/set_count_api_call.dart';
import 'package:my_neighbourhood_online/Utilities/googleMapLauncher.dart';
import 'package:my_neighbourhood_online/Utilities/key_constants.dart';
import 'package:my_neighbourhood_online/api_response_model/add_favourite_response.dart';
import 'package:my_neighbourhood_online/api_response_model/category_wise_properties.dart';
import 'package:my_neighbourhood_online/api_response_model/get_favourite_response.dart';
import 'package:my_neighbourhood_online/api_response_model/get_properties_response.dart';
import 'package:my_neighbourhood_online/api_response_model/remove_favourite_response.dart';
import 'package:my_neighbourhood_online/route_transitions/dart/route_transitions.dart';
import 'package:my_neighbourhood_online/screens/360_view_screen.dart';
import 'package:my_neighbourhood_online/screens/app_drawer.dart';
import 'package:my_neighbourhood_online/screens/single_property_view.dart';
import 'package:my_neighbourhood_online/widget/base_canvas.dart';
import 'package:my_neighbourhood_online/widget/custom_loader.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class CategoryWiseProperties extends StatefulWidget {
  String categoryName;
  List<Datum> properties;

  CategoryWiseProperties({Key key, this.categoryName, this.properties})
      : super(key: key);

  @override
  _CategoryWiseProperties createState() =>
      _CategoryWiseProperties(categoryProperty: this.properties);
}

class _CategoryWiseProperties extends State<CategoryWiseProperties>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool _menuShown = false;
  String _value;
  bool loading = false;

  List<Datum> categoryProperty;
  var logger = Logger(printer: PrettyPrinter());

  _CategoryWiseProperties({this.categoryProperty});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          drawer: AppDrawer(),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.black,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset('assets/images/back_arrow.png'),
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                widget.categoryName.capitalize(),
                style: GoogleFonts.montserrat(color: Colors.white),
              ),
            ),
          ),
          body: BaseCanvas(
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                      child: categoryProperty.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "You do not have favourites yet...!",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: categoryProperty.length,
                              itemBuilder: (context, i) => Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                FadeRoute(
                                                    page: SinglePropertyView(
                                                  property: Data(
                                                      propertyWebsite:
                                                          categoryProperty[i]
                                                              .propertyWebsite,
                                                      fullAddress: categoryProperty[i]
                                                          .fullAddress,
                                                      categoryName: categoryProperty[i]
                                                          .categoryName,
                                                      latitude: categoryProperty[i]
                                                          .latitude,
                                                      longitude: categoryProperty[i]
                                                          .longitude,
                                                      propertyName: categoryProperty[i]
                                                          .propertyName,
                                                      propertyid: categoryProperty[i]
                                                          .propertyid,
                                                      whatsappNumber:
                                                          categoryProperty[i]
                                                              .whatsappNumber,
                                                      propertyDescription:
                                                          categoryProperty[i]
                                                              .propertyDescription,
                                                      link360: categoryProperty[i]
                                                          .link360,
                                                      googleMap: categoryProperty[i]
                                                          .googleMap,
                                                      callingNumber: categoryProperty[i]
                                                          .callingNumber,
                                                      blogMultipleImage:
                                                          categoryProperty[i]
                                                              .blogMultipleImage,
                                                      blogCoverImage: categoryProperty[i].blogCoverImage,
                                                      blogAvailable: categoryProperty[i].blogAvailable,
                                                      location: categoryProperty[i].location,
                                                      catid: categoryProperty[i].categoryid),
                                                )));
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 275,
                                            child: FancyShimmerImage(
                                              imageUrl: categoryProperty[i]
                                                  .blogCoverImage,
                                              boxFit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: GestureDetector(
                                            onTap: () async {
                                              print(AllProperties
                                                  .favouritePropertiesID);
                                              print(
                                                  "Check property: ${AllProperties.checkFavouritesAvailability(categoryProperty[i].propertyid)}");

                                              if (AllProperties
                                                  .checkFavouritesAvailability(
                                                      categoryProperty[i]
                                                          .propertyid)) {
                                                print("Exist here");
                                                removeFavouriteApiCall(
                                                    userID: GlobalUserDetails
                                                        .userID,
                                                    propertyID:
                                                        categoryProperty[i]
                                                            .propertyid);
                                              } else {
                                                markAsFavouriteApiCall(
                                                  businessPropertyID:
                                                      categoryProperty[i]
                                                          .propertyid,
                                                  userID:
                                                      GlobalUserDetails.userID,
                                                );
                                              }
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: 10, top: 10),
                                              child: StatefulBuilder(
                                                builder: (context, setState) =>
                                                    Container(
                                                        height: 25,
                                                        width: 25,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6)),
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.star,
                                                            color: AllProperties
                                                                    .checkFavouritesAvailability(
                                                                        categoryProperty[i]
                                                                            .propertyid)
                                                                ? Colors.red
                                                                    .shade800
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
                                                gradient: LinearGradient(
                                                    colors: [
                                                  Color(0xff191921),
                                                  Color(0xff3A3A43)
                                                ])),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 160,
                                                    // color: Colors.red,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(height: 12),
                                                        Text(
                                                          widget.properties[i]
                                                                  .propertyName ??
                                                              "",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize:
                                                                  ResponsiveFlutter.of(
                                                                          context)
                                                                      .fontSize(
                                                                          1.9),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                        ),
                                                        // SizedBox(
                                                        //   height: 5,
                                                        // ),
                                                        Wrap(
                                                          crossAxisAlignment:
                                                              WrapCrossAlignment
                                                                  .start,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                GoogleMapLauncher
                                                                    .openMap(widget
                                                                        .properties[
                                                                            i]
                                                                        .googleMap);
                                                              },
                                                              child: Icon(
                                                                Icons.place,
                                                                color: Colors
                                                                    .white,
                                                                size: 15,
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            GestureDetector(
                                                              onTap: () {
                                                                GoogleMapLauncher
                                                                    .openMap(widget
                                                                        .properties[
                                                                            i]
                                                                        .googleMap);
                                                              },
                                                              child: Text(
                                                                widget.properties[i]
                                                                        .location
                                                                        .capitalize() ??
                                                                    "",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          " " +
                                                              widget
                                                                  .categoryName
                                                                  .capitalize(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 11),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  // SizedBox(
                                                  //   width: 5,
                                                  // ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final SharedPreferences
                                                          pref =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      SetClickCountApiCall(
                                                          1,
                                                          widget.properties[i]
                                                              .propertyid,
                                                          pref.getInt(
                                                              SPKeys.userID));
                                                      Navigator.push(
                                                          context,
                                                          FadeRoute(
                                                              page:
                                                                  FullWebViewPage(
                                                            fullViewURL: widget
                                                                    .properties[
                                                                        i]
                                                                    .link360 ??
                                                                "null",
                                                          )));
                                                    },
                                                    child: Center(
                                                      child: Image.asset(
                                                          'assets/images/360_view.png',
                                                          scale: 1),
                                                    ),
                                                  ),
                                                  // SizedBox(width: 5),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final SharedPreferences
                                                          pref =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      SetClickCountApiCall(
                                                          2,
                                                          widget.properties[i]
                                                              .propertyid,
                                                          pref.getInt(
                                                              SPKeys.userID));

                                                      if (widget.properties[i]
                                                              .blogAvailable ==
                                                          1) {
                                                        List<String> imageUrls =
                                                            widget.properties[i]
                                                                .blogMultipleImage
                                                                .split(',');
                                                        showImageCarouselDialog(
                                                            context, imageUrls);
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "No Images Available !",
                                                            backgroundColor:
                                                                Color(
                                                                    0xffBF3B38),
                                                            textColor:
                                                                Colors.white,
                                                            toastLength: Toast
                                                                .LENGTH_SHORT);
                                                      }
                                                    },
                                                    child: Center(
                                                      child: Image.asset(
                                                          'assets/images/gallery_icon.png',
                                                          scale: 2),
                                                    ),
                                                  ),
                                                  // SizedBox(width: 5),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final SharedPreferences
                                                          pref =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      SetClickCountApiCall(
                                                          3,
                                                          widget.properties[i]
                                                              .propertyid,
                                                          pref.getInt(
                                                              SPKeys.userID));
                                                      launchWhatsApp(
                                                          phone: widget
                                                                      .properties[
                                                                          i]
                                                                      .whatsappNumber !=
                                                                  null
                                                              ? "+91-${widget.properties[i].whatsappNumber}"
                                                              : "",
                                                          message: "");
                                                    },
                                                    child: Center(
                                                      child: Image.asset(
                                                          'assets/images/whatsapp_icon.png',
                                                          scale: 1),
                                                    ),
                                                  ),
                                                  // SizedBox(width: 5),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final SharedPreferences
                                                          pref =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      SetClickCountApiCall(
                                                          4,
                                                          widget.properties[i]
                                                              .propertyid,
                                                          pref.getInt(
                                                              SPKeys.userID));
                                                      if (widget.properties[i]
                                                              .callingNumber !=
                                                          null) {
                                                        launch(
                                                            "tel://${widget.properties[i].callingNumber}");
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "This property has no contact number!",
                                                            backgroundColor:
                                                                Color(
                                                                    0xffBF3B38),
                                                            textColor:
                                                                Colors.white,
                                                            toastLength: Toast
                                                                .LENGTH_SHORT);
                                                      }
                                                    },
                                                    child: Center(
                                                      child: Image.asset(
                                                          'assets/images/call_icon.png',
                                                          scale: 1),
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
                            )),
                ],
              ),
            ),
          ),
        ),
        loading ? CustomLoader() : Container()
      ],
    );
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
              child: CarouselSlider.builder(
                  key: _sliderKey,
                  scrollDirection: Axis.vertical,
                  unlimitedMode: false,
                  viewportFraction: 0.4,
                  slideBuilder: (index) {
                    return Container(
                      alignment: Alignment.center,
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
                  // slideIndicator: CircularSlideIndicator(
                  //     padding: EdgeInsets.only(bottom: 32),
                  //     currentIndicatorColor: Colors.blue,
                  //     indicatorRadius: 4,
                  //     indicatorBackgroundColor: Colors.white),
                  itemCount: imageList.length),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 300));
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
          msg: "Could not open Whatsapp",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      throw 'Could not launch ${url()}';
    }
  }

  //TODO: API CALL TO REMOVE THE USER FROM THE FAVOURITES
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
}
