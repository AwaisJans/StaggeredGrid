



import 'dart:math';

import 'package:contacts_service/contacts_service.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../news/main/image_picker_view.dart';
import '../model/ferminListViewModel/fermin_items.dart';


class ferminItemDetails extends StatefulWidget {
  final Fermin ferminSingleFetchItem;

  ferminItemDetails({super.key, required this.ferminSingleFetchItem});

  @override
  _ferminItemDetailsState createState() => _ferminItemDetailsState(this.ferminSingleFetchItem);

}

class _ferminItemDetailsState extends State<ferminItemDetails> {

  final Fermin ferminSingleFetchItem;

  _ferminItemDetailsState(this.ferminSingleFetchItem);

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

  @override
  void initState() {
    String? htmlContent = ferminSingleFetchItem.beschreibung.toString();
    super.initState();
    controller;
    if(htmlContent.isEmpty){
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


          _onHeightWebView(context).then((value) => setState((){
            webViewHeight = value as double;
            print('JavaScriptZecondzzzs ${webViewHeight.toString()}');

          }));

        },
      ));


      controller.loadHtmlString(htmlContent);
      print("htmlString"+htmlContent);

    }







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

  int position = 0;



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fermin"),
      ),
      backgroundColor: Colors.white, // Change the background color here

      body:
      ListView(
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
                    child: Text(ferminSingleFetchItem.bezeichnung!,

                            style: const TextStyle(fontSize: 28, // Adjust the font size as needed
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                         ),

                ),
              Row(
                children: [


                  InkWell(
                    onTap: () {
                      launch('tel:' + ferminSingleFetchItem.telefon.toString());
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
                      launch('mailto:' + ferminSingleFetchItem.email!);
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
                      launch(ferminSingleFetchItem.homepage!);
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

                Item phones = Item(value: ferminSingleFetchItem.telefon!,
                                  label: ferminSingleFetchItem.bezeichnung!
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
                          child: Text("${ferminSingleFetchItem.strasse!+" - "+ferminSingleFetchItem.plz!} "+ferminSingleFetchItem.ort!,
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
                          child: Text(ferminSingleFetchItem.telefon.toString(),
                            style: TextStyle(fontSize: 13, // Adjust the font size as needed
                                fontWeight: FontWeight.normal,
                                color: Colors.grey),
                          ),
                        ),
                      ]
                  ),
                ),
            Visibility(
              visible: ferminSingleFetchItem.email != "",
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
                          child:  Text(ferminSingleFetchItem.email.toString(),
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
                  visible: ferminSingleFetchItem.homepage != "",
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
                            child:  Text(ferminSingleFetchItem.homepage.toString(),
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
                      open(context, 0);
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),                      constraints: BoxConstraints.expand(
                            height: 300,
                          ),
                          child: Stack(
                            children: <Widget>[
                              PhotoViewGallery.builder(
                                scrollPhysics: const BouncingScrollPhysics(),
                                builder: (BuildContext context, int index) {
                                  String item = galleryItems[index].resource;
                                  return PhotoViewGalleryPageOptions(
                                    imageProvider: AssetImage(item),
                                    initialScale: PhotoViewComputedScale.contained,
                                    minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
                                    maxScale: PhotoViewComputedScale.covered * 4.1,
                                    heroAttributes: PhotoViewHeroAttributes(tag: index),
                                  );
                                },
                                backgroundDecoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                itemCount: galleryItems.length,
                                pageController: PageController(),
                              ),
                            ],
                          ),
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
      ),
    );
  }


  void _updatePosition(int posit) {
    setState(() => position = _validPosition(posit));
  }
  int _validPosition(int position) {
    if (position >= galleryItems.length) return 0;
    if (position < 0) return galleryItems.length - 1;
    return position;
  }
}



class GalleryExampleItem {
  GalleryExampleItem({
    required this.id,
    required this.resource,
    this.isSvg = false,
  });

  final String id;
  final String resource;
  final bool isSvg;
}

class GalleryExampleItemThumbnail extends StatelessWidget {
  const GalleryExampleItemThumbnail({
    Key? key,
    required this.galleryExampleItem,
    required this.onTap,
  }) : super(key: key);

  final GalleryExampleItem galleryExampleItem;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: galleryExampleItem.id,
          child: Image.asset(galleryExampleItem.resource, height: 80.0),
        ),
      ),
    );
  }
}









List<GalleryExampleItem> galleryItems = <GalleryExampleItem>[
  GalleryExampleItem(
    id: "tag1",
    resource: "assets/images/flower-1.jpeg",
  ),
  GalleryExampleItem(
    id: "tag3",
    resource: "assets/images/flower-2.jpeg",
  ),
  GalleryExampleItem(
    id: "tag4",
    resource: "assets/images/flower-3.jpeg",
  ),
];

void open(BuildContext context, final int index) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => GalleryPhotoViewWrapper(
        galleryItems: galleryItems,
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        initialIndex: index,
        scrollDirection:  Axis.horizontal,
      ),
    ),
  );
}


class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<GalleryExampleItem> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 30,top: 30),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context)
                          .pop();
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  margin: EdgeInsets.only(left: 30,top: 30),
                  child: Text(
                    "Image ${currentIndex + 1}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      decoration: null,
                    ),
                  ),
                )
              ],
            )

          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final GalleryExampleItem item = widget.galleryItems[index];
    return item.isSvg
        ? PhotoViewGalleryPageOptions.customChild(
      child: Container(
        width: 300,
        height: 300,
        child: SvgPicture.asset(
          item.resource,
          height: 200.0,
        ),
      ),
      childSize: const Size(300, 300),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    )
        : PhotoViewGalleryPageOptions(
      imageProvider: AssetImage(item.resource),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    );
  }
}
