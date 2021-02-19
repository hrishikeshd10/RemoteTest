// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.n,
    this.msg,
    this.data,
  });

  int n;
  String msg;
  Data data;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        n: json["n"] == null ? null : json["n"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "n": n == null ? null : n,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : data.toJson(),
      };
}

class Data {
  Data({
    this.userid,
    this.username,
    this.email,
    this.mobile,
    this.dob,
    this.businessname,
    this.address,
    this.pincode,
    this.profileImage,
  });

  int userid;
  String username;
  String email;
  int mobile;
  String dob;
  String businessname;
  String address;
  int pincode;
  String profileImage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userid: json["userid"] == null ? null : json["userid"],
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        dob: json["dob"] == null ? null : json["dob"],
        businessname:
            json["businessname"] == null ? null : json["businessname"],
        address: json["address"] == null ? null : json["address"],
        pincode: json["pincode"] == null ? null : json["pincode"],
        profileImage:
            json["profile_image"] == null ? null : json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid == null ? null : userid,
        "username": username == null ? null : username,
        "email": email == null ? null : email,
        "mobile": mobile == null ? null : mobile,
        "dob": dob == null ? null : dob,
        "businessname": businessname == null ? null : businessname,
        "address": address == null ? null : address,
        "pincode": pincode == null ? null : pincode,
        "profile_image": profileImage == null ? null : profileImage,
      };
}
