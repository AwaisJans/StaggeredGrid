
import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_project/pagination/fermin/main/fermin_list_view_screen.dart';
import 'package:test_project/pagination/fermin/model/fermin_map_model/fermin_map_items.dart';

import '../../dashboard_items.dart';
import 'package:http/http.dart' as http;

import 'fermin_google_map.dart';

class ferminListView extends StatefulWidget { /// stateful widget

  final Dashboard dashboardSingleFetchItem;

  ferminListView({super.key, required this.dashboardSingleFetchItem});

  @override
  _ferminListViewState createState() => _ferminListViewState(this.dashboardSingleFetchItem);
}

class _ferminListViewState extends State<ferminListView> {  /// state widget

  final Dashboard dashboardSingleFetchItem;
  _ferminListViewState(this.dashboardSingleFetchItem);


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(dashboardSingleFetchItem.title.toString()),
      ),
        backgroundColor: Colors.grey,

        body:MyFerminListView(),
    );
  }
}





