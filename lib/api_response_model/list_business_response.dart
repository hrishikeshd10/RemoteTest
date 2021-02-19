// To parse this JSON data, do
//
//     final listBusinessResponse = listBusinessResponseFromJson(jsonString);

import 'dart:convert';

ListBusinessResponse listBusinessResponseFromJson(String str) =>
    ListBusinessResponse.fromJson(json.decode(str));

String listBusinessResponseToJson(ListBusinessResponse data) =>
    json.encode(data.toJson());

class ListBusinessResponse {
  ListBusinessResponse({
    this.n,
    this.msg,
    this.data,
  });

  int n;
  String msg;
  String data;

  factory ListBusinessResponse.fromJson(Map<String, dynamic> json) =>
      ListBusinessResponse(
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
