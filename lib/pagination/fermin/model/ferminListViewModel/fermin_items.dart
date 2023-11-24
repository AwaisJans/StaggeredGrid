import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// To parse this JSON data, do
//
//     final dashboardItems = dashboardItemsFromJson(jsonString);

/// NewsItems --> FerminItems
/// newsItemsFromJson --> ferminItemsFromJson
/// newsItemsToJson --> ferminItemsToJson
///



FerminItems ferminItemsFromJson(String str) => FerminItems.fromJson(json.decode(str));

String ferminItemsToJson(FerminItems data) => json.encode(data.toJson());

class FerminItems {
  List<Fermin> fermin;

  FerminItems({
    required this.fermin,
  });

  factory FerminItems.fromJson(Map<String, dynamic> json) => FerminItems(
    fermin: json["items"] == null
            ? []
            : List<Fermin>.from(json["items"]!.map((x) => Fermin.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": fermin == null
            ? []
            : List<dynamic>.from(fermin!.map((x) => x.toJson())),
      };
}

class kategorien {
  String bezeichnung;
  int id;

  kategorien({
    required this.bezeichnung,
    required this.id,
  });

  factory kategorien.fromJson(Map<String, dynamic> json) =>
      kategorien(id: json["id"], bezeichnung: json["bezeichnung"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "bezeichnung": bezeichnung,
      };
}

class Fermin {
  String? beschreibung;
  String? beschreibung2;
  String? beschreibung3;
  String? bezeichnung;
  String? bild;
  String? email;
  String? extra1;
  String? extra2;
  String? extra3;
  String? extra4;
  String? extra5;
  int? id;
  String? fax;
  String? homepage;
  String? lat;
  String? lng;
  String? mobil;
  String? ort;
  String? plz;
  String? strasse;
  String? telefon;
  String? telefon2;
  String? urlDetails;
  List<kategorien> kategoriens;

  Fermin(
      {this.beschreibung,
        this.beschreibung2,
        this.beschreibung3,
        this.bezeichnung,
        this.bild,
        this.email,
        this.extra1,
        this.extra2,
        this.extra3,
        this.extra4,
        this.extra5,
        this.id,
        this.fax,
        this.homepage,
        this.lat,
        this.lng,
        this.mobil,
        this.ort,
        this.plz,
        this.strasse,
        this.telefon,
        this.telefon2,
        this.urlDetails,
        required this.kategoriens});

  factory Fermin.fromJson(Map<String, dynamic> json) => Fermin(

      beschreibung : json["beschreibung"],
    beschreibung2 : json["beschreibung2"],
      beschreibung3 : json["beschreibung3"],
      bezeichnung : json["bezeichnung"],
      bild : json["bild"],
      email : json["email"],
      extra1 : json["extra1"],
      extra2 : json["extra2"],
      extra3 : json["extra3"],
      extra4 : json["extra4"],
      extra5 : json["extra5"],
      id : json["id"],
      fax : json["fax"],
      homepage : json["homepage"],
      lat : json["lat"],
      lng : json["lng"],
      mobil : json["mobil"],
      ort : json["ort"],
      plz : json["plz"],
      strasse : json["strasse"],
      telefon : json["telefon"],
      telefon2 : json["telefon2"],
      urlDetails : json["urlDetails"],

    kategoriens: json["kategorien"] == null
            ? []
            : List<kategorien>.from(
                json["kategorien"]!.map((x) => kategorien.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {


    "beschreibung" : beschreibung,
    "beschreibung2" : beschreibung2,
    "beschreibung3" : beschreibung3,
    "bezeichnung" : bezeichnung,
    "bild" : bild,
    "email" : email,
    "extra1" : extra1,
    "extra2" : extra2,
    "extra3" : extra3,
    "extra4" : extra4,
    "extra5" : extra5,
    "id" : id,
    "fax" : fax,
    'homepage' : homepage,
    "lat" : lat,
    "lng" : lng,
    "mobil" : mobil,
    "ort" : ort,
    "plz" : plz,
    "strasse" : strasse,
    "telefon" : telefon,
    "telefon2" : telefon2,
    "urlDetails" : urlDetails,

        "kategorien": kategoriens == null
            ? []
            : List<dynamic>.from(kategoriens!.map((x) => x.toJson())),
      };
}
