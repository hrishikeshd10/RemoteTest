// To parse this JSON data, do
//
//     final ratingFeedbackResponse = ratingFeedbackResponseFromJson(jsonString);

import 'dart:convert';

RatingFeedbackResponse ratingFeedbackResponseFromJson(String str) =>
    RatingFeedbackResponse.fromJson(json.decode(str));

String ratingFeedbackResponseToJson(RatingFeedbackResponse data) =>
    json.encode(data.toJson());

class RatingFeedbackResponse {
  RatingFeedbackResponse({
    this.n,
    this.msg,
  });

  int n;
  String msg;

  factory RatingFeedbackResponse.fromJson(Map<String, dynamic> json) =>
      RatingFeedbackResponse(
        n: json["n"] == null ? null : json["n"],
        msg: json["msg"] == null ? null : json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "n": n == null ? null : n,
        "msg": msg == null ? null : msg,
      };
}
