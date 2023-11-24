
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../configs/app_config.dart';
import '../news_items.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'image_picker_view.dart';


class newsDetail extends StatelessWidget {

  final News newsSingleFetchItem;

  newsDetail({super.key, required this.newsSingleFetchItem});

  @override
  Widget build(BuildContext context) {
    return CustomLayoutWebView(this.newsSingleFetchItem);
  }

}

class CustomLayoutWebView extends StatefulWidget {
  final News newsSingleFetchItem;

  CustomLayoutWebView(this.newsSingleFetchItem);

  @override
  _CustomLayoutWebViewState createState() => _CustomLayoutWebViewState(this.newsSingleFetchItem);

}

class _CustomLayoutWebViewState extends State<CustomLayoutWebView> {

  final News newsSingleFetchItem;

  _CustomLayoutWebViewState(this.newsSingleFetchItem);


  late final PlatformWebViewController _controller;
  WebViewController controller = WebViewController();


  late double webViewHeight = 300.0; // Initial height

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

// Inject JavaScript code to calculate the content height
  String script = """
                                var height = Math.max( document.body.scrollHeight, document.body.offsetHeight, 
                                      document.documentElement.clientHeight, document.documentElement.scrollHeight, 
                                      document.documentElement.offsetHeight);
                height;
                              """;

  // Inject JavaScript code to calculate the content height
  String metaScript = """
                                 var meta = document.createElement('meta');
                              meta.name = 'viewport';
                              meta.content = 'width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=no';
                              document.head.appendChild(meta);
                              """;

  // Inject JavaScript code to calculate the content height
  String fontFamily = """
                                document.body.style.fontFamily = '-apple-system';
                               document.body.style.webkitTextSizeAdjust = '300%';
                              """;

  // Inject JavaScript code to calculate the content height
  String imagesSize = """
                                  for (var j=0;j<document.images.length;j++) {
                                    document.images[j].style.width = '100%';
                                    document.images[j].style.height = 'auto';
                                  }
                              """;
  @override
  void initState() {

    super.initState();
    controller;
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setBackgroundColor(const Color(0x00000000));





    controller.canGoBack();

    controller.addJavaScriptChannel(
      'Toaster',
      onMessageReceived: (JavaScriptMessage message) {
        print(message.message);
        print('Toaster Flutter Mobile');
      },
    );
    controller.setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.contains('showpic')) {
          debugPrint('blocking navigation to ${request.url}');

          SizedBox(
            width: 100,
            height: 140,
            child: InstaImageViewer(
              child: Image(
                image: Image.network(request.url)
                    .image,
              ),
            ),
          );

          return NavigationDecision.prevent;
        }
        debugPrint('allowing navigation to ${request.url}');
        return NavigationDecision.prevent;
      },
      onProgress: (int progress) {
        debugPrint('WebView is loading (progress : $progress%)');
      },
      onPageStarted: (String url) {
        debugPrint('Page started loading: $url');
        if (url.contains("_showpic")){
          print("found");
        }
      },
      onPageFinished: (String url) async {
        debugPrint('Page finished loading: $url');
        await controller.runJavaScript(metaScript);
        await controller.runJavaScript(fontFamily);
        await controller.runJavaScript(imagesSize);
        await controller.runJavaScript("""
        
        """);




        // String result = {await controller
        //     .runJavaScriptReturningResult(script)}.toString();


        _onHeightWebView(context).then((value) => setState((){
          webViewHeight = value as double;
          print('JavaScriptZecondzzzs ${webViewHeight.toString()}');

        }));

      },
    ));
    controller.loadHtmlString(newsSingleFetchItem.content.toString());



  }

  Future<int> _onHeightWebView(BuildContext context) async {
    // Inject JavaScript code to calculate the content height
    String script = """
                                var height = Math.max( document.body.scrollHeight, document.body.offsetHeight, 
                                      document.documentElement.clientHeight, document.documentElement.scrollHeight, 
                                      document.documentElement.offsetHeight);
                height;
                              """;

    final int heightWebView = await controller
        .runJavaScriptReturningResult(script) as int;

    setState(() {
      webViewHeight = double.parse(heightWebView.toString());
      print('JavaScriptZeconds ${heightWebView.toString()}');

    });

    return heightWebView;
  }

  @override
  Widget build(BuildContext context) {

    int timeStamp = newsSingleFetchItem.datum;
    /// converting timestamp to date format
    int unixTimestamp = timeStamp; // Your Unix timestamp
    DateTime dateTime =
    DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);

    /// If the timestamp is in seconds, multiply by 1000 to convert it to milliseconds
    String formattedDate =
        '${dateTime.year}-${dateTime.month}-${dateTime.day}';

    return Scaffold(
      appBar: AppBar(
        title: Text(newsSingleFetchItem.autor.toString()),
      ),
      backgroundColor: Colors.grey, // Change the background color here

      body:
      ListView(
        children: [
          Container(
            color: Colors.white,
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child:Column(
              children: [
                //____________________ IMAGE CODE ____________________________________
                Container(
                  height: 300.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(newsSingleFetchItem.teaserbild.toString()),
                      fit: BoxFit.cover, // Adjust this based on your requirement
                    ),
                    boxShadow: const [
                      BoxShadow(blurRadius: 5.0)
                    ],
                    borderRadius: new BorderRadius.vertical(
                        bottom: new Radius.elliptical(
                            MediaQuery.of(context).size.width, 150.0)),
                  ),

                ),

                //____________________ SHOW CATEGORY CODE ____________________________________
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
                //____________________ DATE CODE ____________________________________
                Container(
                  padding: EdgeInsets.fromLTRB(AppConfig.newsCardLeftMargin, 10, AppConfig.newsCardRightMargin, 10), // Adjust the margin values as needed
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.calendar_today, // Calendar icon
                        color:
                        Colors.black, // Adjust the color as needed
                      ),
                      const SizedBox(
                          width:
                          8), // Adjust the spacing between the icon and text
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize:
                          16, // Adjust the font size as needed
                          color: Colors
                              .black, // Adjust the text color as needed
                        ),
                      ),
                    ],
                  ),
                ),
                //____________________ BEYEICHUNG CODE ____________________________________
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0,
                      15), // Adjust the margin values as needed
                  child:
                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          newsSingleFetchItem.bezeichnung.toString(),
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize:
                              18, // Adjust the font size as needed
                              color: Colors
                                  .black, // Adjust the text color as needed
                              fontWeight: FontWeight.bold),
                        ),
                      ),


                      //____________________ TEASER TEXT CODE____________________________________

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          newsSingleFetchItem.teasertext.toString(),
                          style: const TextStyle(
                              fontSize:
                              16, // Adjust the font size as needed
                              color: Colors
                                  .black, // Adjust the text color as needed
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
                //____________________ WEB VIEW CODE ____________________________________
                SizedBox(
                  height: webViewHeight ,
                  child:
                  WebViewWidget(controller: controller,),

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
