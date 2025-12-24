// To parse this JSON data, do
//
//     final jobsModel = JobsModel.fromJson(jsonString);

import 'dart:convert';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  int ongoing;
  int allocated;

  HomeModel({
    required this.ongoing,
    required this.allocated,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    ongoing: json["jobs"]["ongoing"],
    allocated: json["jobs"]["allocated"],
  );

  Map<String, dynamic> toJson() => {
    "ongoing": ongoing,
    "allocated": allocated,
  };
}
