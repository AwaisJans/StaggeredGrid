import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_project/pagination/fermin/main/fermin_list_view_screen.dart';
import 'package:test_project/pagination/fermin/model/fermin_map_model/fermin_map_items.dart';

import '../../dashboard_items.dart';
import 'package:http/http.dart' as http;


class MyFerminGoogleMap extends StatefulWidget {
  @override
  _MyFerminGoogleMapState createState() => _MyFerminGoogleMapState();
}

class _MyFerminGoogleMapState extends State<MyFerminGoogleMap> {

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


  late double _height = 400;


  LatLng coordinate1 = LatLng(0, 0);


  late GoogleMapController mapController;

  LatLng loc1 = const LatLng(34.022723637768, 71.52425824981451);

  bool isFullScreen = false;

  Future<FerminMapItems> fetchAlbum() async {

    final response = await http.get(Uri.parse("https://www.empfingen.de/index.php?id=265&baseColor=2727278&baseFontSize=14"
        "&action=getFirmaMarkers"));

    if (response.statusCode == 200) {

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text("got map items"),
      // ));


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
  final List<Marker> _markers = <Marker>[
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(33.9984521, 71.5380679),
        infoWindow: InfoWindow(
          title: 'My Position',
        )
    ),
  ];

  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }




  @override
  Widget build(BuildContext context) {

    Set<Marker> markers = Set<Marker>.from([
      Marker(
        markerId: MarkerId("marker_1"),
        position: LatLng(37.7749, -122.4194),
        infoWindow: InfoWindow(
          title: "Marker Title",
          snippet: "Marker Snippet",
        ),
      ),
    ]);

    return FutureBuilder<FerminMapItems>(
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
              for (int i = 0; i < coordinates.length; i++) {
                markers.add(
                  Marker(
                    markerId: MarkerId("marker_$i"),
                    position: coordinates[i],
                    infoWindow: InfoWindow(
                      title: "Marker $i",
                      snippet: "Coordinates: ${coordinates[i]}",
                    ),
                  ),
                );
              }
              coordinate1 = coordinates[0];


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
                                  child:GoogleMap( //Map widget from google_maps_flutter package
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
                                      initialCameraPosition: CameraPosition( //innital position in map
                                        target: coordinate1, //initial position
                                        zoom: 15.0, //initial zoom level
                                      ),
                                      // initialCameraPosition: _kGoogle,
                                      markers: markers,
                                      onMapCreated: (controller) {
                                        mapController = controller;
                                        _controller.complete(controller);
                                      }
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

                                                    // markers.add(
                                                    //   Marker(
                                                    //     markerId: MarkerId("marker_235"),
                                                    //     position: currentCoordinate,
                                                    //     infoWindow: InfoWindow(
                                                    //       title: "Marker jan",
                                                    //       snippet: "Coordinates:$currentCoordinate",
                                                    //     ),
                                                    //   ),
                                                    // );
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
    );



  }
}

