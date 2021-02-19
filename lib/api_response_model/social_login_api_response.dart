// To parse this JSON data, do
//
//     final socialLoginResponse = socialLoginResponseFromJson(jsonString);

import 'dart:convert';

SocialLoginResponse socialLoginResponseFromJson(String str) =>
    SocialLoginResponse.fromJson(json.decode(str));

String socialLoginResponseToJson(SocialLoginResponse data) =>
    json.encode(data.toJson());

class SocialLoginResponse {
  SocialLoginResponse({
    this.n,
    this.msg,
    this.userdata,
  });

  int n;
  String msg;
  Userdata userdata;

  factory SocialLoginResponse.fromJson(Map<String, dynamic> json) =>
      SocialLoginResponse(
        n: json["n"] == null ? null : json["n"],
        msg: json["msg"] == null ? null : json["msg"],
        userdata: json["userdata"] == null
            ? null
            : Userdata.fromJson(json["userdata"]),
      );

  Map<String, dynamic> toJson() => {
        "n": n == null ? null : n,
        "msg": msg == null ? null : msg,
        "userdata": userdata == null ? null : userdata.toJson(),
      };
}

class Userdata {
  Userdata({
    this.id,
    this.firstName,
    this.lastName,
    this.gender,
    this.email,
    this.mobile,
    this.photo,
  });

  int id;
  String firstName;
  String lastName;
  String gender;
  String email;
  dynamic mobile;
  String photo;

  factory Userdata.fromJson(Map<String, dynamic> json) => Userdata(
        id: json["id"] == null ? null : json["id"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        gender: json["gender"] == null ? null : json["gender"],
        email: json["email"] == null ? null : json["email"],
        mobile: json["mobile"],
        photo: json["photo"] == null ? null : json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "gender": gender == null ? null : gender,
        "email": email == null ? null : email,
        "mobile": mobile,
        "photo": photo == null ? null : photo,
      };
}
