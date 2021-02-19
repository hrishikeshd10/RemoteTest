// To parse this JSON data, do
//
//     final updateUserProfileResponse = updateUserProfileResponseFromJson(jsonString);

import 'dart:convert';

UpdateUserProfileResponse updateUserProfileResponseFromJson(String str) =>
    UpdateUserProfileResponse.fromJson(json.decode(str));

String updateUserProfileResponseToJson(UpdateUserProfileResponse data) =>
    json.encode(data.toJson());

class UpdateUserProfileResponse {
  UpdateUserProfileResponse({
    this.n,
    this.msg,
  });

  int n;
  String msg;

  factory UpdateUserProfileResponse.fromJson(Map<String, dynamic> json) =>
      UpdateUserProfileResponse(
        n: json["n"] == null ? null : json["n"],
        msg: json["msg"] == null ? null : json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "n": n == null ? null : n,
        "msg": msg == null ? null : msg,
      };
}
