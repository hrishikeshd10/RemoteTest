// To parse this JSON data, do
//
//     final categoriesResponse = categoriesResponseFromJson(jsonString);

import 'dart:convert';

CategoriesResponse categoriesResponseFromJson(String str) =>
    CategoriesResponse.fromJson(json.decode(str));

String categoriesResponseToJson(CategoriesResponse data) =>
    json.encode(data.toJson());

class CategoriesResponse {
  CategoriesResponse({
    this.n,
    this.msg,
    this.data,
  });

  int n;
  String msg;
  List<Datum> data;

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) =>
      CategoriesResponse(
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
    this.categoryName,
    this.categoryId,
    this.categoryImage,
  });

  String categoryName;
  String categoryId;
  String categoryImage;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        categoryName:
            json["category_name"] == null ? null : json["category_name"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
        categoryImage:
            json["category_image"] == null ? null : json["category_image"],
      );

  Map<String, dynamic> toJson() => {
        "category_name": categoryName == null ? null : categoryName,
        "category_id": categoryId == null ? null : categoryId,
        "category_image": categoryImage == null ? null : categoryImage,
      };
}
