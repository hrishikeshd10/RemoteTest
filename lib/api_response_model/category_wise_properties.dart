// To parse this JSON data, do
//
//     final getCategoryWiseResponse = getCategoryWiseResponseFromJson(jsonString);

import 'dart:convert';

GetCategoryWiseResponse getCategoryWiseResponseFromJson(String str) =>
    GetCategoryWiseResponse.fromJson(json.decode(str));

String getCategoryWiseResponseToJson(GetCategoryWiseResponse data) =>
    json.encode(data.toJson());

class GetCategoryWiseResponse {
  GetCategoryWiseResponse({
    this.n,
    this.msg,
    this.data,
  });

  int n;
  String msg;
  List<Datum> data;

  factory GetCategoryWiseResponse.fromJson(Map<String, dynamic> json) =>
      GetCategoryWiseResponse(
        n: json["n"] == null ? null : json["n"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "n": n == null ? null : n,
        "msg": msg == null ? null : msg,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.link360,
    this.blogCoverImage,
    this.blogAvailable,
    this.propertyName,
    this.propertyDescription,
    this.categoryName,
    this.fullAddress,
    this.propertyWebsite,
    this.latitude,
    this.longitude,
    this.googleMap,
    this.location,
    this.whatsappNumber,
    this.callingNumber,
    this.propertyid,
    this.categoryid,
    this.categoryname,
    this.blogMultipleImage,
  });

  String link360;
  String blogCoverImage;
  int blogAvailable;
  String propertyName;
  String propertyDescription;
  String categoryName;
  dynamic fullAddress;
  dynamic propertyWebsite;
  double latitude;
  double longitude;
  String googleMap;
  String location;
  int whatsappNumber;
  int callingNumber;
  int propertyid;
  int categoryid;
  String categoryname;
  String blogMultipleImage;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        link360: json["link360"] == null ? null : json["link360"],
        blogCoverImage:
            json["blog_cover_image"] == null ? null : json["blog_cover_image"],
        blogAvailable:
            json["blog_available"] == null ? null : json["blog_available"],
        propertyName:
            json["property_name"] == null ? null : json["property_name"],
        propertyDescription: json["property_description"] == null
            ? null
            : json["property_description"],
        categoryName:
            json["category_name"] == null ? null : json["category_name"],
        fullAddress: json["full_address"],
        propertyWebsite: json["property_website"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude:
            json["longitude"] == null ? null : json["longitude"].toDouble(),
        googleMap: json["google_map"] == null ? null : json["google_map"],
        location: json["location"] == null ? null : json["location"],
        whatsappNumber:
            json["whatsapp_number"] == null ? null : json["whatsapp_number"],
        callingNumber:
            json["calling_number"] == null ? null : json["calling_number"],
        propertyid: json["propertyid"] == null ? null : json["propertyid"],
        categoryid: json["categoryid"] == null ? null : json["categoryid"],
        categoryname:
            json["categoryname"] == null ? null : json["categoryname"],
        blogMultipleImage: json["blog_multiple_image"] == null
            ? null
            : json["blog_multiple_image"],
      );

  Map<String, dynamic> toJson() => {
        "link360": link360 == null ? null : link360,
        "blog_cover_image": blogCoverImage == null ? null : blogCoverImage,
        "blog_available": blogAvailable == null ? null : blogAvailable,
        "property_name": propertyName == null ? null : propertyName,
        "property_description":
            propertyDescription == null ? null : propertyDescription,
        "category_name": categoryName == null ? null : categoryName,
        "full_address": fullAddress,
        "property_website": propertyWebsite,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "google_map": googleMap == null ? null : googleMap,
        "location": location == null ? null : location,
        "whatsapp_number": whatsappNumber == null ? null : whatsappNumber,
        "calling_number": callingNumber == null ? null : callingNumber,
        "propertyid": propertyid == null ? null : propertyid,
        "categoryid": categoryid == null ? null : categoryid,
        "categoryname": categoryname == null ? null : categoryname,
        "blog_multiple_image":
            blogMultipleImage == null ? null : blogMultipleImage,
      };
}
