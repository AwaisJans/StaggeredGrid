import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

MarkerPopupItems markerPopupItemsFromJson(String str) => MarkerPopupItems.fromJson(json.decode(str));

String markerPopupItemsToJson(MarkerPopupItems data) => json.encode(data.toJson());

class MarkerPopupItems {
  List<markerPopupItem> markerPopup;

  MarkerPopupItems({
    required this.markerPopup,
  });

  factory MarkerPopupItems.fromJson(Map<String, dynamic> json) => MarkerPopupItems(
    markerPopup: json["singleItem"] == null
        ? []
        : List<markerPopupItem>.from(json["singleItem"]!.map((x) => markerPopupItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "singleItem": markerPopupItem == null
        ? []
        : List<dynamic>.from(markerPopup!.map((x) => x.toJson())),
  };
}



class markerPopupItem {
  String? bezeichnung;
  num? id;
  String? ort;
  String? plz;
  String? strasse;
  String? urlDetails;

  markerPopupItem(
      {this.bezeichnung,
        this.id,
        this.ort,
        this.plz,
        this.strasse,
        this.urlDetails});

  factory markerPopupItem.fromJson(Map<String, dynamic> json) => markerPopupItem(

    bezeichnung : json["bezeichnung"],
    id : json["id"],
    ort : json["ort"],
    plz : json["plz"],
    strasse : json["strasse"],
    urlDetails : json["urlDetails"],
  );

  Map<String, dynamic> toJson() => {

    "bezeichnung" : bezeichnung,
    "id" : id,
    "ort" : ort,
    "plz" : plz,
    "strasse" : strasse,
    "urlDetails" : urlDetails,
  };
}
