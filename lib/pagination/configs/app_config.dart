import 'dart:ffi';

import 'package:flutter/material.dart';

class AppConfig {
  // static String get baseUrl => "someurl.com/";
  // static String get place => baseUrl + "api/v1/place";


  static int get newsID => 3;

  static double get newsCardLeftMargin => 15;
  static double get newsCardRightMargin => 15;
  static double get newsCardBottomMargin => 15;


  static String newsUrlItems(String baseUrl, int limitStart, int limitItems) {
    String url = "$baseUrl&action=getNewsItems&limitStart=$limitStart&limitAmount=$limitItems";
    return url;
  }


}