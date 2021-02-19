// To parse this JSON data, do
//
//     final setPasswordResponse = setPasswordResponseFromJson(jsonString);

import 'dart:convert';

SetPasswordResponse setPasswordResponseFromJson(String str) =>
    SetPasswordResponse.fromJson(json.decode(str));

String setPasswordResponseToJson(SetPasswordResponse data) =>
    json.encode(data.toJson());

class SetPasswordResponse {
  SetPasswordResponse({
    this.n,
    this.msg,
  });

  int n;
  String msg;

  factory SetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      SetPasswordResponse(
        n: json["n"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "n": n,
        "msg": msg,
      };
}
