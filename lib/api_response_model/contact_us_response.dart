import 'dart:convert';

ContactUsResponse contactUsResponseFromJson(String str) =>
    ContactUsResponse.fromJson(json.decode(str));

String contactUsResponseToJson(ContactUsResponse data) =>
    json.encode(data.toJson());

class ContactUsResponse {
  ContactUsResponse({
    this.n,
    this.msg,
    this.data,
  });

  int n;
  String msg;
  String data;

  factory ContactUsResponse.fromJson(Map<String, dynamic> json) =>
      ContactUsResponse(
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
