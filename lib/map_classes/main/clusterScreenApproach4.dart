import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/map_classes/main/cluster_utils/place_model.dart';
import '../../pagination/fermin/model/fermin_map_model/fermin_map_items.dart';
import 'cluster_utils/map_helper.dart';
import 'cluster_utils/map_marker.dart';
import 'google_cluster/place.dart';

class ClusterView extends StatefulWidget {
  @override
  _ClusterViewState createState() => _ClusterViewState();
}

class _ClusterViewState extends State<ClusterView> {
  late double _height = 400;
  late GoogleMapController mapController;
  LatLng loc1 = const LatLng(34.022723637768, 71.52425824981451);
  bool isFullScreen = false;

  // Method to fetch markers
  Future<FerminMapItems> fetchAlbum() async {
    String
        // urlMap = "https://www.empfingen.de/index.php?id=265&baseColor=2727278&baseFontSize=14&action=getFirmaMarkers";
        // urlMap ="https://www.empfingen.de/index.php?id=265&baseColor=2727278&baseFontSize=14&action=getFirmaMarkers";
        // urlMap ="https://www.heroldstatt.de/index.php?id=374&baseColor=005398&baseFontSize=14&action=getFirmaMarkers";
        // urlMap ="https://www.kupferzell.de/index.php?id=327&baseColor=2727278&baseFontSize=14&action=getFirmaMarkers";
        // urlMap ="https://www.vellberg.de/index.php?id=483&baseColor=D00218&baseFontSize=15&action=getFirmaMarkers";
        urlMap =
        "https://www.mainhardt.de/index.php?id=521&baseColor=D00218&baseFontSize=15&action=getFirmaMarkers";
    final response = await http.get(Uri.parse(urlMap));

    if (response.statusCode == 200) {
      return FerminMapItems.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load album');
    }
  }

  List<LatLng> coordinates = [];
  MapType currentMapType = MapType.normal;

  // on below line we have created the list of markers
  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });

    // mapController = await googleMapController.future;

    return await Geolocator.getCurrentPosition();
  }

  // Set<Marker> markers = {};

  void animateTo(LatLng position, double zoom) async {
    // final p = CameraPosition(target: position, zoom: 18);
    CameraPosition cameraPosition = CameraPosition(target: position, zoom: zoom);
    // mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // GoogleMapController controller = await googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

  }
  //
  CameraPosition? createInitialPosition;


  /// cluster code

  Set<Marker> markers = {};
  // late Completer<GoogleMapController> googleMapController = Completer<GoogleMapController>();
  // late ClusterManager clusterManager;
  // List<PlaceModel> placeList = [
  //   PlaceModel(id:1, type: 1, name: "Example Place1", latLng: LatLng(38.417392, 27.163635)),
  //   PlaceModel(id:2, type: 0, name: "Example Place2", latLng: LatLng(38.429227, 27.203803)),
  //   PlaceModel(id:3, type: 1, name: "Example Place3", latLng: LatLng(38.444287, 27.187667)),
  //   PlaceModel(id:4, type: 0, name: "Example Place4", latLng: LatLng(38.468483, 27.174278)),
  //   PlaceModel(id:5, type: 1, name: "Example Place5", latLng: LatLng(38.447245, 27.250152)),
  //   PlaceModel(id:6, type: 0, name: "Example Place6", latLng: LatLng(38.477622, 27.212043)),
  //   PlaceModel(id:7, type: 1, name: "Example Place7", latLng: LatLng(38.446976, 27.230239)),
  //   PlaceModel(id:8, type: 0, name: "Example Place8", latLng: LatLng(38.482191, 27.213416)),
  //   PlaceModel(id:9, type: 1, name: "Example Place9", latLng: LatLng(38.449127, 27.201400)),
  //   PlaceModel(id:10, type: 1, name: "Example Place10", latLng: LatLng(38.467946, 27.215476)),
  //
  // ];


  // @override
  // void dispose() {
  //   googleMapController = Completer();
  //   super.dispose();
  // }

  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(38.445094, 27.214790),
    zoom: 10,
  );


  LatLng? currentCoordinate;

  @override
  void initState() {

    getUserCurrentLocation()
        .then((value) async {
      currentCoordinate =
      LatLng(
          value
              .latitude,
          value
              .longitude);
      // final p = CameraPosition(target: currentCoordinate, zoom: 18);
      // mapController.animateCamera(CameraUpdate.newCameraPosition(p));
      // mapController = await googleMapController.future;
    });

    // clusterManager = _initClusterManager();
    super.initState();
  }

  // ClusterManager _initClusterManager() {
  //   return ClusterManager<PlaceModel>(placeList, _updateMarkers,
  //       markerBuilder: markerBuilder);
  // }

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      this.markers = markers;
    });
  }

  // Future<Marker> Function(Cluster<PlaceModel>) get markerBuilder =>
  //         (cluster) async {
  //       return Marker(
  //         markerId: MarkerId(cluster.isMultiple ? cluster.getId() : cluster.items.single.id.toString()),
  //         position: cluster.location,
  //         onTap: (){
  //           if(cluster.isMultiple){
  //             // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("cluster")));
  //             animateTo(cluster.location, 14);
  //           }
  //           else{
  //             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("marker")));
  //           }
  //
  //         },
  //         icon: cluster.isMultiple
  //             ? await getMarkerBitmap(150,150,cluster.items.where((element) => element.type == 0).length,cluster.items.where((element) => element.type == 1).length,text: cluster.count.toString())
  //             : cluster.items.single.type == 0
  //             ? await bitmapDescriptorFromSvgAsset(
  //           context,
  //           "assets/red_location.svg",
  //           100,)
  //             : await bitmapDescriptorFromSvgAsset(
  //           context,
  //           "assets/blue_location.svg",
  //           100,),
  //         infoWindow: cluster.isMultiple
  //             ? InfoWindow()
  //             : InfoWindow(title: cluster.items.single.name),
  //       );
  //     };
  //
  // Future<BitmapDescriptor> getMarkerBitmap(int size, double size2, int typeZeroLength, int typeOneLength, {String? text}) async {
  //   if (kIsWeb) size = (size / 2).floor();
  //
  //   final PictureRecorder pictureRecorder = PictureRecorder();
  //   final Canvas canvas = Canvas(pictureRecorder);
  //   final Paint paint1 = Paint()..color = const Color(0xFF4051B5);
  //   final Paint paint2 = Paint()..color = Colors.white;
  //   final Paint paint3 = Paint()..color = Colors.red;
  //
  //   double degreesToRads(num deg) {
  //     return (deg * 3.14) / 180.0;
  //   }
  //
  //   int total = typeZeroLength + typeOneLength;
  //   var totalRatio = 2.09439666667 * 3;
  //   double percentageOfLength = (typeZeroLength / total);
  //   var resultRatio = totalRatio * percentageOfLength;
  //
  //   canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
  //   canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);
  //   canvas.drawCircle(Offset(size / 2, size / 2), size / 3.8, paint3);
  //   canvas.drawArc(const Offset(0, 0) & Size(size2, size2), degreesToRads(90.0), resultRatio, true, paint3);
  //   canvas.drawCircle(Offset(size / 2, size / 2), size / 3.2, paint2);
  //   if (text != null) {
  //     TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
  //     painter.text = TextSpan(
  //       text: text,
  //       style: TextStyle(fontSize: size / 3, color: Colors.black, fontWeight: FontWeight.normal),
  //     );
  //     painter.layout();
  //     painter.paint(
  //       canvas,
  //       Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
  //     );
  //   }
  //   final img = await pictureRecorder.endRecording().toImage(size, size);
  //   final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;
  //   return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  // }
  //
  //
  // Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
  //     BuildContext context,
  //     String assetName,
  //     double size,
  //     ) async {
  //   String svgString = await DefaultAssetBundle.of(context).loadString(assetName);
  //   DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, '');
  //   ui.Picture picture = svgDrawableRoot.toPicture(size: Size(size, size));
  //   ui.Image image = await picture.toImage(size.toInt(), size.toInt());
  //   ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  //   return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,

        /// Title Name
        title: const Text(
          "Cluster Example",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.grey,

      // body:

      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: FutureBuilder<FerminMapItems>(
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

                      // if (items.isNotEmpty) {
                      //   createInitialPosition = CameraPosition(
                      //       target: LatLng(double.parse(items[0].lat!),
                      //           double.parse(items[0].lng!)),
                      //       zoom: 10);
                      // } else {
                      //   // Default coordinates if the list is empty
                      //   createInitialPosition = const CameraPosition(
                      //     target: LatLng(48.39503446981762, 8.699648380279541),
                      //     zoom: 16, // Default to San Francisco
                      //   );
                      // }

                      // for (int i = 0; i <= items.length; i++) {
                      //   if (i < items.length) {
                      //     fermanMapItem item = items[i];
                      //     LatLng pos = LatLng(
                      //         double.parse(item.lat!), double.parse(item.lng!));
                      //     markers.add(
                      //       Marker(
                      //         markerId: MarkerId("marker_$i"),
                      //         position: pos,
                      //         onTap: (){
                      //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(item.bezeichnung!)));
                      //         }
                      //       ),
                      //     );
                      //   }
                      // }

                      // return StatefulBuilder(
                      //   builder: (BuildContext context, StateSetter setState) {
                          return Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: _height,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                          topRight: Radius.circular(0),
                                          bottomRight: Radius.circular(50),
                                          bottomLeft: Radius.circular(50)),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        heightFactor: 1.0,
                                        widthFactor: 2.5,
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 500),
                                          width: double.infinity,
                                          height: _height,
                                          child: Stack(
                                            children: <Widget>[
                                              // GoogleMap(
                                              //   //Map widget from google_maps_flutter package
                                              //   zoomGesturesEnabled: true,
                                              //   //enable Zoom in, out on map
                                              //   // tiltGesturesEnabled: true,
                                              //   // mapType: currentMapType,
                                              //   // myLocationEnabled: true,
                                              //   // // Enable the "My Location" button
                                              //   // scrollGesturesEnabled: true,
                                              //   // gestureRecognizers: <Factory<
                                              //   //     OneSequenceGestureRecognizer>>{
                                              //   //   Factory<
                                              //   //       OneSequenceGestureRecognizer>(
                                              //   //     () =>
                                              //   //         EagerGestureRecognizer(),
                                              //   //   ),
                                              //   // },
                                              //   // initialCameraPosition: createInitialPosition!,
                                              //   initialCameraPosition: initialCameraPosition!,
                                              //   markers: markers,
                                              //   onMapCreated:
                                              //       (GoogleMapController
                                              //           controller) {
                                              //     // googleMapController.complete(controller);
                                              //     mapController = controller;
                                              //     clusterManager.setMapId(1);
                                              //
                                              //       },
                                              //     onCameraMove: (position) {
                                              //       clusterManager.onCameraMove(position);
                                              //     },
                                              //     onCameraIdle: clusterManager.updateMap,
                                              // ),

                                              GoogleMap(
                                                initialCameraPosition: initialCameraPosition,
                                                markers: markers,
                                                onMapCreated: (GoogleMapController controller) async{
                                                  // googleMapController.complete(controller);
                                                  mapController = controller;
                                                  // clusterManager.setMapId(controller.mapId);
                                                },
                                                // onCameraMove: (position) {
                                                //   clusterManager.onCameraMove(position);
                                                // },
                                                // onCameraIdle: clusterManager.updateMap,
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 20.0,
                                    // Adjust the top position as needed
                                    top: 20.0,
                                    // Adjust the left position as needed
                                    child: Container(
                                        alignment: Alignment.topRight,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 170,
                                              width: 50,
                                              child: ListView(
                                                children: ListTile.divideTiles(
                                                    context: context,
                                                    tiles: [
                                                      ListTile(
                                                        title: const Center(
                                                          child: Icon(
                                                            Icons.more_vert,
                                                            color:
                                                                Color.fromRGBO(
                                                                    6,
                                                                    43,
                                                                    105,
                                                                    1), //
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                            context: context,
                                                            barrierColor: Colors
                                                                .black
                                                                .withAlpha(1),
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          209,
                                                                          205,
                                                                          208,
                                                                          1.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            15.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            15.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            15.0),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            15.0),
                                                                  ),
                                                                ),
                                                                height: 170.0,
                                                                child: ListView(
                                                                  children: ListTile
                                                                      .divideTiles(
                                                                          //
                                                                          context:
                                                                              context,
                                                                          tiles: [
                                                                        ListTile(
                                                                          title:
                                                                              const Text(
                                                                            'Standard',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              currentMapType = MapType.terrain;
                                                                            });

                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                        ListTile(
                                                                          title:
                                                                              const Text(
                                                                            'Satelite',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              currentMapType = MapType.satellite;
                                                                            });

                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                        ListTile(
                                                                          title:
                                                                              const Text(
                                                                            'Hybrid',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              currentMapType = MapType.hybrid;
                                                                            });

                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                      ]).toList(),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                      ListTile(
                                                        title: Icon(
                                                          isFullScreen
                                                              ? Icons
                                                                  .fullscreen_exit
                                                              : Icons
                                                                  .fullscreen,
                                                          color: Color.fromRGBO(
                                                              6, 43, 105, 1),
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            isFullScreen =
                                                                !isFullScreen;
                                                          });

                                                          if (isFullScreen) {
                                                            _height = 700;
                                                          } else {
                                                            _height = 400;
                                                          }
                                                        },
                                                      ),
                                                      ListTile(
                                                        title: const Icon(
                                                          Icons.send,
                                                          // Calendar icon
                                                          color: Color.fromRGBO(
                                                              6, 43, 105, 1), //
                                                        ),
                                                        onTap: () {

                                                          print("currentCoordinate$currentCoordinate");

                                                          CameraPosition cameraPosition = CameraPosition(target: currentCoordinate!, zoom: 16);

                                                          mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
                                                        },
                                                      ),
                                                    ]).toList(),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          );
                      //   },
                      // );
                    }
                  }

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
                }),
          )
        ],
      ),
    );
  }

  Future<String> getAddressFromCoordinates(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = place.street!;
        print("address$address");
        return address;
      } else {
        return 'No address found';
      }
    } catch (e) {
      return 'Error fetching address';
    }
  }
}
