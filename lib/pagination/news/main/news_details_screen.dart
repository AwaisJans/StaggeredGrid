
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../configs/app_config.dart';
import '../news_items.dart';





class newsDetail extends StatelessWidget {

  final News newsSingleFetchItem;
  newsDetail({super.key, required this.newsSingleFetchItem});


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
          shrinkWrap: true, // Allow ListView to shrink-wrap its content
          children:[
              Column(
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
                        WebViewWidgetStateFul(newsSingleFetchItem),
                      ],
                    ),
                  ),
                ],
              ),
            ],
        ),
    );
  }
}

class WebViewWidgetStateFul extends StatefulWidget {
  final News newsSingleFetchItem;
  WebViewWidgetStateFul(this.newsSingleFetchItem);

  @override
  _WebViewWidgetStateFulState createState() => _WebViewWidgetStateFulState(newsSingleFetchItem);
}

class _WebViewWidgetStateFulState extends State<WebViewWidgetStateFul> {

  late final News newsSingleFetchItem;
  _WebViewWidgetStateFulState(this.newsSingleFetchItem);

  InAppWebViewController? webView;


  static const kInitialTextSize = 300;
  static const  kTextSizePlaceholder = 'TEXT_SIZE_PLACEHOLDER';
  static const  kTextSizeSourceJS = """
window.addEventListener('DOMContentLoaded', function(event) {
  document.body.style.textSizeAdjust = '$kTextSizePlaceholder%';
  document.body.style.webkitTextSizeAdjust = '$kTextSizePlaceholder%';
});
""";


  final textSizeUserScript = UserScript(
      source: kTextSizeSourceJS.replaceAll(kTextSizePlaceholder, '$kInitialTextSize'),
      injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START);

  Future main() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (!kIsWeb &&
        kDebugMode &&
        defaultTargetPlatform == TargetPlatform.android) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
    }

  }

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;

  int textSize = kInitialTextSize;

  updateTextSize(int textSize) async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await webViewController?.setSettings(
          settings: InAppWebViewSettings(textZoom: textSize));
    } else {
      // update current text size
      await webViewController?.evaluateJavascript(source: """
              document.body.style.textSizeAdjust = '$textSize%';
              document.body.style.webkitTextSizeAdjust = '$textSize%';
            """);

      // update the User Script for the next page load
      await webViewController?.removeUserScript(userScript: textSizeUserScript);
      textSizeUserScript.source =
          kTextSizeSourceJS.replaceAll(kTextSizePlaceholder, '$textSize');
      await webViewController?.addUserScript(userScript: textSizeUserScript);
    }
  }

  double webViewHeight = 300.0; // Initial height
  int loadStopCount = 0;
  int maxLoadStopCount = 5; // Maximum number of times to check for content height



  @override
  Widget build(BuildContext context) {
    // Initial height, adjust as needed


    return
      // ConstrainedBox(
      //     constraints: BoxConstraints(maxHeight: 1500),
      //     child:
          Container(
            height: webViewHeight,
            // height: MediaQuery.of(context).size.height * 5.4,
            child:
            InAppWebView(

              initialData: InAppWebViewInitialData(
                data: newsSingleFetchItem.content.toString(),
              ),

              key: webViewKey,
              initialUserScripts: UnmodifiableListView(
                  !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                      ? []
                      : [textSizeUserScript]),
              initialSettings: InAppWebViewSettings(textZoom: textSize),


              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    supportZoom: true
                  /// you can add more options using documentations
                ),
              ),

              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStop: (InAppWebViewController controller, Uri? url) async {
                  if (loadStopCount < maxLoadStopCount) {
                      try {
                          double contentHeight = double.parse(
                            await webViewController!.evaluateJavascript(source: 'document.documentElement.scrollHeight.toString();'),
                          );
                          if (contentHeight > 0 && contentHeight != webViewHeight) {
                            setState(() {
                            webViewHeight = contentHeight;
                            });
                          } else {
                            // If the content height is not valid, retry after a delay
                            await Future.delayed(Duration(seconds: 2));
                            webViewController?.reload();
                            loadStopCount++;
                          }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Can not get Dynamic Height'),
                        ));
                      }
                  }

                // Get the content height after the page is loaded
                const String functionBody = """
              for (var j=0;j<document.images.length;j++) {
                document.images[j].style.width = '100%';
                document.images[j].style.height = 'auto';
            }

            (function getImages(){
            var objs = window.document.getElementsByTagName('img');
            var imgScr = '+';
            for(var i=0;i<objs.length;i++){
            imgScr = imgScr + objs[i].src + '+';
            };
            return imgScr;
            })();
            (function getImagesTitle(){
    var objs = document.getElementsByTagName('img');
    var title = '+';
    for(var i=0;i<objs.length;i++){
		var titleTemp = objs[i].title;

		if ( titleTemp === '' ) {
			var figure = objs[i].parentNode.parentNode;

			if ( typeof figure !== 'undefined' && figure ) {
				var tagName = figure.tagName.toUpperCase();

				if ( tagName === 'FIGURE' ) {

					var figcaption = figure.children[1];

					if ( typeof figcaption !== 'undefined' && figcaption ) {
                        var tagNameCaption = figcaption.tagName.toUpperCase();

                        if ( tagNameCaption === 'FIGCAPTION' ) {

                            titleTemp = figcaption.innerHTML;

                        }


                    }

                }


            }
        }

         title = title + titleTemp + '+';
    };
    return title;

})();
              (function getLongImages(){
            var objs = window.document.getElementsByTagName('a');
            var imgScr = 'Ü';
            for(var i=0;i<objs.length;i++){
            imgScr = imgScr + objs[i].href + 'Ü';
            };
            return imgScr;
            })();

           //javascript:window.document.getElementsByTagName('body')[0].style.color='red';
            javascript:window.document.getElementsByTagName('body')[0].style.textSizeAdjust='600%';
           javascript:window.document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='600%';

              """;
                webView?.evaluateJavascript(source: functionBody).then((result) {
                  debugPrint(result);

                });


              },
            ),

          // ),

      );



  }

}

