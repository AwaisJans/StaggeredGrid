
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'dart:ui' as ui;
import 'package:fluster/fluster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' ;
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
import 'package:test_project/map_classes/main/cluster_utils/place_model.dart';
import '../../pagination/fermin/model/fermin_map_model/fermin_map_items.dart';
import 'cluster_utils/map_helper.dart';
import 'cluster_utils/map_marker.dart';




// class ClusterView extends StatefulWidget {
//   @override
//   _ClusterViewState createState() => _ClusterViewState();
// }
//
// class _ClusterViewState extends State<ClusterView> {
//
//
//
//
//
//   // late double _height = 400;
//   // late GoogleMapController mapController;
//   // LatLng loc1 = const LatLng(34.022723637768, 71.52425824981451);
//   // bool isFullScreen = false;
//   // // Method to fetch markers
//   // Future<FerminMapItems> fetchAlbum() async {
//   //
//   //   String urlMap = "https://www.empfingen.de/index.php?id=265&baseColor=2727278&baseFontSize=14&action=getFirmaMarkers";
//   //   final response = await http.get(Uri.parse(urlMap));
//   //
//   //
//   //
//   //   if (response.statusCode == 200) {
//   //
//   //     return FerminMapItems.fromJson(
//   //         jsonDecode(response.body) as Map<String, dynamic>);
//   //   } else {
//   //     throw Exception('Failed to load album');
//   //   }
//   //
//   // }
//   // List<LatLng> coordinates = [];
//   // MapType currentMapType = MapType.normal;
//   // Completer<GoogleMapController> _controller = Completer();
//   // // on below line we have specified camera position
//   // static const CameraPosition _kGoogle = CameraPosition(
//   //   target: LatLng(20.42796133580664, 80.885749655962),
//   //   zoom: 14.4746,
//   // );
//   // // on below line we have created the list of markers
//   // // created method for getting user current location
//   // Future<Position> getUserCurrentLocation() async {
//   //   await Geolocator.requestPermission().then((value){
//   //   }).onError((error, stackTrace) async {
//   //     await Geolocator.requestPermission();
//   //     print("ERROR"+error.toString());
//   //   });
//   //   return await Geolocator.getCurrentPosition();
//   // }
//   // CameraPosition createInitialCameraPosition() {
//   //   if (coordinates.isNotEmpty) {
//   //     return CameraPosition(
//   //       target: coordinates[0],
//   //       zoom: 15.0,
//   //     );
//   //   } else {
//   //     // Default coordinates if the list is empty
//   //     return const CameraPosition(
//   //       target: LatLng(48.39503446981762, 8.699648380279541), // Default to San Francisco
//   //       zoom: 10.0,
//   //     );
//   //   }
//   // }
//
// // -------------> Cluster Code
//   final Completer<GoogleMapController> _mapController = Completer();
//
//   /// Set of displayed markers and cluster markers on the map
//   final Set<Marker> _markers = Set();
//
//   /// Minimum zoom at which the markers will cluster
//   final int _minClusterZoom = 0;
//
//   /// Maximum zoom at which the markers will cluster
//   final int _maxClusterZoom = 19;
//
//   /// [Fluster] instance used to manage the clusters
//   Fluster<MapMarker>? _clusterManager;
//
//   /// Current map zoom. Initial zoom will be 15, street level
//   double _currentZoom = 10;
//
//   /// Map loading flag
//   bool _isMapLoading = true;
//
//   /// Markers loading flag
//   bool _areMarkersLoading = true;
//
//   /// Url image used on normal markers
//   final String _markerImageUrl =
//       'https://img.icons8.com/office/150/000000/marker.png';
//
//   /// Color of the cluster circle
//   final Color _clusterColor = Colors.blue;
//
//   /// Color of the cluster text
//   final Color _clusterTextColor = Colors.white;
//
//   /// Example marker coordinates
//   final List<LatLng> _markerLocations = [
//     LatLng(41.147125, -8.611249),
//     LatLng(41.145599, -8.610691),
//     LatLng(41.145645, -8.614761),
//     LatLng(41.146775, -8.614913),
//     LatLng(41.146982, -8.615682),
//     LatLng(41.140558, -8.611530),
//     LatLng(41.138393, -8.608642),
//     LatLng(41.137860, -8.609211),
//     LatLng(41.138344, -8.611236),
//     LatLng(41.139813, -8.609381),
//   ];
//
//   /// Called when the Google Map widget is created. Updates the map loading state
//   /// and inits the markers.
//   void _onMapCreated(GoogleMapController controller) {
//     _mapController.complete(controller);
//
//     setState(() {
//       _isMapLoading = false;
//     });
//
//     _initMarkers();
//   }
//
//   /// Inits [Fluster] and all the markers with network images and updates the loading state.
//   void _initMarkers() async {
//     final List<MapMarker> markers = [];
//
//     for (LatLng markerLocation in _markerLocations) {
//       final BitmapDescriptor markerImage =
//       await MapHelper.getMarkerImageFromUrl(_markerImageUrl);
//
//       markers.add(
//         MapMarker(
//           id: _markerLocations.indexOf(markerLocation).toString(),
//           position: markerLocation,
//           icon: markerImage,
//           // onTap: {markerTap()},
//           // onTap2: {clusterTap(markerLocation)},
//         ),
//       );
//     }
//
//     _clusterManager = await MapHelper.initClusterManager(
//       markers,
//       _minClusterZoom,
//       _maxClusterZoom,
//     );
//
//     await _updateMarkers();
//   }
//
//   void clusterTap(LatLng position){
//     // animateTo(position, 19);
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//       content: Text("cluster"),
//     ));
//   }
//
//   void markerTap(){
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//       content: Text("marker"),
//     ));
//   }
//
//
//   Future<void> animateTo(LatLng position,double zoom) async {
//     final c = await _mapController.future;
//     final p = CameraPosition(target: position, zoom: zoom);
//     c.animateCamera(CameraUpdate.newCameraPosition(p));
//   }
//
//
//
//
//   /// Gets the markers and clusters to be displayed on the map for the current zoom level and
//   /// updates state.
//   Future<void> _updateMarkers([double? updatedZoom]) async {
//     if (_clusterManager == null || updatedZoom == _currentZoom) return;
//
//     if (updatedZoom != null) {
//       _currentZoom = updatedZoom;
//     }
//
//     setState(() {
//       _areMarkersLoading = true;
//     });
//
//     final updatedMarkers = await MapHelper.getClusterMarkers(
//       _clusterManager,
//       _currentZoom,
//       _clusterColor,
//       _clusterTextColor,
//       150,// size
//     );
//
//     _markers
//       ..clear()
//       ..addAll(updatedMarkers);
//
//     setState(() {
//       _areMarkersLoading = false;
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     // Set<Marker> markers = <Marker>{};
//
//
//
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Markers and Clusters Example'),
//       ),
//       body: Stack(
//         children: <Widget>[
//           // Google Map widget
//           Opacity(
//             opacity: _isMapLoading ? 0 : 1,
//             child: GoogleMap(
//               mapToolbarEnabled: true,
//               zoomGesturesEnabled: true,
//               myLocationButtonEnabled: true,
//               myLocationEnabled: true,
//               zoomControlsEnabled: true,
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(41.143029, -8.611274),
//                 zoom: _currentZoom,
//               ),
//               markers: _markers,
//               onMapCreated: (controller) => _onMapCreated(controller),
//               onCameraMove: (position) => _updateMarkers(position.zoom),
//
//
//             ),
//           ),
//
//           // Map loading indicator
//           Opacity(
//             opacity: _isMapLoading ? 1 : 0,
//             child: Center(child: CircularProgressIndicator()),
//           ),
//
//           // Map markers loading indicator
//           if (_areMarkersLoading)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.topCenter,
//                 child: Card(
//                   elevation: 2,
//                   color: Colors.grey.withOpacity(0.9),
//                   child: Padding(
//                     padding: const EdgeInsets.all(4),
//                     child: Text(
//                       'Loading',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//
//     // return Scaffold(
//     //   appBar: AppBar(
//     //     backgroundColor: Colors.white,
//     //     /// Title Name
//     //     title: const Text(
//     //       "Cluster Example",
//     //       style: TextStyle(
//     //         color: Colors.black,
//     //       ),
//     //     ),
//     //   ),
//     //   backgroundColor: Colors.grey,
//     //
//     //   body: Column(
//     //             children: [
//
//                     // FutureBuilder<FerminMapItems>(
//                     //     future: fetchAlbum(),
//                     //     builder: (context, snapshot) {
//                     //       if (snapshot.connectionState == ConnectionState.done) {
//                     //         if (snapshot.hasError) {
//                     //           return Center(
//                     //             child: Text('Error: ${snapshot.error}'),
//                     //           );
//                     //         }
//                     //         if (snapshot.hasData) {
//                     //
//                     //           List<fermanMapItem> items = snapshot.data!.ferminMap;
//                     //           int item_length = items.length;
//                     //           for(int i=0;i<=item_length;i++){
//                     //             if (i < item_length){
//                     //               fermanMapItem item = items[i];
//                     //
//                     //               double lat = double.parse(item.lat!);
//                     //               double lng = double.parse(item.lng!);
//                     //
//                     //               coordinates.add(LatLng(lat, lng));
//                     //             }
//                     //           }
//                     //
//                     //           // for(int i=0;i<coordinates.length;i++){
//                     //           //   placeList.add(PlaceModel(id:i, type: 1, name: "Example Place1",latLng:coordinates[i]));
//                     //           // }
//                     //
//                     //
//                     //
//                     //           // // Convert the PlaceModel list to JSON
//                     //           // List<Map<String, dynamic>> jsonList = placeList.map((place) => place.toJson()).toList();
//                     //           //
//                     //           // jsonList.forEach((item) {
//                     //           //   print("places-->${jsonEncode(item)}");
//                     //           //   // print("places-->${coordinates.length}");
//                     //           // });
//                     //
//                     //
//                     //           for (int i = 0; i < coordinates.length; i++) {
//                     //             markers.add(
//                     //               Marker(
//                     //                 markerId: MarkerId("marker_$i"),
//                     //                 position: coordinates[i],
//                     //                 infoWindow: InfoWindow(
//                     //                   title: "Marker $i",
//                     //                   snippet: "Coordinates: ${coordinates[i]}",
//                     //                 ),
//                     //               ),
//                     //             );
//                     //           }
//                     //
//                     //
//                     //         // _initMarkers();
//                     //
//                     //           // getAddressFromCoordinates(coordinates[0]);
//                     //
//                     //
//                     //           return StatefulBuilder(
//                     //             builder: (BuildContext context, StateSetter setState) {
//                     //
//                     //               return
//                     //                 Column(
//                     //                 children: [
//                     //                   Stack(
//                     //                     children: [
//                     //
//                     //
//                     //
//                     //
//                     //                       Container(
//                     //                         height:_height,
//                     //                         child:  ClipRRect(
//                     //                           borderRadius: const BorderRadius.only(
//                     //                               topLeft: Radius.circular(0),
//                     //                               topRight: Radius.circular(0),
//                     //                               bottomRight: Radius.circular(50),
//                     //                               bottomLeft: Radius.circular(50)),
//                     //                           child:Align(
//                     //                             alignment: Alignment.bottomRight,
//                     //                             heightFactor: 1.0,
//                     //                             widthFactor: 2.5,
//                     //                             child: AnimatedContainer(
//                     //                               duration: Duration(milliseconds: 500),
//                     //                               width: double.infinity,
//                     //                               height: _height,
//                     //                               child:GoogleMap( //Map widget from google_maps_flutter package
//                     //                                   zoomGesturesEnabled: true, //enable Zoom in, out on map
//                     //                                   tiltGesturesEnabled: true,
//                     //                                   mapType: currentMapType,
//                     //                                   myLocationEnabled: true, // Enable the "My Location" button
//                     //                                   scrollGesturesEnabled: true,
//                     //                                   gestureRecognizers:
//                     //                                   <Factory<OneSequenceGestureRecognizer>>{
//                     //                                     Factory<OneSequenceGestureRecognizer>(
//                     //                                           () => EagerGestureRecognizer(),
//                     //                                     ),
//                     //                                   },
//                     //                                   initialCameraPosition: createInitialCameraPosition(),
//                     //                                   // initialCameraPosition: _kGoogle,
//                     //                                   markers: markers,
//                     //
//                     //
//                     //
//                     //
//                     //                                   onMapCreated: (controller) {
//                     //                                     mapController = controller;
//                     //                                     _controller.complete(controller);
//                     //                                   }
//                     //                               ),
//                     //                             ),
//                     //                           ),
//                     //                         ),
//                     //                       ),
//                     //
//                     //                       Positioned(
//                     //                         right: 20.0, // Adjust the top position as needed
//                     //                         top: 20.0, // Adjust the left position as needed
//                     //                         child: Container(
//                     //                             alignment: Alignment.topRight,
//                     //                             decoration: BoxDecoration(
//                     //                               color: Colors.white,
//                     //                               borderRadius: BorderRadius.circular(8.0),
//                     //                               boxShadow: [
//                     //                                 BoxShadow(
//                     //                                   color: Colors.black.withOpacity(0.2),
//                     //                                   spreadRadius: 2,
//                     //                                   blurRadius: 4,
//                     //                                   offset: Offset(0, 2),
//                     //                                 ),
//                     //                               ],
//                     //                             ),
//                     //                             child:  Column(
//                     //                               children: [
//                     //                                 Container(
//                     //                                   height:170,
//                     //                                   width: 50,
//                     //                                   child:ListView(
//                     //                                     children:
//                     //                                     ListTile.divideTiles( //
//                     //                                         context: context,
//                     //                                         tiles: [
//                     //                                           ListTile(
//                     //                                             title: const Center(child:Icon(
//                     //                                               Icons.more_vert, // Calendar icon
//                     //                                               color: Color.fromRGBO(6, 43, 105, 1), //
//                     //                                             ),),
//                     //                                             onTap: (){
//                     //                                               showModalBottomSheet(
//                     //                                                 context: context,
//                     //                                                 barrierColor: Colors.black.withAlpha(1),
//                     //                                                 backgroundColor: Colors.transparent,
//                     //                                                 builder: (BuildContext context) {
//                     //                                                   return Container(
//                     //
//                     //                                                     margin: EdgeInsets.all(10),
//                     //                                                     decoration: const BoxDecoration(
//                     //                                                       color: Color.fromRGBO(209, 205, 208, 1.0),
//                     //                                                       borderRadius: BorderRadius.only(
//                     //                                                         topLeft: Radius.circular(15.0),
//                     //                                                         topRight: Radius.circular(15.0),
//                     //                                                         bottomRight: Radius.circular(15.0),
//                     //                                                         bottomLeft: Radius.circular(15.0),
//                     //                                                       ),
//                     //                                                     ),
//                     //                                                     height: 170.0,
//                     //                                                     child: ListView(
//                     //                                                       children:
//                     //                                                       ListTile.divideTiles( //
//                     //                                                           context: context,
//                     //                                                           tiles: [
//                     //                                                             ListTile(
//                     //                                                               title: const Text('Standard',
//                     //                                                                 textAlign: TextAlign.center,
//                     //                                                               ),
//                     //                                                               onTap: (){
//                     //                                                                 setState(() {
//                     //                                                                   currentMapType = MapType.terrain;
//                     //                                                                 });
//                     //
//                     //                                                                 Navigator.pop(context);
//                     //                                                               },
//                     //                                                             ),
//                     //                                                             ListTile(
//                     //                                                               title: const Text('Satelite',
//                     //                                                                 textAlign: TextAlign.center,
//                     //                                                               ),
//                     //                                                               onTap: (){
//                     //                                                                 setState(() {
//                     //                                                                   currentMapType = MapType.satellite;
//                     //                                                                 });
//                     //
//                     //                                                                 Navigator.pop(context);
//                     //                                                               },
//                     //                                                             ),
//                     //                                                             ListTile(
//                     //                                                               title: const Text('Hybrid',
//                     //                                                                 textAlign: TextAlign.center,
//                     //                                                               ),
//                     //                                                               onTap: (){
//                     //                                                                 setState(() {
//                     //                                                                   currentMapType = MapType.hybrid;
//                     //                                                                 });
//                     //
//                     //
//                     //
//                     //                                                                 Navigator.pop(context);
//                     //                                                               },
//                     //
//                     //                                                             ),
//                     //                                                           ]
//                     //                                                       ).toList(),
//                     //
//                     //                                                     ),
//                     //                                                   );
//                     //                                                 },
//                     //                                               );
//                     //                                             },
//                     //                                           ),
//                     //                                           ListTile(
//                     //                                             title:  Icon(isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
//                     //                                               color: Color.fromRGBO(6, 43, 105, 1),
//                     //                                             ),
//                     //                                             onTap: (){
//                     //                                               setState(() {
//                     //                                                 isFullScreen = !isFullScreen;
//                     //                                               });
//                     //
//                     //
//                     //                                               if (isFullScreen){
//                     //                                                 _height = 1000;
//                     //                                               }
//                     //                                               else{
//                     //                                                 _height = 400;
//                     //                                               }
//                     //
//                     //                                             },
//                     //                                           ),
//                     //                                           ListTile(
//                     //                                             title: const  Icon(
//                     //                                               Icons.send, // Calendar icon
//                     //                                               color: Color.fromRGBO(6, 43, 105, 1), //
//                     //                                             ),
//                     //                                             onTap: () {
//                     //
//                     //                                               getUserCurrentLocation().then((value) {
//                     //
//                     //                                                 LatLng currentCoordinate = LatLng(value.latitude, value.longitude);
//                     //
//                     //                                                 // markers.add(
//                     //                                                 //   Marker(
//                     //                                                 //     markerId: MarkerId("marker_235"),
//                     //                                                 //     position: currentCoordinate,
//                     //                                                 //     infoWindow: InfoWindow(
//                     //                                                 //       title: "Marker jan",
//                     //                                                 //       snippet: "Coordinates:$currentCoordinate",
//                     //                                                 //     ),
//                     //                                                 //   ),
//                     //                                                 // );
//                     //                                                 mapController.animateCamera(
//                     //                                                   CameraUpdate.newLatLngZoom(currentCoordinate, 20),
//                     //                                                 );
//                     //
//                     //                                               });
//                     //                                             },
//                     //
//                     //                                           ),
//                     //                                         ]
//                     //                                     ).toList(),
//                     //                                   ),
//                     //                                 ),
//                     //                               ],
//                     //                             )
//                     //                         ),
//                     //                       ),
//                     //                     ],
//                     //                   ),
//                     //                 ],
//                     //               );
//                     //             },
//                     //           );
//                     //         };
//                     //       };
//                     //
//                     //       return  Container(
//                     //         height: 400,
//                     //         child:const Center(
//                     //           child:CircularProgressIndicator(),
//                     //         ),
//                     //       );
//                     //     }
//                     // ),
//     //             ],
//     //           ),
//     //
//     //
//     // );
//   }
//
//
//
//   Future<String> getAddressFromCoordinates(LatLng latLng) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude,latLng.longitude);
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
//
// }















