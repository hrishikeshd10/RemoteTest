// To parse this JSON data, do
//
//     final registrationResponse = registrationResponseFromJson(jsonString);

import 'dart:convert';

RegistrationResponse registrationResponseFromJson(String str) =>
    RegistrationResponse.fromJson(json.decode(str));

String registrationResponseToJson(RegistrationResponse data) =>
    json.encode(data.toJson());

class RegistrationResponse {
  RegistrationResponse({
    this.n,
    this.msg,
    this.otp,
  });

  int n;
  String msg;
  int otp;

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) =>
      RegistrationResponse(
        n: json["n"],
        msg: json["msg"],
        otp: json["otp"],
      );

  Map<String, dynamic> toJson() => {
        "n": n,
        "msg": msg,
        "otp": otp,
      };
}
