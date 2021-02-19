// To parse this JSON data, do
//
//     final otpVerificationResponse = otpVerificationResponseFromJson(jsonString);

import 'dart:convert';

OtpVerificationResponse otpVerificationResponseFromJson(String str) =>
    OtpVerificationResponse.fromJson(json.decode(str));

String otpVerificationResponseToJson(OtpVerificationResponse data) =>
    json.encode(data.toJson());

class OtpVerificationResponse {
  OtpVerificationResponse({
    this.n,
    this.msg,
  });

  int n;
  String msg;

  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) =>
      OtpVerificationResponse(
        n: json["n"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "n": n,
        "msg": msg,
      };
}
