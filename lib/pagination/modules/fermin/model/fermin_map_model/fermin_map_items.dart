import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// To parse this JSON data, do
//
//     final dashboardItems = dashboardItemsFromJson(jsonString);

/// NewsItems --> FerminItems
/// newsItemsFromJson --> ferminMapItemsFromJson
/// newsItemsToJson --> ferminMapItemsToJson
///



FerminMapItems ferminMapItemsFromJson(String str) => FerminMapItems.fromJson(json.decode(str));

String ferminMapItemsToJson(FerminMapItems data) => json.encode(data.toJson());

class FerminMapItems {
  List<fermanMapItem> ferminMap;

  FerminMapItems({
    required this.ferminMap,
  });

  factory FerminMapItems.fromJson(Map<String, dynamic> json) => FerminMapItems(
    ferminMap: json["items"] == null
            ? []
            : List<fermanMapItem>.from(json["items"]!.map((x) => fermanMapItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": fermanMapItem == null
            ? []
            : List<dynamic>.from(ferminMap!.map((x) => x.toJson())),
      };
}



class fermanMapItem {
  String? bezeichnung;
      num? id;
  String? lat;
      String? lng;
  String? urlPopUp;
      String? urlDetails;

  fermanMapItem(
      {this.bezeichnung,
        this.id,
        this.lat,
        this.lng,
        this.urlPopUp,
        this.urlDetails,});

  factory fermanMapItem.fromJson(Map<String, dynamic> json) => fermanMapItem(

    bezeichnung : json["bezeichnung"],
      id : json["id"],
      lat : json["lat"],
      lng : json["lng"],
      urlPopUp : json["urlPopUp"],
      urlDetails : json["urlDetails"],
      );

  Map<String, dynamic> toJson() => {

    "bezeichnung" : bezeichnung,
    "id" : id,
    "lat" : lat,
    "lng" : lng,
    "urlPopUp" : urlPopUp,
    "urlDetails" : urlDetails,
      };
}
