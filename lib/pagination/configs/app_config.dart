import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';

class AppConfig {
  // static String get baseUrl => "someurl.com/";
  // static String get place => baseUrl + "api/v1/place";


  static int get newsID => 3;
  static int get ferminID => 4;
  static bool isFilter = false;

  static double get newsCardLeftMargin => 15;
  static double get newsCardRightMargin => 15;
  static double get newsCardBottomMargin => 15;


  static String newsUrlItems(String baseUrl, int limitStart, int limitItems) {
    String url = "$baseUrl&action=getNewsItems&limitStart=$limitStart&limitAmount=$limitItems";
    return url;
  }



  static String newsFilterItemsUrl(String kategoryListString,
      String voltText,int limitStart, int limitItems,bool bool1) {

    String returnedUrl;

    String urlUnFilter = "https://www.schaeferlauf-markgroeningen.de/index.php?id=269&baseColor=0571B1&baseFontSize=16"
        "&action=getNewsItems&limitStart=$limitStart&limitAmount=$limitItems";

    String urlFiltered = "https://www.empfingen.de/index.php?id=265&baseColor=2727278&baseFontSize=14"
        "&action=getNewsItems$kategoryListString&volltext=$voltText"
        "&limitStart=$limitStart&limitAmount=$limitItems";

      // if (bool1){
        returnedUrl = urlFiltered;
        print("filtered_called");
      // }
      // else{
      //   returnedUrl = urlUnFilter;
      //   print("unfiltered_called");

      // }
    return returnedUrl;


  }

  static String ferminUrlItems(String baseUrl, int limitStart, int limitItems) {
    String url = "$baseUrl&action=getFirmaItems&limitStart=$limitStart&limitAmount=$limitItems";
    return url;
  }

}














