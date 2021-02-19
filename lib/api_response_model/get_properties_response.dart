// To parse this JSON data, do
//
//     final getPropertiesResponse = getPropertiesResponseFromJson(jsonString);

import 'dart:convert';

GetPropertiesResponse getPropertiesResponseFromJson(String str) =>
    GetPropertiesResponse.fromJson(json.decode(str));

String getPropertiesResponseToJson(GetPropertiesResponse data) =>
    json.encode(data.toJson());

class GetPropertiesResponse {
  GetPropertiesResponse({
    this.n,
    this.msg,
    this.data,
  });

  int n;
  String msg;
  List<Data> data;

  factory GetPropertiesResponse.fromJson(Map<String, dynamic> json) =>
      GetPropertiesResponse(
        n: json["n"] == null ? null : json["n"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null
            ? null
            : List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "n": n == null ? null : n,
        "msg": msg == null ? null : msg,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Data {
  Data({
    this.link360,
    this.blogCoverImage,
    this.blogAvailable,
    this.propertyName,
    this.propertyDescription,
    this.googleMap,
    this.location,
    this.categoryName,
    this.fullAddress,
    this.propertyWebsite,
    this.latitude,
    this.longitude,
    this.whatsappNumber,
    this.callingNumber,
    this.propertyid,
    this.catid,
    this.blogMultipleImage,
  });

  String link360;
  String blogCoverImage;
  int blogAvailable;
  String propertyName;
  String propertyDescription;
  String googleMap;
  String location;
  String categoryName;
  String fullAddress;
  String propertyWebsite;
  double latitude;
  double longitude;
  int whatsappNumber;
  int callingNumber;
  int propertyid;
  dynamic catid;
  String blogMultipleImage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        googleMap: json["google_map"] == null ? null : json["google_map"],
        location: json["location"] == null ? null : json["location"],
        categoryName:
            json["category_name"] == null ? null : json["category_name"],
        fullAddress: json["full_address"] == null ? null : json["full_address"],
        propertyWebsite:
            json["property_website"] == null ? null : json["property_website"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude:
            json["longitude"] == null ? null : json["longitude"].toDouble(),
        whatsappNumber:
            json["whatsapp_number"] == null ? null : json["whatsapp_number"],
        callingNumber:
            json["calling_number"] == null ? null : json["calling_number"],
        propertyid: json["propertyid"] == null ? null : json["propertyid"],
        catid: json["catid"],
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
        "google_map": googleMap == null ? null : googleMap,
        "location": location == null ? null : location,
        "category_name": categoryName == null ? null : categoryName,
        "full_address": fullAddress == null ? null : fullAddress,
        "property_website": propertyWebsite == null ? null : propertyWebsite,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "whatsapp_number": whatsappNumber == null ? null : whatsappNumber,
        "calling_number": callingNumber == null ? null : callingNumber,
        "propertyid": propertyid == null ? null : propertyid,
        "catid": catid,
        "blog_multiple_image":
            blogMultipleImage == null ? null : blogMultipleImage,
      };
}
