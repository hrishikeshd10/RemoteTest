// To parse this JSON data, do
//
//     final removeFavouriteResponse = removeFavouriteResponseFromJson(jsonString);

import 'dart:convert';

RemoveFavouriteResponse removeFavouriteResponseFromJson(String str) =>
    RemoveFavouriteResponse.fromJson(json.decode(str));

String removeFavouriteResponseToJson(RemoveFavouriteResponse data) =>
    json.encode(data.toJson());

class RemoveFavouriteResponse {
  RemoveFavouriteResponse({
    this.n,
    this.msg,
    this.data,
  });

  int n;
  String msg;
  String data;

  factory RemoveFavouriteResponse.fromJson(Map<String, dynamic> json) =>
      RemoveFavouriteResponse(
        n: json["n"] == null ? null : json["n"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : json["data"],
      );

  Map<String, dynamic> toJson() => {
        "n": n == null ? null : n,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : data,
      };
}
