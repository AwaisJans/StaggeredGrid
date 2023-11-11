import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'dart:async';

import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      home: WebViewWidgetStateFul(),
    );
  }
}

class WebViewWidgetStateFul extends StatefulWidget {

  @override
  _WebViewWidgetStateFulState createState() => _WebViewWidgetStateFulState();
}

class _WebViewWidgetStateFulState extends State<WebViewWidgetStateFul> {


  final testItems = <String>[
    'Packing & Unpacking',
    'Cleaning',
    'Painting',
    'Heavy Lifting',
    'Shopping',
    'Watching Netflix',
    'sadfdsfe eaf',
    'ewfsfeagga,' 'gegea',
    'gaegaewgv ewaggaa aweegaage',
    'safa asdfesadfv esfsdf',
    'sadfdsfe eaf',
    'ewfsfeagga,' 'gegea',
    'awfgraga wsg sfage aegea',
    'gaegaewgv ewaggaa aweegaage',
    'asdfehtrbfawefa garevaa aewf a'
  ];


  @override
  Widget build(BuildContext context) {



    // Initial height, adjust as needed
    return Scaffold(
      backgroundColor: Colors.grey, // Change the background color here
      appBar: AppBar(
        title: Text("Hi world"),
      ),

      body:
      ListView(
        shrinkWrap: true,
        children:[

          Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 0,
                    15), // Adjust the margin values as needed
                child: Wrap(
                  children: [
                    // for (var item in kategoriens)
                    for (var item in testItems)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(color: Colors.red),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(13)),
                        ),
                        // you can change margin to increase spacing between containers
                        margin: const EdgeInsets.all(3),
                        padding:
                        const EdgeInsets.fromLTRB(4, 2, 4, 2),
                        child: Text(
                          // item.bezeichnung,
                          item as String,
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              )),

          Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 0,
                    15), // Adjust the margin values as needed
                child: Wrap(
                  children: [
                    // for (var item in kategoriens)
                    for (var item in testItems)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(color: Colors.red),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(13)),
                        ),
                        // you can change margin to increase spacing between containers
                        margin: const EdgeInsets.all(3),
                        padding:
                        const EdgeInsets.fromLTRB(4, 2, 4, 2),
                        child: Text(
                          // item.bezeichnung,
                          item as String,
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              )),



        ],
      ),


    );


  }

}

