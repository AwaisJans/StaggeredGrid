import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// To parse this JSON data, do
//
//     final dashboardItems = dashboardItemsFromJson(jsonString);

import 'dart:convert';

DashboardItems dashboardItemsFromJson(String str) =>
    DashboardItems.fromJson(json.decode(str));

String dashboardItemsToJson(DashboardItems data) => json.encode(data.toJson());

class DashboardItems {
  List<Dashboard>? dashboard;

  DashboardItems({
    this.dashboard,
  });

  factory DashboardItems.fromJson(Map<String, dynamic> json) => DashboardItems(
        dashboard: json["dashboard"] == null
            ? []
            : List<Dashboard>.from(
                json["dashboard"]!.map((x) => Dashboard.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "dashboard": dashboard == null
            ? []
            : List<dynamic>.from(dashboard!.map((x) => x.toJson())),
      };
}

class Dashboard {
  String? title;
  String? navTitle;
  String? block;
  bool? microsite;
  String? pushInternalKey;
  bool? cellLayoutSameasModule;
  int? id;
  String? tintcolor;
  String? cellBackgroundColor;
  String? url;
  String? imagename;
  List<Submodule>? submodules;

  Dashboard({
    this.title,
    this.navTitle,
    this.block,
    this.microsite,
    this.pushInternalKey,
    this.cellLayoutSameasModule,
    this.id,
    this.tintcolor,
    this.cellBackgroundColor,
    this.url,
    this.imagename,
    this.submodules,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
        title: json["title"],
        navTitle: json["navTitle"],
        block: json["block"],
        microsite: json["microsite"],
        pushInternalKey: json["pushInternalKey"],
        cellLayoutSameasModule: json["cellLayoutSameasModule"],
        id: json["id"],
        tintcolor: json["tintcolor"],
        cellBackgroundColor: json["cellBackgroundColor"],
        url: json["url"],
        imagename: json["imagename"],
        submodules: json["submodules"] == null
            ? []
            : List<Submodule>.from(
                json["submodules"]!.map((x) => Submodule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "navTitle": navTitle,
        "block": block,
        "microsite": microsite,
        "pushInternalKey": pushInternalKey,
        "cellLayoutSameasModule": cellLayoutSameasModule,
        "id": id,
        "tintcolor": tintcolor,
        "cellBackgroundColor": cellBackgroundColor,
        "url": url,
        "imagename": imagename,
        "submodules": submodules == null
            ? []
            : List<dynamic>.from(submodules!.map((x) => x.toJson())),
      };
}

class Submodule {
  String? block;
  String? title;
  String? navTitle;
  int? id;
  String? imagename;
  String? url;
  String? pushInternalKey;
  bool? microsite;

  Submodule({
    this.block,
    this.title,
    this.navTitle,
    this.id,
    this.imagename,
    this.url,
    this.pushInternalKey,
    this.microsite,
  });

  factory Submodule.fromJson(Map<String, dynamic> json) => Submodule(
        block: json["block"],
        title: json["title"],
        navTitle: json["navTitle"],
        id: json["id"],
        imagename: json["imagename"],
        url: json["url"],
        pushInternalKey: json["pushInternalKey"],
        microsite: json["microsite"],
      );

  Map<String, dynamic> toJson() => {
        "block": block,
        "title": title,
        "navTitle": navTitle,
        "id": id,
        "imagename": imagename,
        "url": url,
        "pushInternalKey": pushInternalKey,
        "microsite": microsite,
      };
}
