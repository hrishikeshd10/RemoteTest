// To parse this JSON data, do
//
//     final getBlog = getBlogFromJson(jsonString);

import 'dart:convert';

GetBlog getBlogFromJson(String str) => GetBlog.fromJson(json.decode(str));

String getBlogToJson(GetBlog data) => json.encode(data.toJson());

class GetBlog {
  GetBlog({
    this.n,
    this.msg,
    this.data,
  });

  int n;
  String msg;
  Data data;

  factory GetBlog.fromJson(Map<String, dynamic> json) => GetBlog(
        n: json["n"] == null ? null : json["n"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "n": n == null ? null : n,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : data.toJson(),
      };
}

class Data {
  Data({
    this.result,
    this.n,
  });

  List<Result> result;
  int n;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"] == null
            ? null
            : List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        n: json["n"] == null ? null : json["n"],
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? null
            : List<dynamic>.from(result.map((x) => x.toJson())),
        "n": n == null ? null : n,
      };
}

class Result {
  Result({
    this.blogimage,
    this.blogid,
    this.blogname,
    this.propertyid,
    this.propertyName,
    this.propDescription,
    this.propFullAddress,
    this.latitude,
    this.longitude,
    this.link360,
    this.whatsappNo,
    this.callingNo,
    this.locationName,
    this.categoryName,
    this.blogMultipleImage,
    this.categorynames,
    this.watsappno,
    this.callingno,
  });

  String blogimage;
  int blogid;
  String blogname;
  int propertyid;
  String propertyName;
  String propDescription;
  dynamic propFullAddress;
  double latitude;
  double longitude;
  String link360;
  int whatsappNo;
  int callingNo;
  String locationName;
  String categoryName;
  String blogMultipleImage;
  String categorynames;
  dynamic watsappno;
  dynamic callingno;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        blogimage: json["blogimage"] == null ? null : json["blogimage"],
        blogid: json["blogid"] == null ? null : json["blogid"],
        blogname: json["blogname"] == null ? null : json["blogname"],
        propertyid: json["propertyid"] == null ? null : json["propertyid"],
        propertyName:
            json["property_name"] == null ? null : json["property_name"],
        propDescription:
            json["prop_description"] == null ? null : json["prop_description"],
        propFullAddress: json["prop_full_address"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude:
            json["longitude"] == null ? null : json["longitude"].toDouble(),
        link360: json["link360"] == null ? null : json["link360"],
        whatsappNo: json["whatsapp_no"] == null ? null : json["whatsapp_no"],
        callingNo: json["calling_no"] == null ? null : json["calling_no"],
        locationName:
            json["location_name"] == null ? null : json["location_name"],
        categoryName:
            json["category_name"] == null ? null : json["category_name"],
        blogMultipleImage: json["blog_multiple_image"] == null
            ? null
            : json["blog_multiple_image"],
        categorynames:
            json["categorynames"] == null ? null : json["categorynames"],
        watsappno: json["watsappno"],
        callingno: json["callingno"],
      );

  Map<String, dynamic> toJson() => {
        "blogimage": blogimage == null ? null : blogimage,
        "blogid": blogid == null ? null : blogid,
        "blogname": blogname == null ? null : blogname,
        "propertyid": propertyid == null ? null : propertyid,
        "property_name": propertyName == null ? null : propertyName,
        "prop_description": propDescription == null ? null : propDescription,
        "prop_full_address": propFullAddress,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "link360": link360 == null ? null : link360,
        "whatsapp_no": whatsappNo == null ? null : whatsappNo,
        "calling_no": callingNo == null ? null : callingNo,
        "location_name": locationName == null ? null : locationName,
        "category_name": categoryName == null ? null : categoryName,
        "blog_multiple_image":
            blogMultipleImage == null ? null : blogMultipleImage,
        "categorynames": categorynames == null ? null : categorynames,
        "watsappno": watsappno,
        "callingno": callingno,
      };
}
