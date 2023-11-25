import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


NewsFilterItems newsItemsFromJson(String str) => NewsFilterItems.fromJson(json.decode(str));

String newsItemsToJson(NewsFilterItems data) => json.encode(data.toJson());

class NewsFilterItems {
  List<Filters> filters;

  NewsFilterItems({
    required this.filters,
  });

  factory NewsFilterItems.fromJson(Map<String, dynamic> json) => NewsFilterItems(
    filters: json["items"] == null
            ? []
            : List<Filters>.from(json["items"]!.map((x) => Filters.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": filters == null
            ? []
            : List<dynamic>.from(filters!.map((x) => x.toJson())),
      };
}



class Filters {
  String bezeichnung;
  int id;


  Filters(
      {
      required this.bezeichnung,
      required this.id});

  factory Filters.fromJson(Map<String, dynamic> json) => Filters(
        bezeichnung: json["bezeichnung"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "bezeichnung": bezeichnung,
        "id": id,
      };
}
