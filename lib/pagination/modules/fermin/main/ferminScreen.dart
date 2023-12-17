
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/pagination/modules/fermin/main/fermin_popup_next_page.dart';
import 'package:test_project/pagination/configs/app_config.dart';
import 'package:test_project/pagination/configs/default_config.dart';
import 'package:test_project/pagination/extensions/color_hex.dart';
import 'package:test_project/pagination/modules/fermin/main/fermin_item_details.dart';
import 'package:test_project/pagination/modules/fermin/model/ferminListViewModel/fermin_items.dart';
import 'package:test_project/pagination/modules/fermin/model/fermin_map_model/fermin_map_items.dart';
import 'package:test_project/pagination/modules/fermin/model/marker_popup_model/marker_popup_model.dart';
import 'package:test_project/pagination/modules/news/main/newsScreen.dart';
import 'package:test_project/pagination/modules/news/main/news_details_screen.dart';
import 'package:test_project/pagination/modules/news/models/filter_model/filter_items.dart';

import 'package:test_project/pagination/modules/fermin/info_window/edge.dart';
import 'package:test_project/pagination/modules/fermin/info_window/triangle.dart';

import '../../dashboard/model/dashboard_items.dart';


class ferminListView extends StatefulWidget { /// stateful widget

  final Dashboard dashboardSingleFetchItem;

  ferminListView({super.key, required this.dashboardSingleFetchItem});

  @override
  _ferminListViewState createState() => _ferminListViewState(this.dashboardSingleFetchItem);
}

class _ferminListViewState extends State<ferminListView> {  /// state widget

  final Dashboard dashboardSingleFetchItem;
  _ferminListViewState(this.dashboardSingleFetchItem);

  final testItems = <String>[
    'Packing & Unpacking',
    'Cleaning',
    'Painting',
  ];
  ScrollController scrollController = ScrollController();

  bool isLoadingMore = false;
  int _limit = 10;
  int _startLimit = 0;

  bool noMoreItems = false;

  List<Fermin> ferminItemsArray = [];
  late String urlKategory = "";

  List<String> urlsPop = [];

  void fetchData(startLimit) async {
    setState(() {
      isLoadingMore = true;
    });
    var beforeCount = ferminItemsArray.length;
    var response;
    if (isFilterActivated) {
      String urlFiltered = "https://www.empfingen.de/index.php?id=265&baseColor=2727278&baseFontSize=14"
          "&action=getFirmaItems&$urlKategory&volltext=${enteredText}"
          "&limitStart=$_startLimit&limitAmount=$_limit";
      response = await http.get(Uri.parse(urlFiltered));
      print("true");
    } else {
      String urlUnFiltered =
          "https://www.empfingen.de/index.php?id=265&baseColor=2727278&baseFontSize=14&action=getFirmaItems&"
          "limitStart=$_startLimit&limitAmount=$_limit";
      response = await http.get(Uri.parse(urlUnFiltered));
      print("false");
    }
    print("checkingFilterStatusASYNC${isFilterActivated.toString()}");
    bool newbool = isFilterActivated;
    if (newbool) {
      String urlFiltered = "https://www.empfingen.de/index.php?id=265&baseColor=2727278&baseFontSize=14"
          "&action=getFirmaItems&$urlKategory&volltext=${enteredText}"
          "&limitStart=$_startLimit&limitAmount=$_limit";
      response = await http.get(Uri.parse(urlFiltered));
      print("newbool-true");
      print("newCategory$urlKategory");
    }
    else {
      String urlUnFiltered =
          "https://www.empfingen.de/index.php?id=265&baseColor=2727278&baseFontSize=14&action=getFirmaItems&"
          "limitStart=$_startLimit&limitAmount=$_limit";
      response = await http.get(Uri.parse(urlUnFiltered));
      print("newbool-false");
    }
    FerminItems newsItemsClass = FerminItems.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
    ferminItemsArray = ferminItemsArray + newsItemsClass.fermin;
    int localOffset = _startLimit + _limit;
    var afterCount = ferminItemsArray.length;
    setState(() {
      ferminItemsArray;
      isLoadingMore = false;
      _startLimit = localOffset;
      if (beforeCount == afterCount) {
        noMoreItems = true;
      }
    });
  }

  void handleNext() {
    scrollController.addListener(() async {
      if (isLoadingMore) return;
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        fetchData(_startLimit);
      }
    });
  }
// ------> Filter Variables
  List<Filters> newsFilterItemsArray = [];
  List<Filters> Sample = [];
  void fetchFilterData() async {
    final response =
    await http.get(Uri.parse("https://www.empfingen.de/index.php?id="
        "265&baseColor=2727278&baseFontSize=14&action=getFirmaKategories"));

    // We are using same model for filtering news and fermin items
    NewsFilterItems newsFilterItemsClass = NewsFilterItems.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);

    newsFilterItemsArray = newsFilterItemsArray + newsFilterItemsClass.filters;
  }
  List<bool> selectedItems = List.generate(18, (index) => false);
  List<String> selectedItemsId = List.generate(18, (index) => "");
  TextEditingController textEditingController = TextEditingController();
  String enteredText = "";
  bool isFilterActivated = false;
  String KATEGORY_PREFS = "categories";
  @override
  void dispose() {
    textEditingController.dispose();
    _customInfoWindowController.dispose();
    super.dispose();
  }
  String searchText = "";
  bool _counselor = false;
  bool get counselor => _counselor;
  void setCounselor(bool counselor) {
    _counselor = counselor;
  }
  void performDelayedSetState() {
    // Perform any actions you need before changing the state

    // Delayed setState after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        // Change the state (e.g., update a boolean variable)
        isFilterActivated = !counselor;
        saveBooleanValue(isFilterActivated);
      });

      // Perform any actions after changing the state if needed
    });
  }
  Future<void> _reload(var value) async {}
  bool allFalse = false;
  bool allTextFalse = false;
  // -----------> Map Variables
  late double _height = 400;
  late GoogleMapController mapController;
  LatLng loc1 = const LatLng(34.022723637768, 71.52425824981451);
  bool isFullScreen = false;
  // Method to fetch markers
  Future<FerminMapItems> fetchAlbum() async {
    String urlMap = "";
    if (isFilterActivated){
      urlMap ="https://www.empfingen.de/index.php?id=265&baseColor=2727278&baseFontSize=14&action=getFirmaMarkers&$urlKategory&volltext=${enteredText}"
          "&limitStart=$_startLimit&limitAmount=$_limit";
    }else{
      // urlMap ="https://www.empfingen.de/index.php?id=265&baseColor=2727278&baseFontSize=14&action=getFirmaMarkers";
      // urlMap ="https://www.heroldstatt.de/index.php?id=374&baseColor=005398&baseFontSize=14&action=getFirmaMarkers";
      // urlMap ="https://www.kupferzell.de/index.php?id=327&baseColor=2727278&baseFontSize=14&action=getFirmaMarkers";
      // urlMap ="https://www.vellberg.de/index.php?id=483&baseColor=D00218&baseFontSize=15&action=getFirmaMarkers";
      // urlMap ="https://www.mainhardt.de/index.php?id=521&baseColor=D00218&baseFontSize=15&action=getFirmaMarkers";
      urlMap ="https://www.beuren.de/index.php?id=619&baseColor=D00218&baseFontSize=15&action=getFirmaMarkers";
    }
    final response = await http.get(Uri.parse(urlMap));
    if (response.statusCode == 200) {
      return FerminMapItems.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {

      throw Exception('Failed to load album');
    }
  }
  List<LatLng> coordinates = [ // Chicago
    // Add more coordinates as needed
  ];
  MapType currentMapType = MapType.normal;
  Completer<GoogleMapController> _controller = Completer();
  // on below line we have specified camera position
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(20.42796133580664, 80.885749655962),
    zoom: 14.4746,
  );
  // on below line we have created the list of markers
  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }
  CameraPosition createInitialCameraPosition() {
    if (coordinates.isNotEmpty) {
      return CameraPosition(
        target: coordinates[0],
        zoom: 15.0,
      );
    } else {
      // Default coordinates if the list is empty
      return const CameraPosition(
        target: LatLng(48.39503446981762, 8.699648380279541), // Default to San Francisco
        zoom: 10.0,
      );
    }
  }


  void _showDialog(int index) async{
    LatLng location = coordinates[index];
    String urlPop = urlsPop[index];

    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(urlPop.toString())));
    // bool isLoading = false;

    _customInfoWindowController.addInfoWindow!(
      Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.all(16.0),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(), // Loading indicator
                SizedBox(height: 16.0),
                Text('Loading...'), // Loading text
              ],
            ),
          ),
          Triangle.isosceles(
            edge: Edge.BOTTOM,
            child: Container(
              color: Colors.white,
              width: 20.0,
              height: 10.0,
            ),
          ),
        ],
      ),
      location!,
    );


    try {
      final response = await http.get(Uri.parse(urlPop));
      if (response.statusCode == 200) {
        dataList.clear();
        final Map<String, dynamic> jsonData = json.decode(response.body);
        dataList.add(jsonData);
        Map<String, dynamic> jsonData1 = dataList[0];
        PopupItems items = PopupItems.fromJson(jsonData1);
        _customInfoWindowController.addInfoWindow!(
          Column(
            children:[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child:
                Wrap(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => popupDetailedScreen(items.singleItem!.urlDetails!)));
                      },
                      child:Row(
                        children: [
                          Container(
                            margin:const EdgeInsets.only(left: 20,top: 20,bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 220,
                                  child:
                                  Text(items.singleItem!.bezeichnung!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),maxLines: 2,overflow: TextOverflow.ellipsis,

                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  width: 220,
                                  child:
                                  Text(items.singleItem!.strasse!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13),maxLines: 1,overflow: TextOverflow.ellipsis,

                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  width: 220,
                                  child:
                                  Text("${items.singleItem!.plz!} ${items.singleItem!.ort!}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13),maxLines: 1,
                                  ),
                                ),

                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 18.0,
                            width: 18.0,
                            child:
                            Icon(Icons.arrow_back_ios,color: Colors.black,),
                            // onPressed: () {
                            //   // Navigator.of(context).push(MaterialPageRoute(builder: (context) => popupDetailedScreen()));
                            // },

                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Triangle.isosceles(
                edge: Edge.BOTTOM,
                child: Container(
                  color: Colors.white,
                  width: 20.0,
                  height: 10.0,
                ),
              ),
            ],

          ),

          location,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("failed to load data")));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Internet Issue")));
    }
  }

  @override
  void initState() {

    super.initState();
    fetchData(_startLimit);
    handleNext();
    fetchFilterData();
    retrieveList();
    loadStringValue(KATEGORY_PREFS);
    loadBooleanValue();
  }
  // ========================== Popup Code ==========================
  List<Map<String, dynamic>> dataList = [];


  getJsonString(String apiUrl) async{

  }
  CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();


  @override
  Widget build(BuildContext context) {

    Set<Marker> markers = <Marker>{
    };

    print("popupItemsArray$dataList");


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        /// Title Name
        title: const Text(
          "Fermin Example",
          style: TextStyle(
            color: Colors.black,
          ),
        ),

        /// Back Button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color.fromRGBO(17, 93, 165, 1),
          onPressed: () {
            saveBooleanValue(false);
            selectedItems = List.generate(
                newsFilterItemsArray.length,
                    (index) => false);
            storeList(selectedItems);
            textEditingController.clear();
            urlKategory = "";
            saveStringValue(KATEGORY_PREFS, urlKategory);

            Navigator.of(context)
                .pop();
          },
        ),

        actions: [
          GestureDetector(
            onTap: () {
              if (newsFilterItemsArray.isNotEmpty){
                dialogCode();
              }
              else{
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:  Text("No Filters Available"),
                ));
                // don't open it
              }
            }, // Image tapped
            child: Container(
              margin: EdgeInsets.all(8),
              height: 40,
              width: 70,
              child: SvgPicture.asset(
                'assets/images/search.svg',
                color: Color.fromRGBO(17, 93, 165, 1),
                alignment: Alignment.topRight,
              ),
            ),
          )
        ],
        /// Search Button

      ),
      backgroundColor: Colors.grey,

      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [

//      Header  -----------------> Google Map
            SliverToBoxAdapter(

              child:Column(
                children: [
                  Visibility(
                    visible: isFilterActivated,
                    // Invert the condition to control visibility
                    child: Container(
                      height: 40,
                      color: const Color.fromRGBO(17, 93, 165, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(left: 50.0),
                                child: Text(
                                  'Filter is Activated',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.white, // Set cross color to white
                            ),
                            onPressed: () {
                              setState(() {
                                saveBooleanValue(false);
                                selectedItems = List.generate(
                                    newsFilterItemsArray.length,
                                        (index) => false);
                                storeList(selectedItems);
                                textEditingController.clear();
                                // storeList(selectedItemsId);
                                print("khali nade$urlKategory");
                                urlKategory = "";
                                saveStringValue(KATEGORY_PREFS, urlKategory);
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                    builder: (context) => ferminListView(dashboardSingleFetchItem:dashboardSingleFetchItem))).
                                    then((value) => _reload(value));
                              });
                              // Add any onPressed functionality here
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    child:   FutureBuilder<FerminMapItems>(
                        future: fetchAlbum(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }
                            if (snapshot.hasData) {
                              List<fermanMapItem> items = snapshot.data!.ferminMap;
                              int item_length = items.length;
                              for(int i=0;i<=item_length;i++){
                                if (i < item_length){
                                  fermanMapItem item = items[i];

                                  double lat = double.parse(item.lat!);
                                  double lng = double.parse(item.lng!);

                                  coordinates.add(LatLng(lat, lng));

                                }
                              }

                              for (int i = 0; i <= item_length; i++) {
                                if (i < item_length) {
                                  fermanMapItem item = items[i];

                                  urlsPop.add(item.urlPopUp!);
                                }
                              }

                              print("urlsPop$urlsPop");

                              for (int i = 0; i < coordinates.length; i++) {
                                markers.add(
                                  Marker(
                                      // markerId: markerId,
                                      markerId: MarkerId(i.toString()),
                                      position: coordinates[i],
                                      // infoWindow: InfoWindow(
                                      //   title: "Marker $i",
                                      //   snippet: "Coordinates: ${coordinates[i]}",
                                      // ),
                                      onTap: (){
                                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(i.toString())));
                                        _showDialog(i);

                                      }
                                  ),
                                );
                              }

                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  return Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            height:_height,
                                            child:  ClipRRect(
                                              borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(0),
                                                  topRight: Radius.circular(0),
                                                  bottomRight: Radius.circular(50),
                                                  bottomLeft: Radius.circular(50)),
                                              child:Align(
                                                alignment: Alignment.bottomRight,
                                                heightFactor: 1.0,
                                                widthFactor: 2.5,
                                                child: AnimatedContainer(
                                                  duration: Duration(milliseconds: 500),
                                                  width: double.infinity,
                                                  height: _height,
                                                  child:

                                                  Stack(
                                                    children: <Widget>[
                                                      GoogleMap( //Map widget from google_maps_flutter package
                                                        zoomGesturesEnabled: true, //enable Zoom in, out on map
                                                        tiltGesturesEnabled: true,
                                                        mapType: currentMapType,
                                                        myLocationEnabled: true, // Enable the "My Location" button
                                                        scrollGesturesEnabled: true,
                                                        gestureRecognizers:
                                                        <Factory<OneSequenceGestureRecognizer>>{
                                                          Factory<OneSequenceGestureRecognizer>(
                                                                () => EagerGestureRecognizer(),
                                                          ),
                                                        },
                                                        onTap: (position) {
                                                          _customInfoWindowController
                                                              .hideInfoWindow!();
                                                          // dataList.clear();
                                                        },
                                                        initialCameraPosition: createInitialCameraPosition(),
                                                        // initialCameraPosition: _kGoogle,
                                                        markers: markers,
                                                        onMapCreated: (controller) {
                                                          mapController = controller;
                                                          _controller.complete(controller);
                                                          _customInfoWindowController
                                                              .googleMapController =
                                                              controller;
                                                        },
                                                        onCameraMove: (position) {
                                                          // setState(() {
                                                          //   _manager.onCameraMove;
                                                          // });
                                                          _customInfoWindowController
                                                              .onCameraMove!();
                                                        },
                                                        onCameraIdle: () {
                                                          // setState(() {
                                                          //   _manager.updateMap();
                                                          // });
                                                        },
                                                      ),
                                                      CustomInfoWindow(
                                                        controller:
                                                        _customInfoWindowController,
                                                        height: MediaQuery.of(context).size.height *0.19,
                                                        width: 270,
                                                        offset: 20,
                                                      ),
                                                    ],
                                                  ),

                                                ),
                                              ),
                                            ),
                                          ),

                                          Positioned(
                                            right: 20.0, // Adjust the top position as needed
                                            top: 20.0, // Adjust the left position as needed
                                            child: Container(
                                                alignment: Alignment.topRight,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.2),
                                                      spreadRadius: 2,
                                                      blurRadius: 4,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child:  Column(
                                                  children: [
                                                    Container(
                                                      height:170,
                                                      width: 50,
                                                      child:ListView(
                                                        children:
                                                        ListTile.divideTiles( //
                                                            context: context,
                                                            tiles: [
                                                              ListTile(
                                                                title: const Center(child:Icon(
                                                                  Icons.more_vert, // Calendar icon
                                                                  color: Color.fromRGBO(6, 43, 105, 1), //
                                                                ),),
                                                                onTap: (){
                                                                  showModalBottomSheet(
                                                                    context: context,
                                                                    barrierColor: Colors.black.withAlpha(1),
                                                                    backgroundColor: Colors.transparent,
                                                                    builder: (BuildContext context) {
                                                                      return Container(

                                                                        margin: EdgeInsets.all(10),
                                                                        decoration: const BoxDecoration(
                                                                          color: Color.fromRGBO(209, 205, 208, 1.0),
                                                                          borderRadius: BorderRadius.only(
                                                                            topLeft: Radius.circular(15.0),
                                                                            topRight: Radius.circular(15.0),
                                                                            bottomRight: Radius.circular(15.0),
                                                                            bottomLeft: Radius.circular(15.0),
                                                                          ),
                                                                        ),
                                                                        height: 170.0,
                                                                        child: ListView(
                                                                          children:
                                                                          ListTile.divideTiles( //
                                                                              context: context,
                                                                              tiles: [
                                                                                ListTile(
                                                                                  title: const Text('Standard',
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                  onTap: (){
                                                                                    setState(() {
                                                                                      currentMapType = MapType.terrain;
                                                                                    });

                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                ),
                                                                                ListTile(
                                                                                  title: const Text('Satelite',
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                  onTap: (){
                                                                                    setState(() {
                                                                                      currentMapType = MapType.satellite;
                                                                                    });

                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                ),
                                                                                ListTile(
                                                                                  title: const Text('Hybrid',
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                  onTap: (){
                                                                                    setState(() {
                                                                                      currentMapType = MapType.hybrid;
                                                                                    });



                                                                                    Navigator.pop(context);
                                                                                  },

                                                                                ),
                                                                              ]
                                                                          ).toList(),

                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                              ListTile(
                                                                title:  Icon(isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                                                                  color: Color.fromRGBO(6, 43, 105, 1),
                                                                ),
                                                                onTap: (){
                                                                  setState(() {
                                                                    isFullScreen = !isFullScreen;
                                                                  });
                                                                  if (isFullScreen){
                                                                    _height = 1000;
                                                                  }
                                                                  else{
                                                                    _height = 400;
                                                                  }
                                                                },
                                                              ),
                                                              ListTile(
                                                                title: const  Icon(
                                                                  Icons.send, // Calendar icon
                                                                  color: Color.fromRGBO(6, 43, 105, 1), //
                                                                ),
                                                                onTap: () {
                                                                  getUserCurrentLocation().then((value) {
                                                                    LatLng currentCoordinate = LatLng(value.latitude, value.longitude);
                                                                    mapController.animateCamera(
                                                                      CameraUpdate.newLatLngZoom(currentCoordinate, 20),
                                                                    );

                                                                  });
                                                                },

                                                              ),
                                                            ]
                                                        ).toList(),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            };
                          };
                          return const Center(
                          );
                        }
                    ),
                  ),
                ],
              ),


            ),

            ///     ListView  -----------------> Fermin Items
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  if (index == ferminItemsArray.length) {
                    return isLoadingMore
                        ? Container(
                      height: 200,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                        ),
                      ),
                    )
                        : Container();

                  }

                  Fermin item = ferminItemsArray[index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            ferminItemDetails(
                                ferminSingleFetchItem: item
                            )),
                      );
                    },


                    child:Card(
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                      // Adjust the margin values as needed
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(
                                  DefaultConfig.newsCardCornerRadius),
                              topLeft: Radius.circular(
                                  DefaultConfig.newsCardCornerRadius),
                              bottomLeft: Radius.circular(
                                  DefaultConfig.newsCardCornerRadius),
                              topRight: Radius.circular(
                                  DefaultConfig.newsCardCornerRadius)
                          ),
                          side: BorderSide(width: 1, color: HexColor(DefaultConfig.mainCollectionViewCellBorderColor))),

                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Column(
                          children:
                          [

                            Text(item.bezeichnung!,
                              style: const TextStyle(fontSize: 13,
                                  // Adjust the font size as needed
                                  color: Colors.black),
                            ),

                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.location_city, // Calendar icon
                                    color:
                                    Colors.grey, //
                                  ),

                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        15, 0, 0, 0),
                                    //apply padding to all four sides
                                    child: Text(
                                      item.strasse! + " - " + item.plz! +
                                          " " + item.ort!,
                                      style: const TextStyle(fontSize: 13,
                                          // Adjust the font size as needed
                                          color: Colors.grey),
                                    ),
                                  ),

                                ]
                            ),


                            Align(
                              alignment: Alignment.center,
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
                                          style: TextStyle(
                                              fontSize: 10, color: Colors.white),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                      ),
                    ),

                  );

                },

                childCount: ferminItemsArray.length+1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Search Dialog Code
  void dialogCode(){

    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          body: Container(
            margin: const EdgeInsets.only(
                bottom: 0, left: 0, right: 0, top: 30),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(241, 241, 249, 1),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),

            child:
            StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  Row(
                    children: [
                      /// Finish Button
                      Expanded(
                        child: ListTile(
                          title: const Text('Finish',
                              style: TextStyle(
                                color:
                                Color.fromRGBO(17, 93, 165, 1),
                              )),
                          onTap: () async
                          {
                            searchText = textEditingController.text;

                            print('checked items$selectedItems');
                            print(
                                'checked itemsId$selectedItemsId');
                            print('Entered Text: ${enteredText}');

                            setState(() {
                              // isFilterActivated = true;

                              // Check if each item in the list is empty using item.equals("")
                              bool allItemsEmpty = true;
                              Set<String> uniqueItems = {};
                              // retrieveList();


                              // for (String item in selectedItemsId) {
                              //   print("new->$item");
                              //   if (item == "") {
                              //     // If any item is not empty, set the flag to false and break the loop
                              //     allItemsEmpty = false;
                              //     // uniqueItems
                              //     //     .add("&kategories[]=$item");
                              //   } else {
                              //     allItemsEmpty = true;
                              //     // strKategory = "&kategories[]=$item";
                              //     uniqueItems
                              //         .add("&kategories[]=$item");
                              //   }
                              // }


                              List<String> nonEmptyItems = selectedItemsId.where((item) => item.isNotEmpty).toList();

                              // Print the non-empty items
                              print("Non-empty items: $nonEmptyItems");
                              for (String item in nonEmptyItems) {

                                if (item == "") {
                                  // If any item is not empty, set the flag to false and break the loop
                                  allItemsEmpty = true;
                                  // uniqueItems
                                  //     .add("&kategories[]=$item");
                                } else {
                                  allItemsEmpty = false;
                                  // strKategory = "&kategories[]=$item";
                                  uniqueItems
                                      .add("&kategories[]=$item");
                                }
                              }


                              if (allItemsEmpty) {
                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(const SnackBar(
                                //   content: Text("empty"),
                                // ));
                                urlKategory = "";
                              } else {
                                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                //   content: Text("not empty"),
                                // ));
                                setState(() {
                                  urlKategory =
                                      uniqueItems.join("");
                                  print("khali nade$urlKategory");
                                  saveStringValue(KATEGORY_PREFS, urlKategory);

                                  if (uniqueItems.isEmpty) {
                                  } else {
                                    performDelayedSetState();
                                    showDialog(
                                        context: context,
                                        builder:
                                            (BuildContext context) {
                                          return const AlertDialog();
                                        }).then((value) {
                                      showDialog(
                                        // Second dialog open
                                        context: context,
                                        builder:
                                            (BuildContext context) {
                                          Future.delayed(
                                              const Duration(
                                                  seconds: 2), () {
                                            Navigator.of(context)
                                                .pop(true);
                                            Navigator.of(context)
                                                .pop(true);
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                builder: (context) => ferminListView(dashboardSingleFetchItem:dashboardSingleFetchItem)))
                                                .then((value) =>
                                                _reload(value));
                                          });
                                          return const AlertDialog(
                                            content: Column(
                                              mainAxisSize:
                                              MainAxisSize.min,
                                              children: [
                                                CircularProgressIndicator(),
                                                SizedBox(
                                                    height: 16.0),
                                                Text(
                                                    'Loading Items...'),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    });
                                  }
                                });
                              }
                            });

                            Navigator.pop(context);
                          },
                        ),
                      ),
                      /// Filter Text
                      Expanded(
                        child: ListTile(
                          title: const Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              'Filter',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                      /// Reset Button
                      Expanded(
                        child: Visibility(
                          maintainState: true,
                          visible: allFalse || allTextFalse,
                          child:
                          ListTile(
                            title: const Align(
                              alignment: Alignment.topRight,
                              child: Text('Reset',
                                  style: TextStyle(
                                    color: Color.fromRGBO(
                                        17, 93, 165, 1),
                                  )),
                            ),
                            onTap: () {
                              setState(() {
                                selectedItems = List.generate(
                                    newsFilterItemsArray.length,
                                        (index) => false);
                                textEditingController.clear();
                                saveBooleanValue(false);
                                // storeList(selectedItemsId);
                                setState(() {
                                  allFalse = false;
                                  allTextFalse = false;
                                  print(
                                      "${allFalse.toString()} and ${allTextFalse.toString()}");
                                });
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                            children: [
                              /// Search Text Heading
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: SizedBox(
                                  height: 30,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Full Text Search",
                                        style: TextStyle(
                                          color: Color.fromRGBO(95, 94, 97, 1),
                                          fontSize: 15,
                                          decoration: TextDecoration.none,
                                        )),
                                  ),
                                ),
                              ),
                              /// Search Box
                              Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: TextField(
                                    // controller: textEditingController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter search text',
                                      border: InputBorder
                                          .none, // Set the hint text
                                    ),
                                    onChanged: (text){
                                      enteredText = text;
                                      setState((){
                                        if (enteredText == "" || enteredText.isEmpty){
                                          allTextFalse = false;
                                          allFalse = false;
                                        }else{
                                          allTextFalse = true;
                                          allFalse = true;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              /// Categories Heading
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: SizedBox(
                                  height: 30,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Categories",
                                        style: TextStyle(
                                          color: Color.fromRGBO(95, 94, 97, 1),
                                          fontSize: 15,
                                          decoration: TextDecoration.none,
                                        )),
                                  ),
                                ),
                              ),
                              /// Filter List Appears here
                              ListView.separated(
                                itemCount: newsFilterItemsArray.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),// Allow the GridView to wrap its content
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                const Divider(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  Filters item = newsFilterItemsArray[index];


                                  return Container(
                                    color: Colors.white,
                                    child: ListTile(
                                      title: Text(item.bezeichnung.toString()),
                                      trailing: selectedItems[index]
                                          ? const Icon(Icons.check,
                                          color: Color.fromRGBO(17, 93, 165,
                                              1)) // Show check mark if selected
                                          : null,
                                      onTap: () {
                                        setState(() {
                                          // Toggle the selected state when tapped
                                          selectedItems[index] =
                                          !selectedItems[index];

                                          storeList(selectedItems);

                                          /// allfalse will be true if all values are false

                                          if (selectedItems[index]) {
                                            String id = item.id.toString();
                                            selectedItemsId[index] = id;
                                            // storeList(selectedItemsId);
                                            print(
                                                "id=>${urlKategory.toString()}");
                                            setState(() {
                                              allFalse = true;
                                              allTextFalse = true;
                                            });
                                          } else {
                                            selectedItemsId[index] = "";
                                            setState(() {
                                              if (selectedItems.every((element) =>
                                              element == false)) {
                                                allFalse = false;
                                                allTextFalse = false;
                                              }
                                            });
                                          }
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ]
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }
  /// SharedPrefs Method for saving and getting Booleans
  void loadBooleanValue() async {
    // Use SharedPreferencesHelper to get the boolean value without explicitly handling a Future
    bool value = await SharedPreferencesHelper.getBool('my_boolean_key1');
    setState(() {
      isFilterActivated = value;
      print('checked filter boolean${isFilterActivated.toString()}');
    });
  }
  void saveBooleanValue(bool value) async {
    // Use SharedPreferencesHelper to set the boolean value without explicitly handling a Future
    await SharedPreferencesHelper.setBool('my_boolean_key1', value);
    // Reload the boolean value
    loadBooleanValue();
  }
  /// SharedPrefs Method for saving and getting String Values
  Future<void> loadStringValue(String key) async {
    // Use SharedPreferencesHelper to get the boolean value without explicitly handling a Future
    urlKategory = await SharedPreferencesHelper.getStr(key);
  }
  /// SharedPrefs Method for saving and getting List
  void saveStringValue(String key,String value) async {
    // Use SharedPreferencesHelper to set the boolean value without explicitly handling a Future
    await SharedPreferencesHelper.setStr(key, value);
    // Reload the boolean value
    loadStringValue(key);
  }
  Future<void> storeList(List<bool> itemList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the list to a JSON string
    String itemListString = jsonEncode(itemList);

    // Store the JSON string in SharedPreferences
    prefs.setString('itemListKey1', itemListString);

    print('List stored in SharedPreferences');
  }
  /// Method for Refresh ListView
  Future<void> retrieveList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the JSON string from SharedPreferences
    String? itemListString = prefs.getString('itemListKey1');



    if (itemListString != null) {
      // Parse the JSON string to get the list directly as List<bool>
      // selectedItems = jsonDecode(itemListString).cast<bool>();
      print("newList$itemListString");

      // Remove square brackets and split the string by commas
      List<String> items = itemListString.substring(1, itemListString.length - 1).split(',');

      // Convert the string values to boolean
      List<bool> itemList = items.map((item) => item.trim() == 'true').toList();
      selectedItems = itemList ;

      // Display the result
      print("Converted List: $selectedItems");



      // selectedItems[i] = true;
      // selectedItemsId[i] = "107";

      /*
        "id": 107
        "id": 99
        "id": 118
        "id": 106
        "id": 113
        "id": 111
        "id": 110
        "id": 108
        "id": 109
        "id": 115
        "id": 100
        "id": 102
        "id": 105
        "id": 114
        "id": 117
        "id": 104
        "id": 101
        "id": 116
       */

      // print('Retrieved List: $selectedItems');
    } else {
      print('List not found in SharedPreferences');
    }
  }
  Future<void> _refresh() async {
    // Simulate a network request or any asynchronous operation
    await Future.delayed(Duration(seconds: 1));

    Navigator.of(context)
        .push(MaterialPageRoute(
        builder: (context) => ferminListView(dashboardSingleFetchItem:dashboardSingleFetchItem)))
        .then((value) => _reload(value));
  }
}

