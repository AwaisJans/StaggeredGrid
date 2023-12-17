import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_project/pagination/configs/default_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:test_project/pagination/modules/dashboard/model/dashboard_items.dart';

import '../../../configs/app_config.dart';
import '../../fermin/main/ferminScreen.dart';
import '../../news/main/newsScreen.dart';


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
                    if (snapshot.data!.dashboard![index].id == AppConfig.newsID) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => newsApp(
                                  dashboardSingleFetchItem:
                                  snapshot.data!.dashboard![index])),
                        );
                    }

                    else if (snapshot.data!.dashboard![index].id == AppConfig.ferminID) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ferminListView(
                            dashboardSingleFetchItem:
                            snapshot.data!.dashboard![index])),
                      );
                    }



                    else{

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(snapshot.data!.dashboard![index].title),
                      ));
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


class QuiltedPage extends StatelessWidget {
  const QuiltedPage({
    Key? key,
  }) : super(key: key);

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
    return AppScaffold(
      title: 'QuiltedTest',
      child: GridView.custom(
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          repeatPattern: QuiltedGridRepeatPattern.same,
          pattern: pattern,
        ),
        childrenDelegate: SliverChildBuilderDelegate(
              (context, index) => Container(
            color: Colors.cyanAccent,
            child: Text("$index"),
          ),
          childCount: 14,
        ),
      ),
    );
  }
}


const _defaultColor = Color(0xFF34568B);

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    Key? key,
    required this.title,
    this.topPadding = 0,
    required this.child,
  }) : super(key: key);

  final String title;
  final Widget child;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: child,
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: backgroundColor ?? _defaultColor,
      height: extent,
      child: Center(
        child: CircleAvatar(
          minRadius: 20,
          maxRadius: 20,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Text('$index', style: const TextStyle(fontSize: 20)),
        ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}

class ImageTile extends StatelessWidget {
  const ImageTile({
    Key? key,
    required this.index,
    required this.width,
    required this.height,
  }) : super(key: key);

  final int index;
  final int width;
  final int height;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://picsum.photos/$width/$height?random=$index',
      width: width.toDouble(),
      height: height.toDouble(),
      fit: BoxFit.cover,
    );
  }
}

class InteractiveTile extends StatefulWidget {
  const InteractiveTile({
    Key? key,
    required this.index,
    this.extent,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;

  @override
  _InteractiveTileState createState() => _InteractiveTileState();
}

class _InteractiveTileState extends State<InteractiveTile> {
  Color color = _defaultColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (color == _defaultColor) {
            color = Colors.red;
          } else {
            color = _defaultColor;
          }
        });
      },
      child: Tile(
        index: widget.index,
        extent: widget.extent,
        backgroundColor: color,
        bottomSpace: widget.bottomSpace,
      ),
    );
  }
}


