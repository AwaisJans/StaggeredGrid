

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:photo_view/photo_view.dart';



class MyImageView extends StatefulWidget {
  String url;

  MyImageView({super.key, required this.url});

  @override
  _MyImageViewState createState() => _MyImageViewState(this.url);
}

class _MyImageViewState extends State<MyImageView> {
  late String url;

  _MyImageViewState(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Container(
        alignment: Alignment.center,
        child:
        Container(
          margin: const EdgeInsets.all(8.0),
          width: 280,
          height: 70,
          color: Colors.black,
          child:ElevatedButton(

            onPressed: () {

            },
            style: ElevatedButton.styleFrom(
              primary: Colors.black, // Change the background color here
            ),
            child: const Text('Image',
              style: TextStyle(
                  fontSize: 18
              ),
            ),
          ),
        ),



        // PhotoView(
        //   imageProvider: CachedNetworkImageProvider(url),
        // ),


        // Image.network(url,
        //   width: 175,
        //   height: 140,
        //   fit: BoxFit.contain,
        // ),
      )





    );
  }
}


