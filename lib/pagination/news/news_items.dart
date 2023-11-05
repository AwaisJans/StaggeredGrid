import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// To parse this JSON data, do
//
//     final dashboardItems = dashboardItemsFromJson(jsonString);

NewsItems newsItemsFromJson(String str) => NewsItems.fromJson(json.decode(str));

String newsItemsToJson(NewsItems data) => json.encode(data.toJson());

class NewsItems {
  List<News> news;

  NewsItems({
    required this.news,
  });

  factory NewsItems.fromJson(Map<String, dynamic> json) => NewsItems(
        news: json["items"] == null
            ? []
            : List<News>.from(json["items"]!.map((x) => News.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": news == null
            ? []
            : List<dynamic>.from(news!.map((x) => x.toJson())),
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

class News {
  String autor;
  String bezeichnung;
  String content;
  int datum;
  int id;
  String teaserbild;
  String teasertext;
  bool topartikel;
  List<kategorien> kategoriens;

  News(
      {required this.autor,
      required this.bezeichnung,
      required this.content,
      required this.datum,
      required this.id,
      required this.teaserbild,
      required this.teasertext,
      required this.topartikel,
      required this.kategoriens});

  factory News.fromJson(Map<String, dynamic> json) => News(
        autor: json["autor"],
        bezeichnung: json["bezeichnung"],
        content: json["content"],
        datum: json["datum"],
        id: json["id"],
        teaserbild: json["teaserbild"],
        teasertext: json["teasertext"],
        topartikel: json["topartikel"],
        kategoriens: json["kategorien"] == null
            ? []
            : List<kategorien>.from(
                json["kategorien"]!.map((x) => kategorien.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "autor": autor,
        "bezeichnung": bezeichnung,
        "content": content,
        "datum": datum,
        "id": id,
        "teaserbild": teaserbild,
        "teasertext": teasertext,
        "topartikel": topartikel,
        "kategorien": kategoriens == null
            ? []
            : List<dynamic>.from(kategoriens!.map((x) => x.toJson())),
      };
}
