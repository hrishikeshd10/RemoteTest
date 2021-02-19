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
import 'package:my_neighbourhood_online/api_response_model/get_favourite_response.dart';
import 'package:my_neighbourhood_online/api_response_model/get_properties_response.dart';
import 'package:my_neighbourhood_online/api_response_model/remove_favourite_response.dart';
import 'package:my_neighbourhood_online/route_transitions/dart/route_transitions.dart';
import 'package:my_neighbourhood_online/screens/360_view_screen.dart';
import 'package:my_neighbourhood_online/screens/app_drawer.dart';
import 'package:my_neighbourhood_online/screens/single_property_view.dart';
import 'package:my_neighbourhood_online/widget/base_canvas.dart';
import 'package:my_neighbourhood_online/widget/custom_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class FavouritesPage extends StatefulWidget {
  @override
  FavouritesPageState createState() => FavouritesPageState();
}

class FavouritesPageState extends State<FavouritesPage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool _menuShown = false;
  String _value;
  bool loading = false;

  static List<FavouritesData> favouritesData = [];
  var logger = Logger(printer: PrettyPrinter());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavouritesList(userID: GlobalUserDetails.userID);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          drawer: AppDrawer(),
          appBar: AppBar(
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
                "Favourite Properties",
                style: GoogleFonts.montserrat(color: Colors.white),
              ),
            ),
          ),
          body: BaseCanvas(
            child: SafeArea(
              child: favouritesData == null || favouritesData.isEmpty
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
                      itemCount: favouritesData.length,
                      itemBuilder: (context, i) => Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 275,
                                  child: GestureDetector(
                                    onTap: () {
                                      _navigateAndDisplayPropertyDetails(
                                          context, i);
                                    },
                                    child: FancyShimmerImage(
                                      imageUrl:
                                          favouritesData[i].blogCoverImage,
                                      boxFit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      removeFavouriteApiCall(
                                          propertyID:
                                              favouritesData[i].propertyid,
                                          userID: GlobalUserDetails.userID);
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(right: 10, top: 10),
                                      child: Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: Center(
                                            child: Icon(
                                              Icons.star,
                                              color: Colors.red.shade800,
                                            ),
                                          )),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 150,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 12),
                                                Text(
                                                  favouritesData[i]
                                                          .propertyName ??
                                                      "",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Wrap(
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        GoogleMapLauncher
                                                            .openMap(
                                                                favouritesData[
                                                                        i]
                                                                    .googleMap);
                                                      },
                                                      child: Icon(
                                                        Icons.place,
                                                        color: Colors.white,
                                                        size: 15,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    GestureDetector(
                                                      onTap: () {
                                                        GoogleMapLauncher
                                                            .openMap(
                                                                favouritesData[
                                                                        i]
                                                                    .googleMap);
                                                      },
                                                      child: Text(
                                                        favouritesData[i]
                                                                .location
                                                                .capitalize() ??
                                                            "",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
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
                                          SizedBox(
                                            width: 5,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              final SharedPreferences pref =
                                                  await SharedPreferences
                                                      .getInstance();
                                              SetClickCountApiCall(
                                                  1,
                                                  favouritesData[i].propertyid,
                                                  pref.getInt(SPKeys.userID));
                                              Navigator.push(
                                                  context,
                                                  FadeRoute(
                                                      page: FullWebViewPage(
                                                    fullViewURL:
                                                        favouritesData[i]
                                                                .link360 ??
                                                            "null",
                                                  )));
                                            },
                                            child: Image.asset(
                                              'assets/images/360_view.png',
                                              scale: 0.9,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          GestureDetector(
                                            onTap: () async {
                                              final SharedPreferences pref =
                                                  await SharedPreferences
                                                      .getInstance();
                                              SetClickCountApiCall(
                                                  2,
                                                  favouritesData[i].propertyid,
                                                  pref.getInt(SPKeys.userID));

                                              if (favouritesData[i]
                                                      .blogAvailable ==
                                                  1) {
                                                List<String> imageUrls =
                                                    favouritesData[i]
                                                        .blogMultipleImage
                                                        .split(',');
                                                showImageCarouselDialog(
                                                    context, imageUrls);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "No Images Available !",
                                                    backgroundColor:
                                                        Color(0xffBF3B38),
                                                    textColor: Colors.white,
                                                    toastLength:
                                                        Toast.LENGTH_SHORT);
                                              }
                                            },
                                            child: Image.asset(
                                                'assets/images/gallery_icon.png',
                                                scale: 1.8),
                                          ),
                                          SizedBox(width: 5),
                                          GestureDetector(
                                            onTap: () async {
                                              final SharedPreferences pref =
                                                  await SharedPreferences
                                                      .getInstance();
                                              SetClickCountApiCall(
                                                  3,
                                                  favouritesData[i].propertyid,
                                                  pref.getInt(SPKeys.userID));
                                              launchWhatsApp(
                                                  phone: favouritesData[i]
                                                              .whatsappNumber !=
                                                          null
                                                      ? "+91-${favouritesData[i].whatsappNumber}"
                                                      : "",
                                                  message: "");
                                            },
                                            child: Image.asset(
                                                'assets/images/whatsapp_icon.png',
                                                scale: 1),
                                          ),
                                          SizedBox(width: 5),
                                          GestureDetector(
                                            onTap: () async {
                                              final SharedPreferences pref =
                                                  await SharedPreferences
                                                      .getInstance();
                                              SetClickCountApiCall(
                                                  4,
                                                  favouritesData[i].propertyid,
                                                  pref.getInt(SPKeys.userID));
                                              if (favouritesData[i]
                                                      .callingNumber !=
                                                  null) {
                                                launch(
                                                    "tel://${favouritesData[i].callingNumber}");
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "This property has no contact number!",
                                                    backgroundColor:
                                                        Color(0xffBF3B38),
                                                    textColor: Colors.white,
                                                    toastLength:
                                                        Toast.LENGTH_SHORT);
                                              }
                                            },
                                            child: Image.asset(
                                                'assets/images/call_icon.png',
                                                scale: 1),
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
        barrierColor: Colors.transparent,
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
                      color: Colors.transparent,
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
          msg: "Could not send message to $phone",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      throw 'Could not launch ${url()}';
    }
  }

  void getFavouritesList({int userID}) async {
    Map<String, dynamic> body = {"UserID": userID};

    logger.d("Get Favourites body: $body");
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
        });

        if (getFavouritesResponse.n == 1) {
          setState(() {
            favouritesData = getFavouritesResponse.data;
            AllProperties.favouritePropertiesID.clear();
            getFavouritesResponse.data.forEach((element) {
              print("Fav: ${element.propertyid}");
            });
            getFavouritesResponse.data.forEach((element) {
              AllProperties.favouritePropertiesID.add(element.propertyid);
            });
          });
        } else {
          //TODO: If there are no favourites, then the n will be 0 and data would be null from the API

          setState(() {
            favouritesData = [];
            AllProperties.favouritePropertiesID.clear();
          });
          // Fluttertoast.showToast(
          //     msg:
          //         "Could not fetch your favourite properties ... Please try again!",
          //     backgroundColor: Color(0xffBF3B38),
          //     textColor: Colors.white,
          //     toastLength: Toast.LENGTH_LONG);
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

  //TODO: API CALL TO REMOVE THE USER FROM THE FAVOURITES
  //TODO: API CALL to remove a property from favourites
  void removeFavouriteApiCall({int propertyID, int userID}) async {
    Map<String, dynamic> body = {
      "userID": userID,
      "property_ID": propertyID,
    };

    logger.d("Remove fav API body: $body");
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

          getFavouritesList(userID: GlobalUserDetails.userID);
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

  _navigateAndDisplayPropertyDetails(BuildContext context, int i) async {
    List<FavouritesData> result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SinglePropertyView(
                  passDataBackFromFav: true,
                  property: Data(
                      location: favouritesData[i].location,
                      blogAvailable: favouritesData[i].blogAvailable,
                      blogCoverImage: favouritesData[i].blogCoverImage,
                      blogMultipleImage: favouritesData[i].blogMultipleImage,
                      callingNumber: favouritesData[i].callingNumber,
                      googleMap: favouritesData[i].googleMap,
                      link360: favouritesData[i].link360,
                      propertyDescription:
                          favouritesData[i].propertyDescription,
                      whatsappNumber: favouritesData[i].whatsappNumber,
                      propertyid: favouritesData[i].propertyid,
                      propertyName: favouritesData[i].propertyName,
                      latitude: favouritesData[i].latitude,
                      longitude: favouritesData[i].longitude,
                      categoryName: favouritesData[i].categoryName,
                      fullAddress: favouritesData[i].propertyFulladdress,
                      propertyWebsite: favouritesData[i].propertyWebsite),
                )));

    getFavouritesList(userID: GlobalUserDetails.userID);
  }
}
