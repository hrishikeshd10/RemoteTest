// To parse this JSON data, do
//
//     final getFavouritesResponse = getFavouritesResponseFromJson(jsonString);

import 'dart:convert';

GetFavouritesResponse getFavouritesResponseFromJson(String str) =>
    GetFavouritesResponse.fromJson(json.decode(str));

String getFavouritesResponseToJson(GetFavouritesResponse data) =>
    json.encode(data.toJson());

class GetFavouritesResponse {
  GetFavouritesResponse({
    this.n,
    this.msg,
    this.data,
  });

  int n;
  String msg;
  List<FavouritesData> data;

  factory GetFavouritesResponse.fromJson(Map<String, dynamic> json) =>
      GetFavouritesResponse(
        n: json["n"] == null ? null : json["n"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null
            ? null
            : List<FavouritesData>.from(
                json["data"].map((x) => FavouritesData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "n": n == null ? null : n,
        "msg": msg == null ? null : msg,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class FavouritesData {
  FavouritesData({
    this.link360,
    this.blogCoverImage,
    this.blogAvailable,
    this.blogMultipleImage,
    this.propertyName,
    this.propertyDescription,
    this.propertyWebsite,
    this.categoryName,
    this.googleMap,
    this.location,
    this.propertyFulladdress,
    this.latitude,
    this.longitude,
    this.whatsappNumber,
    this.callingNumber,
    this.propertyid,
  });

  String link360;
  String blogCoverImage;
  int blogAvailable;
  String blogMultipleImage;
  String propertyName;
  dynamic propertyDescription;
  dynamic propertyWebsite;
  String categoryName;
  String googleMap;
  String location;
  dynamic propertyFulladdress;
  double latitude;
  double longitude;
  dynamic whatsappNumber;
  int callingNumber;
  int propertyid;

  factory FavouritesData.fromJson(Map<String, dynamic> json) => FavouritesData(
        link360: json["link360"] == null ? null : json["link360"],
        blogCoverImage:
            json["blog_cover_image"] == null ? null : json["blog_cover_image"],
        blogAvailable:
            json["blog_available"] == null ? null : json["blog_available"],
        blogMultipleImage: json["blog_multiple_image"] == null
            ? null
            : json["blog_multiple_image"],
        propertyName:
            json["property_name"] == null ? null : json["property_name"],
        propertyDescription: json["property_description"],
        propertyWebsite: json["property_website"],
        categoryName:
            json["category_name"] == null ? null : json["category_name"],
        googleMap: json["google_map"] == null ? null : json["google_map"],
        location: json["location"] == null ? null : json["location"],
        propertyFulladdress: json["property_fulladdress"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude:
            json["longitude"] == null ? null : json["longitude"].toDouble(),
        whatsappNumber: json["whatsapp_number"],
        callingNumber:
            json["calling_number"] == null ? null : json["calling_number"],
        propertyid: json["propertyid"] == null ? null : json["propertyid"],
      );

  Map<String, dynamic> toJson() => {
        "link360": link360 == null ? null : link360,
        "blog_cover_image": blogCoverImage == null ? null : blogCoverImage,
        "blog_available": blogAvailable == null ? null : blogAvailable,
        "blog_multiple_image":
            blogMultipleImage == null ? null : blogMultipleImage,
        "property_name": propertyName == null ? null : propertyName,
        "property_description": propertyDescription,
        "property_website": propertyWebsite,
        "category_name": categoryName == null ? null : categoryName,
        "google_map": googleMap == null ? null : googleMap,
        "location": location == null ? null : location,
        "property_fulladdress": propertyFulladdress,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "whatsapp_number": whatsappNumber,
        "calling_number": callingNumber == null ? null : callingNumber,
        "propertyid": propertyid == null ? null : propertyid,
      };
}
