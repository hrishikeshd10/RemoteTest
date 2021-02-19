// To parse this JSON data, do
//
//     final addFavouriteResponse = addFavouriteResponseFromJson(jsonString);

import 'dart:convert';

AddFavouriteResponse addFavouriteResponseFromJson(String str) =>
    AddFavouriteResponse.fromJson(json.decode(str));

String addFavouriteResponseToJson(AddFavouriteResponse data) =>
    json.encode(data.toJson());

class AddFavouriteResponse {
  AddFavouriteResponse({
    this.n,
    this.msg,
    this.data,
  });

  int n;
  String msg;
  List<dynamic> data;

  factory AddFavouriteResponse.fromJson(Map<String, dynamic> json) =>
      AddFavouriteResponse(
        n: json["n"] == null ? null : json["n"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null
            ? null
            : List<dynamic>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "n": n == null ? null : n,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x)),
      };
}
