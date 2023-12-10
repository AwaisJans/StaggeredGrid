import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_project/pagination/fermin/main/fermin_item_details.dart';
import 'package:test_project/pagination/fermin/model/marker_popup_model/marker_popup_details_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class popupDetailedScreen extends StatefulWidget {
  String? urlDetails;

  popupDetailedScreen(String? this.urlDetails);

  @override
  _popupDetailedScreenState createState() =>
      _popupDetailedScreenState(urlDetails);
}

class _popupDetailedScreenState extends State<popupDetailedScreen> {
  String? urlDetails;

  _popupDetailedScreenState(this.urlDetails);

  final testItems = <String>[
    'Packing & Unpacking',
    'Cleaning',
    'Painting',
  ];

  WebViewController controller = WebViewController();

  late double webViewHeight = 300.0; // Initial height
  late double webViewHeadingHeight = 30; // Initial height
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

  String? htmlContent;

  @override
  void initState() {
    fetchData();
    super.initState();

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

  late final Map<String, dynamic>? jsonData;

  Future<MyData> fetchData() async {
    final response = await http.get(Uri.parse(urlDetails!));

    if (response.statusCode == 200) {

      return MyData.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load album');
    }
  }
  bool webviewBool = false;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text("Marker Details Screen"),
        ),
        backgroundColor: Colors.white, // Change the background color here

        body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData) {
            SingleItem items = snapshot.data!.singleItem;
            htmlContent = items.beschreibung;

            controller;

            if(!webviewBool){
              if(htmlContent!.isEmpty){
                webViewHeight = 0;
                webViewHeadingHeight = 0;
              }
              else{
                webViewHeadingHeight = 30;
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


                    _onHeightWebView(context).then((value) =>
                    // setState((){
                    webViewHeight = value as double
                      // print('JavaScriptZecondzzzs ${webViewHeight.toString()}'),

                      // })
                    );

                  },
                ));


                controller.loadHtmlString(htmlContent!);
                print("htmlString"+htmlContent!);

              }
              webviewBool = true;
            }

            /// Make a logic that make all widgets visibility
            /// false once second time wbview load then make visibility true




            return  ListView(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child:Column(
                    children: [
                      /// Categories
                      Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0,
                                15), // Adjust the margin values as needed
                            child: Wrap(
                              children: [
                                // for (var item in kategoriens)
                                for (var item in testItems)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(6, 43, 105, 1),
                                      border: Border.all(color: Color.fromRGBO(6, 43, 105, 1)),
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
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                          )),
                      /// Buttons
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                        child: Text(items.bezeichnung,

                          style: const TextStyle(fontSize: 28, // Adjust the font size as needed
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),

                      ),
                      Row(
                        children: [


                          InkWell(
                            onTap: () {
                              launch('tel:' + items.telefon.toString());
                            },

                            child:Container(
                              width: 120,
                              height: 70,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              color: Color.fromRGBO(6, 43, 105, 1),
                              child:const Row(
                                  mainAxisAlignment: MainAxisAlignment. center,
                                  children:[
                                    Icon(
                                      Icons.call, // Calendar icon
                                      color:
                                      Colors.white, //
                                    ),

                                    Padding(
                                      padding: EdgeInsets.fromLTRB(15,0,0,0), //apply padding to all four sides
                                      child: Text("Anrufen",
                                        style: TextStyle(fontSize: 13, // Adjust the font size as needed
                                            color: Colors.white),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),


                          InkWell(
                            onTap: () {
                              launch('mailto:' + items.email);
                            },
                            child:Container(
                              width: 120,
                              height: 70,
                              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              color: Color.fromRGBO(6, 43, 105, 1),
                              child:const Row(
                                  mainAxisAlignment: MainAxisAlignment. center,
                                  children:[
                                    Icon(
                                      Icons.email, // Calendar icon
                                      color:
                                      Colors.white, //
                                    ),

                                    Padding(
                                      padding: EdgeInsets.fromLTRB(15,0,0,0), //apply padding to all four sides
                                      child: Text("Email",
                                        style: TextStyle(fontSize: 13, // Adjust the font size as needed
                                            color: Colors.white),
                                      ),
                                    ),
                                  ]
                              ),
                            ),

                          ),

                          InkWell(
                            onTap: () {
                              launch(items.homepage);
                            },

                            child: Container(
                              width: 120,
                              height: 70,
                              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              color: Color.fromRGBO(6, 43, 105, 1),
                              child:const Row(
                                  mainAxisAlignment: MainAxisAlignment. center,
                                  children:[
                                    Icon(
                                      Icons.web, // Calendar icon
                                      color:
                                      Colors.white, //
                                    ),

                                    Padding(
                                      padding: EdgeInsets.fromLTRB(15,0,0,0), //apply padding to all four sides
                                      child: Text("Web",
                                        style: TextStyle(fontSize: 13, // Adjust the font size as needed
                                            color: Colors.white),
                                      ),
                                    ),
                                  ]
                              ),
                            ),

                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          // launch("tel:"+ferminSingleFetchItem.telefon!);
                          Contact contact = Contact();

                          Item phones = Item(value: items.telefon,
                              label: items.bezeichnung
                          );
                          contact.phones = [phones];

                          ContactsService.addContact(contact);

                        },

                        child: Container(
                          height: 70,
                          margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                          color: Color.fromRGBO(6, 43, 105, 1),
                          child:const Row(
                              mainAxisAlignment: MainAxisAlignment. center,
                              children:[
                                Icon(
                                  Icons.contact_phone, // Calendar icon
                                  color:
                                  Colors.white, //
                                ),

                                Padding(
                                  padding: EdgeInsets.fromLTRB(15,0,0,0), //apply padding to all four sides
                                  child: Text("Zu kontakt hinzufugen",
                                    style: TextStyle(fontSize: 13, // Adjust the font size as needed
                                        color: Colors.white),
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ),
                      /// Details TextViews
                      Container(
                        margin: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                        child: Row(
                            children:[
                              const Icon(
                                Icons.location_on, // Calendar icon
                                color: Colors.grey, //
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text("${"${items.strasse} - ${items.plz}"} ${items.ort}",
                                  style: const TextStyle(fontSize: 13, // Adjust the font size as needed
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                ),
                              ),
                            ]
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                        child: Row(
                            children:[
                              const Icon(
                                Icons.call, // Calendar icon
                                color: Colors.grey, //
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(items.telefon.toString(),
                                  style: TextStyle(fontSize: 13, // Adjust the font size as needed
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                ),
                              ),
                            ]
                        ),
                      ),
                      Visibility(
                        visible: items.email != "",
                        child:
                        Container(
                          margin: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                          child: Row(
                              children:[
                                const Icon(
                                  Icons.email, // Calendar icon
                                  color: Colors.grey, //
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child:  Text(items.email.toString(),
                                    style: const TextStyle(fontSize: 13, // Adjust the font size as needed
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ),
                      Visibility(
                        visible: items.homepage != "",
                        child:  Container(
                          margin: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                          child: Row(
                              children:[
                                const Icon(
                                  Icons.web, // Calendar icon
                                  color: Colors.grey, //
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child:  Text(items.homepage.toString(),
                                    style: const TextStyle(fontSize: 13, // Adjust the font size as needed
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ),
                      /// Image View
                      Visibility(
                        // visible: ferminSingleFetchItem.bild != "",
                        visible: true,
                        child:
                        GestureDetector(
                          onTap: () {
                          },
                          child:
                          // SizedBox(
                          //   width: 100,
                          //   height: 140,
                          //   child: InstaImageViewer(
                          //     child: Image(
                          //       image: Image.network("https://www.welzheim.de//fileadmin//user_upload//firmenliste_4bb6d5dbd782068b8d5f9aa839ad91c9.png")
                          //           .image,
                          //     ),
                          //   ),
                          // ),


                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GalleryExampleItemThumbnail(
                                    galleryExampleItem: galleryItems[0],
                                    onTap: () {
                                      open(context, 0);
                                    },
                                  ),
                                  GalleryExampleItemThumbnail(
                                    galleryExampleItem: galleryItems[1],
                                    onTap: () {
                                      open(context, 1);
                                    },
                                  ),
                                  GalleryExampleItemThumbnail(
                                    galleryExampleItem: galleryItems[2],
                                    onTap: () {
                                      open(context, 2);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),



                      ),

                      /// WebView
                      Container(
                        margin: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                        height: webViewHeadingHeight,
                        child: Row(
                            children:[
                              Container(
                                margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: const Text("Beschreibung",
                                  style: TextStyle(fontSize: 18, // Adjust the font size as needed
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ]
                        ),
                      ),
                      SizedBox(
                        height: webViewHeight ,
                        child:
                        WebViewWidget(controller: controller,),

                      ),





                    ],
                  ),
                ),
              ],
            );



          }
        }
          else{
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Loading..."),
                ],
              ),
            );
          }
          return Container();
          },
    ),

    );
    }
  }
