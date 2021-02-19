// To parse this JSON data, do
//
//     final getLocationResponse = getLocationResponseFromJson(jsonString);

import 'dart:convert';

GetLocationResponse getLocationResponseFromJson(String str) =>
    GetLocationResponse.fromJson(json.decode(str));

String getLocationResponseToJson(GetLocationResponse data) =>
    json.encode(data.toJson());

class GetLocationResponse {
  GetLocationResponse({
    this.n,
    this.msg,
    this.data,
  });

  int n;
  String msg;
  List<Datum> data;

  factory GetLocationResponse.fromJson(Map<String, dynamic> json) =>
      GetLocationResponse(
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
    this.fldId,
    this.fldName,
    this.fldSname,
    this.fldStatus,
    this.fldCreatedby,
    this.fldCreatedon,
    this.fldModifiedby,
    this.fldModifiedon,
  });

  String fldId;
  String fldName;
  String fldSname;
  String fldStatus;
  String fldCreatedby;
  DateTime fldCreatedon;
  dynamic fldModifiedby;
  dynamic fldModifiedon;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        fldId: json["fld_id"] == null ? null : json["fld_id"],
        fldName: json["fld_name"] == null ? null : json["fld_name"],
        fldSname: json["fld_sname"] == null ? null : json["fld_sname"],
        fldStatus: json["fld_status"] == null ? null : json["fld_status"],
        fldCreatedby:
            json["fld_createdby"] == null ? null : json["fld_createdby"],
        fldCreatedon: json["fld_createdon"] == null
            ? null
            : DateTime.parse(json["fld_createdon"]),
        fldModifiedby: json["fld_modifiedby"],
        fldModifiedon: json["fld_modifiedon"],
      );

  Map<String, dynamic> toJson() => {
        "fld_id": fldId == null ? null : fldId,
        "fld_name": fldName == null ? null : fldName,
        "fld_sname": fldSname == null ? null : fldSname,
        "fld_status": fldStatus == null ? null : fldStatus,
        "fld_createdby": fldCreatedby == null ? null : fldCreatedby,
        "fld_createdon":
            fldCreatedon == null ? null : fldCreatedon.toIso8601String(),
        "fld_modifiedby": fldModifiedby,
        "fld_modifiedon": fldModifiedon,
      };
}
