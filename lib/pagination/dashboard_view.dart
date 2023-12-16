import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

import 'dashboardViews/GridViewUtil.dart';
import 'dashboard_items.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var now = DateTime.now();
  var formattedDate =
      DateFormat.yMMMd().format(DateTime.now()); // Format the date

  Future<DashboardItems> getProductsApi() async {
    //create your own api
    final String response =
        await rootBundle.loadString('drawable/dashboard_modules.json');
    var dashboardItems = dashboardItemsFromJson(response);

    debugPrint('dashboardItems: ${dashboardItems.dashboard![2].title}');
    return dashboardItems;
  }

  void getCharactersfromApi() async {
    final String response =
        await rootBundle.loadString('drawable/dashboard_modules.json');

    // final data = await DashboardItems.fromJson(jsonDecode(response) as Map<String, dynamic>);

    final dashboardItems = dashboardItemsFromJson(response);
    debugPrint('dashboardItems: ${dashboardItems.dashboard![2].title}');

    setState(() {});
  }

  @override
  void initState() {
    super.initState();





    getCharactersfromApi();
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey, // Change the background color here

      // using scroll view
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage(''), fit: BoxFit.fill)),
          child: Column(
            children: [
              // show header
              Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.topRight,
                  margin: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                  // Set margin for all sides

                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("setting"),
                      ));
                    }, // Image tapped
                    child: SvgPicture.asset(
                      'assets/images/setting1.svg',
                      semanticsLabel: 'My SVG Image',
                      height: 50,
                      alignment: Alignment.topRight,
                      width: 70,
                    ),
                  )),
              Container(
                width: double.infinity,
                height: 250,
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                // Set margin for all sides
                child: Image.asset(
                    'assets/images/example_a.png'), // Replace with your image path
              ),


              // show weather text

              Container(
                margin: const EdgeInsets.fromLTRB(25, 10, 20, 5),
                // Margin for the Row
                child: const Row(
                  children: <Widget>[
                    Text(
                      '22 °C',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                        width: 8.0,
                        height:
                            50), // Adjust the space between the Text and Icon
                    Icon(
                      WeatherIcons.cloudy,
                      size: 50,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),

              // show date text
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                // Set margin for all sides
                child: Text(
                  formattedDate, // Display the formatted date
                  style: const TextStyle(fontSize: 20),
                ),
              ),

              // show grid view
              Container(
                // Simple Grid View
                child: MyGridView(),

                // Using Staggered Grid View
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final int index;

  const Tile({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Tile $index',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
