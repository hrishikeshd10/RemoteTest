import 'dart:convert';

SetCountApiResponse setCountApiResponseFromJson(String str) =>
    SetCountApiResponse.fromJson(json.decode(str));

String setCountApiResponseToJson(SetCountApiResponse data) =>
    json.encode(data.toJson());

class SetCountApiResponse {
  SetCountApiResponse({
    this.n,
    this.msg,
  });

  int n;
  String msg;

  factory SetCountApiResponse.fromJson(Map<String, dynamic> json) =>
      SetCountApiResponse(
        n: json["n"] == null ? null : json["n"],
        msg: json["msg"] == null ? null : json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "n": n == null ? null : n,
        "msg": msg == null ? null : msg,
      };
}
