// To parse this JSON data, do
//
//     final getUserDetailsResponse = getUserDetailsResponseFromJson(jsonString);

import 'dart:convert';

GetUserDetailsResponse getUserDetailsResponseFromJson(String str) =>
    GetUserDetailsResponse.fromJson(json.decode(str));

String getUserDetailsResponseToJson(GetUserDetailsResponse data) =>
    json.encode(data.toJson());

class GetUserDetailsResponse {
  GetUserDetailsResponse({
    this.n,
    this.msg,
    this.data,
  });

  int n;
  String msg;
  List<Datum> data;

  factory GetUserDetailsResponse.fromJson(Map<String, dynamic> json) =>
      GetUserDetailsResponse(
        n: json["n"] == null ? null : json["n"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "n": n == null ? null : n,
        "msg": msg == null ? null : msg,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.name,
    this.lname,
    this.gender,
    this.emailId,
    this.contactNumber,
    this.businesName,
    this.addres,
    this.pincode,
    this.profilePictureUrl,
    this.userId,
    this.dateOfBirth,
  });

  String name;
  String lname;
  String gender;
  String emailId;
  int contactNumber;
  String businesName;
  String addres;
  int pincode;
  String profilePictureUrl;
  int userId;
  String dateOfBirth;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        name: json["name"] == null ? null : json["name"],
        lname: json["lname"] == null ? null : json["lname"],
        gender: json["gender"] == null ? null : json["gender"],
        emailId: json["emailID"] == null ? null : json["emailID"],
        contactNumber:
            json["contact_number"] == null ? null : json["contact_number"],
        businesName: json["businesName"] == null ? null : json["businesName"],
        addres: json["addres"] == null ? null : json["addres"],
        pincode: json["pincode"] == null ? null : json["pincode"],
        profilePictureUrl: json["profile_picture_URL"] == null
            ? null
            : json["profile_picture_URL"],
        userId: json["userID"] == null ? null : json["userID"],
        dateOfBirth:
            json["date_of_birth"] == null ? null : json["date_of_birth"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "lname": lname == null ? null : lname,
        "gender": gender == null ? null : gender,
        "emailID": emailId == null ? null : emailId,
        "contact_number": contactNumber == null ? null : contactNumber,
        "businesName": businesName == null ? null : businesName,
        "addres": addres == null ? null : addres,
        "pincode": pincode == null ? null : pincode,
        "profile_picture_URL":
            profilePictureUrl == null ? null : profilePictureUrl,
        "userID": userId == null ? null : userId,
        "date_of_birth": dateOfBirth == null ? null : dateOfBirth,
      };
}
