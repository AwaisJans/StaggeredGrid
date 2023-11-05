import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_project/pagination/configs/default_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:test_project/pagination/dashboard_items.dart';
import 'package:test_project/pagination/news/main/newsScreen.dart';

import '../configs/app_config.dart';

Future<DashboardItems> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return DashboardItems.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}


class MyGridView extends StatefulWidget {
  @override
  _MyGridViewState createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {

  DashboardItems dashboardFetchItems = DashboardItems();

  Dashboard dashboardSingleItem = Dashboard();

  void getCharactersfromApi() async {
    final String response =
    await rootBundle.loadString('drawable/dashboard_modules.json');
    //await rootBundle.loadString('assets/raw/dashboard_modules.json');

    // final data = await DashboardItems.fromJson(jsonDecode(response) as Map<String, dynamic>);

    final dashboardItems = dashboardItemsFromJson(response);
    debugPrint('dashboardItems: ${dashboardItems.dashboard![2].title}');

    setState(() {});
  }

  Future<DashboardItems> readJsonFile() async {
    final String response = await rootBundle.loadString('drawable/dashboard_modules.json');
   // final String response = await rootBundle.loadString('assets/raw/dashboard_modules.json');
    final dashboardItems = dashboardItemsFromJson(response);
    return dashboardItems;
  }

  @override
  void initState() {
    readJsonFile().then((value) => setState((){
      dashboardFetchItems = value;
    }));
    super.initState();
  }

  static const pattern = [
    QuiltedGridTile(2, 2),
    QuiltedGridTile(4, 2),
    QuiltedGridTile(2, 2),
    QuiltedGridTile(2, 4),
    QuiltedGridTile(2, 2),
    QuiltedGridTile(2, 2),
    QuiltedGridTile(2, 4)
  ];


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DashboardItems>(
        future: readJsonFile(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              shrinkWrap: true,  // Allow the GridView to wrap its content
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.dashboard!.length,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              // Set padding for the whole GridView
              gridDelegate: SliverQuiltedGridDelegate(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                repeatPattern: QuiltedGridRepeatPattern.same,
                pattern: pattern,
              ),

              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                   // Fluttertoast.showToast(msg: snapshot.data!.dashboard![index].title , toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER);

                    if (snapshot.data!.dashboard![index].id == AppConfig.newsID) {




    // navigate to the desired route
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => newsApp(
    dashboardSingleFetchItem : snapshot.data!.dashboard![index]
    )),
                      );
                    }
                    else{
                      Fluttertoast.showToast(msg: snapshot.data!.dashboard![index].title ,
                          toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER);

                    }




                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            snapshot.data!.dashboard![index].title, // First text widget
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            snapshot.data!.dashboard![index].block, // Second text widget
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

              },
            );
          } else {
            return Text('Loading');
          }
        },
      );
  }
}

