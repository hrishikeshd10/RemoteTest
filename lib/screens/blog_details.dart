import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_neighbourhood_online/Networking/set_count_api_call.dart';
import 'package:my_neighbourhood_online/Utilities/key_constants.dart';
import 'package:my_neighbourhood_online/api_response_model/blog_response.dart';
import 'package:my_neighbourhood_online/route_transitions/dart/route_transitions.dart';
import 'package:my_neighbourhood_online/screens/360_view_screen.dart';
import 'package:my_neighbourhood_online/widget/base_canvas.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlogDetailsScreen extends StatefulWidget {
  final Result blogDetails;

  const BlogDetailsScreen({Key key, this.blogDetails}) : super(key: key);
  @override
  _BlogDetailsScreenState createState() => _BlogDetailsScreenState();
}

class _BlogDetailsScreenState extends State<BlogDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseCanvas(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                        width: 40,
                        height: 40,
                        child: Image.asset(
                          'assets/images/back_arrow.png',
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 270,
                                  child: Text(
                                    widget.blogDetails.propertyName,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(2.5)),
                                  ),
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
                                      widget.blogDetails.locationName
                                          .capitalize(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(1.6)),
                                    ),
                                    Text(
                                        " . ${widget.blogDetails.categoryName.capitalize()}",
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
                            Container(
                              width: 5,
                            ),
                            Expanded(
                              child: GestureDetector(
                                  onTap: () async {
                                    print("See 360");
                                    final SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    SetClickCountApiCall(
                                        1,
                                        widget.blogDetails.propertyid,
                                        pref.getInt(SPKeys.userID));
                                    Navigator.push(
                                        context,
                                        FadeRoute(
                                            page: FullWebViewPage(
                                                fullViewURL: widget
                                                        .blogDetails.link360 ??
                                                    "null"
                                                // "null",
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
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  SetClickCountApiCall(
                                      2,
                                      widget.blogDetails.propertyid,
                                      pref.getInt(SPKeys.userID));
                                  if (widget.blogDetails.blogMultipleImage !=
                                          null ||
                                      widget.blogDetails.blogMultipleImage
                                          .isNotEmpty) {
                                    List<String> imageUrls = widget
                                        .blogDetails.blogMultipleImage
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
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: widget.blogDetails.propDescription == null,
                          replacement: Container(),
                          child: Text(
                            widget.blogDetails.propDescription ?? "",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ResponsiveFlutter.of(context)
                                    .fontSize(1.5)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, i) => SizedBox(
                            height: 10,
                          ),
                      separatorBuilder: (context, i) => Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              height: 200,
                              width: 290,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: FancyShimmerImage(
                                  imageUrl: widget.blogDetails.blogMultipleImage
                                      .split(',')[i],
                                  boxFit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                      itemCount: widget.blogDetails.blogMultipleImage
                              .split(',')
                              .length +
                          1),
                )
              ],
            ),
            Container(
              height: 80,
              width: double.infinity,
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70.0),
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
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(2),
                                fontWeight: FontWeight.w400),
                          )),
                      onPressed: () async {
                        final SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        SetClickCountApiCall(1, widget.blogDetails.propertyid,
                            pref.getInt(SPKeys.userID));
                        Navigator.push(
                            context,
                            FadeRoute(
                                page: FullWebViewPage(
                                    fullViewURL:
                                        widget.blogDetails.link360 ?? "null"
                                    // "null",
                                    )));
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //TODO: IMAGE SLIDER CAROUSEL DIALOG
  void showImageCarouselDialog(BuildContext context, List<String> imageList) {
    double rating = 0.5;
    TextEditingController feedbackController = TextEditingController();
    bool loading = false;
    GlobalKey _sliderKey = GlobalKey();
    showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {},
        barrierDismissible: true,
        // barrierColor: Colors.black.withOpacity(0.4),
        barrierLabel: '',
        transitionBuilder: (context, anim1, anim2, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                child: CarouselSlider.builder(
                    key: _sliderKey,
                    scrollDirection: Axis.vertical,
                    unlimitedMode: false,
                    viewportFraction: 0.4,
                    slideBuilder: (index) {
                      return Container(
                        height: 200,
                        width: 290,
                        // color: Colors.black.withOpacity(0.7),
                        alignment: Alignment.topCenter,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: imageList[index],
                            fit: BoxFit.cover,
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
}
