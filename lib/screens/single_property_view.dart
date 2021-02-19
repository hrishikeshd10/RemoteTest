import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:my_neighbourhood_online/Networking/all_urls.dart';
import 'package:my_neighbourhood_online/Networking/set_count_api_call.dart';
import 'package:my_neighbourhood_online/Utilities/googleMapLauncher.dart';
import 'package:my_neighbourhood_online/Utilities/key_constants.dart';
import 'package:my_neighbourhood_online/api_response_model/add_favourite_response.dart';
import 'package:my_neighbourhood_online/api_response_model/get_favourite_response.dart';
import 'package:my_neighbourhood_online/api_response_model/get_properties_response.dart';
import 'package:my_neighbourhood_online/api_response_model/remove_favourite_response.dart';
import 'package:my_neighbourhood_online/route_transitions/dart/route_transitions.dart';
import 'package:my_neighbourhood_online/screens/360_view_screen.dart';
import 'package:my_neighbourhood_online/screens/favourites_page.dart';
import 'package:my_neighbourhood_online/widget/base_canvas.dart';
import 'package:my_neighbourhood_online/widget/custom_loader.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SinglePropertyView extends StatefulWidget {
  final Data property;
  final bool passDataBackFromFav;

  const SinglePropertyView(
      {Key key, this.property, this.passDataBackFromFav: false})
      : super(key: key);
  @override
  _SinglePropertyViewState createState() => _SinglePropertyViewState();
}

class _SinglePropertyViewState extends State<SinglePropertyView> {
  bool isPropertyFavourite = false;
  bool loading = false;
  var logger = Logger(printer: PrettyPrinter(methodCount: 0));

  //TODO :VARIABLE FOR GOOGLE MAP GO HERE
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("this si PropertyID: ${widget.property.propertyid}");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          // appBar: AppBar(
          //   centerTitle: true,
          //   backgroundColor: Colors.transparent,
          //   elevation: 10,
          //   leading: GestureDetector(
          //     onTap: () {
          //       widget.passDataBackFromFav
          //           ? Navigator.pop(context, FavouritesPageState.favouritesData)
          //           : Navigator.pop(context);
          //     },
          //     child: Image.asset('assets/images/back_arrow.png'),
          //   ),
          //   title: Padding(
          //     padding: const EdgeInsets.only(bottom: 8.0),
          //     child: Text(
          //       widget.property.propertyName.capitalize(),
          //       style:
          //           TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // ),
          body: BaseCanvas(
            child: CustomScrollView(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              slivers: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     GestureDetector(
                //       onTap: () {
                //         widget.passDataBackFromFav
                //             ? Navigator.pop(
                //                 context, FavouritesPageState.favouritesData)
                //             : Navigator.pop(context);
                //       },
                //       child: Image.asset(
                //         'assets/images/back_arrow.png',
                //         scale: 3.4,
                //       ),
                //     ),
                //     SizedBox(
                //       width: MediaQuery.of(context).size.width * 0.05,
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(bottom: 10.0),
                //       child: Text(
                //         widget.property.propertyName.capitalize(),
                //         style: TextStyle(
                //             color: Colors.white,
                //             fontSize: ResponsiveFlutter.of(context).fontSize(3),
                //             fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //     Expanded(
                //       child: Container(),
                //     ),
                //   ],
                // ),
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  title: Text(
                    widget.property.propertyName,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveFlutter.of(context).fontSize(2.5),
                    ),
                  ),
                  leading: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset('assets/images/back_arrow.png')),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                SliverToBoxAdapter(
                  child: Container(
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 250,
                          child: FancyShimmerImage(
                            imageUrl: widget.property.blogCoverImage,
                            boxFit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              if (AllProperties.checkFavouritesAvailability(
                                  widget.property.propertyid)) {
                                removeFavouriteApiCall(
                                    userID: GlobalUserDetails.userID,
                                    propertyID: widget.property.propertyid);
                              } else {
                                markAsFavouriteApiCall(
                                  businessPropertyID:
                                      widget.property.propertyid,
                                  userID: GlobalUserDetails.userID,
                                );
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 10, top: 10),
                              child: Container(
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
                                                  widget.property.propertyid)
                                          ? Colors.red.shade800
                                          : Colors.grey,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.property.propertyName,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: ResponsiveFlutter.of(context)
                                          .fontSize(3)),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/location_icon.png',
                                      scale: 2,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.property.location.capitalize(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(1.6)),
                                    ),
                                    Text(" . Restaurant  ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                ResponsiveFlutter.of(context)
                                                    .fontSize(1.6))),
                                    // Text(" . Restaurant . ",style: TextStyle(
                                    //     color: Colors.white,
                                    //     fontSize:
                                    //     ResponsiveFlutter.of(context)
                                    //         .fontSize(1.6))),    // Text(" . Restaurant . ",style: TextStyle(
                                    //     color: Colors.white,
                                    //     fontSize:
                                    //     ResponsiveFlutter.of(context)
                                    //         .fontSize(1.6))),
                                  ],
                                )
                              ],
                            ),
                            Expanded(child: Container()),
                            GestureDetector(
                                onTap: () async {
                                  final SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  SetClickCountApiCall(
                                      1,
                                      widget.property.propertyid,
                                      pref.getInt(SPKeys.userID));
                                  Navigator.push(
                                      context,
                                      FadeRoute(
                                          page: FullWebViewPage(
                                        fullViewURL:
                                            widget.property.link360 ?? "null",
                                      )));
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/360ViewIcon.png',
                                        scale: 3,
                                      )
                                    ],
                                  ),
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                final SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                SetClickCountApiCall(
                                    2,
                                    widget.property.propertyid,
                                    pref.getInt(SPKeys.userID));
                                if (widget.property.blogMultipleImage != null ||
                                    widget.property.blogMultipleImage
                                        .isNotEmpty) {
                                  List<String> imageUrls = widget
                                      .property.blogMultipleImage
                                      .split(',');
                                  showImageCarouselDialog(context, imageUrls);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "No Images Available !",
                                      backgroundColor: Color(0xffBF3B38),
                                      textColor: Colors.white,
                                      toastLength: Toast.LENGTH_SHORT);
                                }
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/gallery_icon_white.png',
                                      scale: 3,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.property.propertyDescription ??
                              " Description Not Available",
                          style: TextStyle(
                              fontSize: widget.property.propertyDescription !=
                                      null
                                  ? ResponsiveFlutter.of(context).fontSize(2)
                                  : ResponsiveFlutter.of(context).fontSize(1.5),
                              color: widget.property.propertyDescription != null
                                  ? Colors.white
                                  : Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/call_icon.png',
                          scale: 1.2,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            SetClickCountApiCall(4, widget.property.propertyid,
                                pref.getInt(SPKeys.userID));
                            if (widget.property.callingNumber != null) {
                              launch("tel://${widget.property.callingNumber}");
                            } else {
                              Fluttertoast.showToast(
                                  msg: "This property has no contact number!",
                                  backgroundColor: Color(0xffBF3B38),
                                  textColor: Colors.white,
                                  toastLength: Toast.LENGTH_SHORT);
                            }
                          },
                          child: Text(
                              widget.property.callingNumber == null
                                  ? "Not Available"
                                  : widget.property.callingNumber.toString(),
                              style: widget.property.callingNumber == null
                                  ? TextStyle(fontSize: 16, color: Colors.grey)
                                  : TextStyle(
                                      fontSize: 16, color: Colors.blue)),
                        )
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                // SliverToBoxAdapter(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //     child: Row(
                //       children: [
                //         Image.asset(
                //           'assets/images/website_logo.png',
                //           scale: 3,
                //         ),
                //         SizedBox(
                //           width: 15,
                //         ),
                //         GestureDetector(
                //           onTap: () async {
                //             // final SharedPreferences pref =
                //             //     await SharedPreferences.getInstance();
                //             // SetClickCountApiCall(
                //             //     3,
                //             //     int.parse(widget.property.propertyid),
                //             //     pref.getInt(SPKeys.userID));
                //             // if (widget.property.whatsappNumber != null) {
                //             //   launchWhatsApp(
                //             //       phone: widget.property.whatsappNumber != null
                //             //           ? "+91-${widget.property.whatsappNumber}"
                //             //           : "",
                //             //       message: "");
                //             // }
                //           },
                //           child: Text(
                //               widget.property.propertyWebsite ??
                //                   "No Website Url",
                //               style: widget.property.propertyWebsite == null
                //                   ? TextStyle(fontSize: 16, color: Colors.grey)
                //                   : TextStyle(
                //                       fontSize: 16, color: Colors.blue)),
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                // SliverToBoxAdapter(
                //   child: SizedBox(
                //     height: 15,
                //   ),
                // ),
                // SliverToBoxAdapter(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //     child: Row(
                //       children: [
                //         Image.asset(
                //           'assets/images/location_icon.png',
                //         ),
                //         SizedBox(
                //           width: 15,
                //         ),
                //         GestureDetector(
                //           onTap: () {
                //             GoogleMapLauncher.openMap(
                //                 widget.property.googleMap);
                //           },
                //           child: Text(
                //               widget.property.fullAddress ??
                //                   " No Address Available",
                //               style: widget.property.fullAddress == null ||
                //                       widget.property.fullAddress.isEmpty
                //                   ? TextStyle(fontSize: 16, color: Colors.grey)
                //                   : TextStyle(
                //                       fontSize: 16, color: Colors.blue)),
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 250,
                      width: 290,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: GoogleMap(
                          markers: <Marker>{
                            Marker(
                              markerId: MarkerId(widget.property.toString()),
                              position: LatLng(widget.property.latitude,
                                  widget.property.longitude),
                              infoWindow: InfoWindow(
                                  title: widget.property.propertyName,
                                  onTap: () {
                                    GoogleMapLauncher.openMap(
                                        widget.property.googleMap);
                                  }),
                            )
                          },
                          onTap: (latlng) {
                            render360View();
                          },
                          myLocationEnabled: true,
                          cameraTargetBounds: CameraTargetBounds.unbounded,
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(widget.property.latitude,
                                widget.property.longitude),
                            zoom: 18,
                          ),
                          liteModeEnabled: false,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80.0, vertical: 10),
                    child: Container(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Color(0xff3B3D4B),
                        shape: StadiumBorder(),
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            child: Text(
                              "VIRTUAL TOUR",
                              style: TextStyle(color: Colors.white),
                            )),
                        onPressed: () async {
                          final SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          SetClickCountApiCall(1, widget.property.propertyid,
                              pref.getInt(SPKeys.userID));
                          Navigator.push(
                              context,
                              FadeRoute(
                                  page: FullWebViewPage(
                                fullViewURL: widget.property.link360 ?? "null",
                              )));
                        },
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
        loading ? CustomLoader() : Container()
      ],
    );
  }

  void render360View() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    SetClickCountApiCall(
        1, widget.property.propertyid, pref.getInt(SPKeys.userID));
    Navigator.push(
        context,
        FadeRoute(
            page: FullWebViewPage(
          fullViewURL: widget.property.link360 ?? "null",
        )));
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
            AllProperties.favouritePropertiesID.clear();
            FavouritesPageState.favouritesData = getFavouritesResponse.data;
            getFavouritesResponse.data.forEach((element) {
              AllProperties.favouritePropertiesID.add(element.propertyid);
            });
          });

          print(
              "Favourites after updating: ${AllProperties.favouritePropertiesID}");
        } else {
          //TODO: If there are no favourites, then the n will be 0 and data would be null from the API

          setState(() {
            FavouritesPageState.favouritesData.clear();
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

//TODO Dialog to show image carousel

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
                      height: 200,
                      width: 290,
                      alignment: Alignment.topCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: imageList[index],
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
}
