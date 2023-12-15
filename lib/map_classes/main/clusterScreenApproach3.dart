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

// class ClusterView extends StatefulWidget {
//   @override
//   _ClusterViewState createState() => _ClusterViewState();
// }
//
// class _ClusterViewState extends State<ClusterView> {
//   late double _height = 400;
//   late GoogleMapController mapController;
//   LatLng loc1 = const LatLng(34.022723637768, 71.52425824981451);
//   bool isFullScreen = false;

  // Method to fetch markers
  Future<FerminMapItems> fetchAlbum() async {
    String
    // urlMap = "https://www.empfingen.de/index.php?id=265&baseColor=2727278&baseFontSize=14&action=getFirmaMarkers";
    // urlMap ="https://www.empfingen.de/index.php?id=265&baseColor=2727278&baseFontSize=14&action=getFirmaMarkers";
    // urlMap ="https://www.heroldstatt.de/index.php?id=374&baseColor=005398&baseFontSize=14&action=getFirmaMarkers";
    // urlMap ="https://www.kupferzell.de/index.php?id=327&baseColor=2727278&baseFontSize=14&action=getFirmaMarkers";
    // urlMap ="https://www.vellberg.de/index.php?id=483&baseColor=D00218&baseFontSize=15&action=getFirmaMarkers";
    urlMap ="https://www.mainhardt.de/index.php?id=521&baseColor=D00218&baseFontSize=15&action=getFirmaMarkers";
    final response = await http.get(Uri.parse(urlMap));

    if (response.statusCode == 200) {
      return FerminMapItems.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load album');
    }
  }

  // List<LatLng> coordinates = [];
//   MapType currentMapType = MapType.normal;
//   Completer<GoogleMapController> _controller = Completer();
//
//   // on below line we have specified camera position
//   static const CameraPosition _kGoogle = CameraPosition(
//     target: LatLng(20.42796133580664, 80.885749655962),
//     zoom: 14.4746,
//   );
//
//   // on below line we have created the list of markers
//   // created method for getting user current location
//   Future<Position> getUserCurrentLocation() async {
//     await Geolocator.requestPermission()
//         .then((value) {})
//         .onError((error, stackTrace) async {
//       await Geolocator.requestPermission();
//       print("ERROR" + error.toString());
//     });
//     return await Geolocator.getCurrentPosition();
//   }
//
//
//
//
// // -------------> Cluster Code
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//
//     _manager = ClusterManager<Place>(
//         itemsPlaces, _updateMarkers,
//         markerBuilder: _markerBuilder);
//   }
//
//   late ClusterManager _manager;
//
//
//   Set<Marker> markers = Set();
//
//   List<Place> itemsPlaces = [];
//
//
//
//   bool hasCodeRun = false;
//
//   void _updateMarkers(Set<Marker> markers) {
//     print('Updated ${markers.length} markers');
//     setState(() {
//       this.markers = markers;
//     });
//   }
//
//   Future<void> animateTo(LatLng position, double zoom) async {
//     // final c = await _controller.future;
//     await saveZoomLevel(zoom);
//     double retrievedZoomLevel = await getZoomLevel();
//     // setState(() {
//     final p = CameraPosition(target: position, zoom: retrievedZoomLevel);
//     mapController.animateCamera(CameraUpdate.newCameraPosition(p));
//     // });
//   }
//
//   Future<double> getZoomLevel() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getDouble('zoomLevel') ??
//         10.0; // Default zoom level if not found
//   }
//
//   Future<void> saveZoomLevel(double zoomLevel) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setDouble('zoomLevel', zoomLevel);
//   }
//
//   Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
//       (cluster) async {
//         return Marker(
//           markerId: MarkerId(cluster.getId()),
//           position: cluster.location,
//           // infoWindow: InfoWindow(title: 'Marker Title', snippet: 'This is a marker snippet'),
//           onTap: () {
//             print('---- $cluster');
//
//             cluster.isMultiple
//                 ? {
//                     animateTo(cluster.location, 19),
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("cluster")))
//                   }
//                 : {
//                     //// Marker pop up
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("marker")))
//
//                     // _showDialog() // You can show a dialog or any other widget here
//                   };
//
//             cluster.items.forEach((p) => print(p));
//           },
//           icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
//               text: cluster.isMultiple ? cluster.count.toString() : null),
//         );
//       };
//
//   Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
//     if (kIsWeb) size = (size / 2).floor();
//
//     final PictureRecorder pictureRecorder = PictureRecorder();
//     final Canvas canvas = Canvas(pictureRecorder);
//     final Paint paint1 = Paint()..color = Colors.orange;
//     final Paint paint2 = Paint()..color = Colors.white;
//
//     canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
//     canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
//     canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);
//
//     if (text != null) {
//       TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
//       painter.text = TextSpan(
//         text: text,
//         style: TextStyle(
//             fontSize: size / 3,
//             color: Colors.white,
//             fontWeight: FontWeight.normal),
//       );
//       painter.layout();
//       painter.paint(
//         canvas,
//         Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
//       );
//     } else {
//       return BitmapDescriptor.defaultMarker;
//     }
//
//     final img = await pictureRecorder.endRecording().toImage(size, size);
//     final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;
//
//     return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
//   }

  // ------------------------------------------------ Popup Marker Code




//   @override
//   Widget build(BuildContext context) {
//       return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//
//         /// Title Name
//         title: const Text(
//           "Cluster Example",
//           style: TextStyle(
//             color: Colors.black,
//           ),
//         ),
//       ),
//       backgroundColor: Colors.grey,
//       body: Column(
//         // mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//             child:  FutureBuilder<FerminMapItems>(
//                 future: fetchAlbum(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.done) {
//                     if (snapshot.hasError) {
//                       return Center(
//                         child: Text('Error: ${snapshot.error}'),
//                       );
//                     }
//                     if (snapshot.hasData) {
//                       List<fermanMapItem> items = snapshot.data!.ferminMap;
//
//
//                       for (int i = 0; i < items.length; i++) {
//                         itemsPlaces.add(
//                             Place(name: 'New Place $i', latLng:
//                             LatLng(double.parse(items[i].lat!),
//                                 double.parse(items[i].lng!))
//                             )
//                         );
//                       }
//
//                       List<LatLng> coordinatesList =
//                       itemsPlaces.map((place) => place.latLng).toList();
//
//                       print("coordinatesList${coordinatesList.length}");
//
//                       CameraPosition? createInitialPosition;
//
//                       if (items.isNotEmpty) {
//                         createInitialPosition = CameraPosition(
//                             target: LatLng(double.parse(items[0].lat!),
//                                 double.parse(items[0].lng!)),
//                             zoom: 10
//                         );
//                       } else {
//                         // Default coordinates if the list is empty
//                         createInitialPosition = const CameraPosition(
//                           target: LatLng(48.39503446981762, 8.699648380279541),
//                           zoom: 16, // Default to San Francisco
//                         );
//                       }
//
//
//
//                       if (!hasCodeRun) {
//                         // Your code to run only once
//
//                         _manager = ClusterManager<Place>(
//                             itemsPlaces, _updateMarkers,
//                             markerBuilder: _markerBuilder);
//
//                         // Set the flag to true after the code has run
//                         hasCodeRun = true;
//                         print("hasCodeRun$hasCodeRun");
//
//                         print("places-->${itemsPlaces}");
//
//
//
//                       }
//                       return StatefulBuilder(
//                         builder: (BuildContext context, StateSetter setState) {
//                           return Column(
//                             children: [
//                               Stack(
//                                 children: [
//                                   Container(
//                                     height: _height,
//                                     child: ClipRRect(
//                                       borderRadius: const BorderRadius.only(
//                                           topLeft: Radius.circular(0),
//                                           topRight: Radius.circular(0),
//                                           bottomRight: Radius.circular(50),
//                                           bottomLeft: Radius.circular(50)),
//                                       child: Align(
//                                         alignment: Alignment.bottomRight,
//                                         heightFactor: 1.0,
//                                         widthFactor: 2.5,
//                                         child: AnimatedContainer(
//                                           duration: Duration(milliseconds: 500),
//                                           width: double.infinity,
//                                           height: _height,
//                                           child: Stack(
//                                             children: <Widget>[
//                                               GoogleMap(
//                                                 //Map widget from google_maps_flutter package
//                                                 zoomGesturesEnabled: true,
//                                                 //enable Zoom in, out on map
//                                                 tiltGesturesEnabled: true,
//                                                 mapType: currentMapType,
//                                                 myLocationEnabled: true,
//                                                 // Enable the "My Location" button
//                                                 scrollGesturesEnabled: true,
//                                                 gestureRecognizers: <Factory<
//                                                     OneSequenceGestureRecognizer>>{
//                                                   Factory<
//                                                       OneSequenceGestureRecognizer>(
//                                                         () =>
//                                                         EagerGestureRecognizer(),
//                                                   ),
//                                                 },
//                                                 initialCameraPosition:
//                                                 createInitialPosition!,
//                                                 markers: markers,
//                                                 onMapCreated: (GoogleMapController
//                                                 controller) {
//                                                   mapController = controller;
//                                                   _controller
//                                                       .complete(controller);
//                                                   setState(() {
//                                                     _manager.setMapId(
//                                                         controller.mapId);
//                                                   });
//                                                 },
//                                                 onCameraMove: (position) {
//                                                   setState(() {
//                                                     _manager.onCameraMove;
//                                                   });
//
//                                                 },
//                                                 onCameraIdle: () {
//                                                   setState(() {
//                                                     _manager.updateMap();
//                                                   });
//                                                 },
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   // Positioned(
//                                   //   right: 20.0,
//                                   //   // Adjust the top position as needed
//                                   //   top: 20.0,
//                                   //   // Adjust the left position as needed
//                                   //   child: Container(
//                                   //       alignment: Alignment.topRight,
//                                   //       decoration: BoxDecoration(
//                                   //         color: Colors.white,
//                                   //         borderRadius:
//                                   //             BorderRadius.circular(8.0),
//                                   //         boxShadow: [
//                                   //           BoxShadow(
//                                   //             color:
//                                   //                 Colors.black.withOpacity(0.2),
//                                   //             spreadRadius: 2,
//                                   //             blurRadius: 4,
//                                   //             offset: Offset(0, 2),
//                                   //           ),
//                                   //         ],
//                                   //       ),
//                                   //       child: Column(
//                                   //         children: [
//                                   //           Container(
//                                   //             height: 170,
//                                   //             width: 50,
//                                   //             child: ListView(
//                                   //               children: ListTile.divideTiles(
//                                   //                   //
//                                   //                   context: context,
//                                   //                   tiles: [
//                                   //                     ListTile(
//                                   //                       title: const Center(
//                                   //                         child: Icon(
//                                   //                           Icons.more_vert,
//                                   //                           // Calendar icon
//                                   //                           color: Color.fromRGBO(
//                                   //                               6, 43, 105, 1), //
//                                   //                         ),
//                                   //                       ),
//                                   //                       onTap: () {
//                                   //                         showModalBottomSheet(
//                                   //                           context: context,
//                                   //                           barrierColor: Colors
//                                   //                               .black
//                                   //                               .withAlpha(1),
//                                   //                           backgroundColor:
//                                   //                               Colors
//                                   //                                   .transparent,
//                                   //                           builder: (BuildContext
//                                   //                               context) {
//                                   //                             return Container(
//                                   //                               margin: EdgeInsets
//                                   //                                   .all(10),
//                                   //                               decoration:
//                                   //                                   const BoxDecoration(
//                                   //                                 color: Color
//                                   //                                     .fromRGBO(
//                                   //                                         209,
//                                   //                                         205,
//                                   //                                         208,
//                                   //                                         1.0),
//                                   //                                 borderRadius:
//                                   //                                     BorderRadius
//                                   //                                         .only(
//                                   //                                   topLeft: Radius
//                                   //                                       .circular(
//                                   //                                           15.0),
//                                   //                                   topRight: Radius
//                                   //                                       .circular(
//                                   //                                           15.0),
//                                   //                                   bottomRight: Radius
//                                   //                                       .circular(
//                                   //                                           15.0),
//                                   //                                   bottomLeft: Radius
//                                   //                                       .circular(
//                                   //                                           15.0),
//                                   //                                 ),
//                                   //                               ),
//                                   //                               height: 170.0,
//                                   //                               child: ListView(
//                                   //                                 children: ListTile
//                                   //                                     .divideTiles(
//                                   //                                         //
//                                   //                                         context:
//                                   //                                             context,
//                                   //                                         tiles: [
//                                   //                                       ListTile(
//                                   //                                         title:
//                                   //                                             const Text(
//                                   //                                           'Standard',
//                                   //                                           textAlign:
//                                   //                                               TextAlign.center,
//                                   //                                         ),
//                                   //                                         onTap:
//                                   //                                             () {
//                                   //                                           setState(
//                                   //                                               () {
//                                   //                                             currentMapType =
//                                   //                                                 MapType.terrain;
//                                   //                                           });
//                                   //
//                                   //                                           Navigator.pop(
//                                   //                                               context);
//                                   //                                         },
//                                   //                                       ),
//                                   //                                       ListTile(
//                                   //                                         title:
//                                   //                                             const Text(
//                                   //                                           'Satelite',
//                                   //                                           textAlign:
//                                   //                                               TextAlign.center,
//                                   //                                         ),
//                                   //                                         onTap:
//                                   //                                             () {
//                                   //                                           setState(
//                                   //                                               () {
//                                   //                                             currentMapType =
//                                   //                                                 MapType.satellite;
//                                   //                                           });
//                                   //
//                                   //                                           Navigator.pop(
//                                   //                                               context);
//                                   //                                         },
//                                   //                                       ),
//                                   //                                       ListTile(
//                                   //                                         title:
//                                   //                                             const Text(
//                                   //                                           'Hybrid',
//                                   //                                           textAlign:
//                                   //                                               TextAlign.center,
//                                   //                                         ),
//                                   //                                         onTap:
//                                   //                                             () {
//                                   //                                           setState(
//                                   //                                               () {
//                                   //                                             currentMapType =
//                                   //                                                 MapType.hybrid;
//                                   //                                           });
//                                   //
//                                   //                                           Navigator.pop(
//                                   //                                               context);
//                                   //                                         },
//                                   //                                       ),
//                                   //                                     ]).toList(),
//                                   //                               ),
//                                   //                             );
//                                   //                           },
//                                   //                         );
//                                   //                       },
//                                   //                     ),
//                                   //                     ListTile(
//                                   //                       title: Icon(
//                                   //                         isFullScreen
//                                   //                             ? Icons
//                                   //                                 .fullscreen_exit
//                                   //                             : Icons.fullscreen,
//                                   //                         color: Color.fromRGBO(
//                                   //                             6, 43, 105, 1),
//                                   //                       ),
//                                   //                       onTap: () {
//                                   //                         setState(() {
//                                   //                           isFullScreen =
//                                   //                               !isFullScreen;
//                                   //                         });
//                                   //
//                                   //                         if (isFullScreen) {
//                                   //                           _height = 700;
//                                   //                         } else {
//                                   //                           _height = 400;
//                                   //                         }
//                                   //                       },
//                                   //                     ),
//                                   //                     ListTile(
//                                   //                       title: const Icon(
//                                   //                         Icons.send,
//                                   //                         // Calendar icon
//                                   //                         color: Color.fromRGBO(
//                                   //                             6, 43, 105, 1), //
//                                   //                       ),
//                                   //                       onTap: () {
//                                   //                         getUserCurrentLocation()
//                                   //                             .then((value) {
//                                   //                           LatLng
//                                   //                               currentCoordinate =
//                                   //                               LatLng(
//                                   //                                   value
//                                   //                                       .latitude,
//                                   //                                   value
//                                   //                                       .longitude);
//                                   //
//                                   //                           // markers.add(
//                                   //                           //   Marker(
//                                   //                           //     markerId: MarkerId("marker_235"),
//                                   //                           //     position: currentCoordinate,
//                                   //                           //     infoWindow: InfoWindow(
//                                   //                           //       title: "Marker jan",
//                                   //                           //       snippet: "Coordinates:$currentCoordinate",
//                                   //                           //     ),
//                                   //                           //   ),
//                                   //                           // );
//                                   //                           mapController
//                                   //                               .animateCamera(
//                                   //                             CameraUpdate
//                                   //                                 .newLatLngZoom(
//                                   //                                     currentCoordinate,
//                                   //                                     20),
//                                   //                           );
//                                   //                         });
//                                   //                       },
//                                   //                     ),
//                                   //                   ]).toList(),
//                                   //             ),
//                                   //           ),
//                                   //         ],
//                                   //       )),
//                                   // ),
//                                 ],
//                               ),
//                             ],
//                           );
//                         },
//                       );
//
//
//
//
//
//                       // for (int i = 0; i <= items.length; i++) {
//                       //   if (i < items.length) {
//                       //     fermanMapItem item = items[i];
//                       //     LatLng pos =  LatLng(double.parse(item.lat!),double.parse(item.lng!));
//                       //     markers.add(
//                       //       Marker(
//                       //           markerId: MarkerId("marker_$i"),
//                       //           position:pos,
//                       //
//                       //       ),
//                       //     );
//                       //   }
//                       // }
//
//
//                     }
//                   }
//
//                   return const Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircularProgressIndicator(),
//                         SizedBox(height: 16),
//                         Text("Loading..."),
//                       ],
//                     ),
//                   );
//                 }) ,
//           )
//
//         ],
//       ),
//     );
//   }
//
//   Future<String> getAddressFromCoordinates(LatLng latLng) async {
//     try {
//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
//
//       if (placemarks != null && placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];
//         String address = place.street!;
//         print("address$address");
//         return address;
//       } else {
//         return 'No address found';
//       }
//     } catch (e) {
//       return 'Error fetching address';
//     }
//   }
// }
