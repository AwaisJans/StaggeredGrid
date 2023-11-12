

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';



class MyImageScreen extends StatelessWidget {
    // String url;
    // MyImageScreen(this.url);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: MyImageView(url),
      home: MyImageView(),
    );
  }
}

class MyImageView extends StatefulWidget {

  // String url;
  // MyImageView(this.url);

  @override
  // _MyImageViewState createState() => _MyImageViewState(url);
  _MyImageViewState createState() => _MyImageViewState();
}

class _MyImageViewState extends State<MyImageView> {
  // String url;
  // _MyImageViewState(this.url);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Picker"),

      ),

    );
  }
}