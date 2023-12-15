
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'dart:ui' as ui;
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


//
//
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

    String urlMap = "https://www.empfingen.de/index.php?id=265&baseColor=2727278&baseFontSize=14&action=getFirmaMarkers";
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
        zoom: 3.0,
      );
    } else {
      // Default coordinates if the list is empty
      return const CameraPosition(
        target: LatLng(48.39503446981762, 8.699648380279541), // Default to San Francisco
        zoom: 10.0,
      );
    }
  }

// -------------> Cluster Code
  double zoom = 10;

  Set<Marker> markers = {};
  late Completer<GoogleMapController> googleMapController = Completer<GoogleMapController>();
  late ClusterManager clusterManager;

  // List<LatLng> coordinatess =[
  //   const LatLng(38.417392, 27.163635),
  //   const LatLng(38.429227, 27.203803),
  //   const LatLng(38.444287, 27.187667),
  //   const LatLng(38.468483, 27.174278),
  //   const LatLng(38.447245, 27.250152),
  //   const LatLng(38.477622, 27.212043),
  //   const LatLng(38.446976, 27.230239),
  //   const LatLng(38.482191, 27.213416),
  //   const LatLng(38.449127, 27.201400),
  //   const LatLng(38.467946, 27.215476)
  // ] ;


  String addressMap = "";


  List<PlaceModel> placeList = [
    PlaceModel(id:1, type: 1, name: "Example Place1", latLng: LatLng(38.417392, 27.163635)),
    PlaceModel(id:2, type: 0, name: "Example Place2", latLng: LatLng(38.429227, 27.203803)),
    PlaceModel(id:3, type: 1, name: "Example Place3", latLng: LatLng(38.444287, 27.187667)),
    PlaceModel(id:4, type: 0, name: "Example Place4", latLng: LatLng(38.468483, 27.174278)),
    PlaceModel(id:5, type: 1, name: "Example Place5", latLng: LatLng(38.447245, 27.250152)),
    PlaceModel(id:6, type: 0, name: "Example Place6", latLng: LatLng(38.477622, 27.212043)),
    PlaceModel(id:7, type: 1, name: "Example Place7", latLng: LatLng(38.446976, 27.230239)),
    PlaceModel(id:8, type: 0, name: "Example Place8", latLng: LatLng(38.482191, 27.213416)),
    PlaceModel(id:9, type: 1, name: "Example Place9", latLng: LatLng(38.449127, 27.201400)),
    PlaceModel(id:10, type: 1, name: "Example Place10", latLng: LatLng(38.467946, 27.215476)),
  ];


  @override
  void initState() {
    super.initState();

    clusterManager = _initClusterManager();

  }

  ClusterManager _initClusterManager() {

    // setState(()  {
    //   for(int i=0;i<coordinatess.length;i++){
    //     placeList.add(PlaceModel(id:i, type: 1, name: "place$i",latLng:coordinatess[i]));
    //   }
    //   if (placeList.isEmpty){
    //     print("cluster list is empty");
    //   }
    //   else{
    //     print("cluster list is not empty");
    //   }
    //
      List<Map<String, dynamic>> jsonList = placeList.map((place) => place.toJson()).toList();

      jsonList.forEach((item) {
        print("places-->${jsonEncode(item)}");
        // print("places-->${coordinates.length}");
      });
    // });

    return ClusterManager<PlaceModel>(placeList, _updateMarkers,
        markerBuilder: markerBuilder);
  }

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      this.markers = markers;
    });
  }


  Future<void> animateTo(LatLng position,double zoom) async {
    final c = await googleMapController.future;
    final p = CameraPosition(target: position, zoom: zoom);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  Future<Marker> Function(Cluster<PlaceModel>) get markerBuilder =>
          (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.isMultiple ? cluster.getId() : cluster.items.single.id.toString()),
          position: cluster.location,
          onTap: (){
            cluster.isMultiple
            /// Click Listener for Cluster
                ? {
              // setState((){
                animateTo(cluster.location, 14)
              // })
            }

            /// Click Listener for Marker
                :  {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Marker tapped"),
              ))
            };



          },
          icon: cluster.isMultiple
              ? await getMarkerBitmap(150,150,cluster.items.where((element) => element.type == 0).length,cluster.items.where((element) => element.type == 1).length,text: cluster.count.toString())
              : cluster.items.single.type == 0
              ? await bitmapDescriptorFromSvgAsset(
            context,
            "assets/red_location.svg",
            100,)
              : await bitmapDescriptorFromSvgAsset(
            context,
            "assets/blue_location.svg",
            100,),
          infoWindow: cluster.isMultiple
              ? InfoWindow()
              : InfoWindow(title: cluster.items.single.name),
        );
      };

  Future<BitmapDescriptor> getMarkerBitmap(int size, double size2, int typeZeroLength, int typeOneLength, {String? text}) async {
    if (kIsWeb) size = (size / 2).floor();

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = const Color(0xFF4051B5);
    final Paint paint2 = Paint()..color = Colors.white;
    final Paint paint3 = Paint()..color = Colors.red;

    double degreesToRads(num deg) {
      return (deg * 3.14) / 180.0;
    }

    int total = typeZeroLength + typeOneLength;
    var totalRatio = 2.09439666667 * 3;
    double percentageOfLength = (typeZeroLength / total);
    var resultRatio = totalRatio * percentageOfLength;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 3.8, paint3);
    canvas.drawArc(const Offset(0, 0) & Size(size2, size2), degreesToRads(90.0), resultRatio, true, paint3);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 3.2, paint2);
    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(fontSize: size / 3, color: Colors.black, fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }
    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;
    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }


  Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(BuildContext context, String assetName, double size,) async {
    String svgString = await DefaultAssetBundle.of(context).loadString(assetName);
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, '');
    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(size, size));
    ui.Image image = await picture.toImage(size.toInt(), size.toInt());
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }



  @override
  Widget build(BuildContext context) {
    // Set<Marker> markers = <Marker>{};

    print("markers->${markers.toString()}");




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

      body: Column(
                children: [

                    FutureBuilder<FerminMapItems>(
                        future: fetchAlbum(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }



                            if (snapshot.hasData) {



                              // List<fermanMapItem> items = snapshot.data!.ferminMap;
                              // int item_length = items.length;
                              // for(int i=0;i<=item_length;i++){
                              //   if (i < item_length){
                              //     fermanMapItem item = items[i];
                              //
                              //     double lat = double.parse(item.lat!);
                              //     double lng = double.parse(item.lng!);
                              //
                              //     coordinates.add(LatLng(lat, lng));
                              //   }
                              // }

                              // for(int i=0;i<coordinates.length;i++){
                              //   placeList.add(PlaceModel(id:i, type: 1, name: "Example Place1",latLng:coordinates[i]));
                              // }



                              // // Convert the PlaceModel list to JSON
                              // List<Map<String, dynamic>> jsonList = placeList.map((place) => place.toJson()).toList();
                              //
                              // jsonList.forEach((item) {
                              //   print("places-->${jsonEncode(item)}");
                              //   // print("places-->${coordinates.length}");
                              // });



                              CameraPosition initialCameraPosition = CameraPosition(
                                // target: coordinatess[0],
                                target: const LatLng(38.417392, 27.163635),
                                zoom: zoom,
                              );





                              // for (int i = 0; i < coordinates.length; i++) {
                              //   markers.add(
                              //     Marker(
                              //       markerId: MarkerId("marker_$i"),
                              //       position: coordinates[i],
                              //       infoWindow: InfoWindow(
                              //         title: "Marker $i",
                              //         snippet: "Coordinates: ${coordinates[i]}",
                              //       ),
                              //     ),
                              //   );
                              // }


                            // _initMarkers();


                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {

                                  return
                                    Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            height: 400,
                                            child:GoogleMap(
                                              initialCameraPosition: initialCameraPosition,
                                              markers: markers,
                                              onMapCreated: (GoogleMapController controller) async{
                                                googleMapController.complete(controller);
                                                clusterManager.setMapId(controller.mapId);
                                              },
                                              onCameraMove: (position) {
                                                clusterManager.onCameraMove(position);
                                              },
                                              onCameraIdle: clusterManager.updateMap,
                                            ),
                                          ),



                                          // Container(
                                          //   height:_height,
                                          //   child:  ClipRRect(
                                          //     borderRadius: const BorderRadius.only(
                                          //         topLeft: Radius.circular(0),
                                          //         topRight: Radius.circular(0),
                                          //         bottomRight: Radius.circular(50),
                                          //         bottomLeft: Radius.circular(50)),
                                          //     child:Align(
                                          //       alignment: Alignment.bottomRight,
                                          //       heightFactor: 1.0,
                                          //       widthFactor: 2.5,
                                          //       child: AnimatedContainer(
                                          //         duration: Duration(milliseconds: 500),
                                          //         width: double.infinity,
                                          //         height: _height,
                                          //         child:GoogleMap( //Map widget from google_maps_flutter package
                                          //             zoomGesturesEnabled: true, //enable Zoom in, out on map
                                          //             tiltGesturesEnabled: true,
                                          //             mapType: currentMapType,
                                          //             myLocationEnabled: true, // Enable the "My Location" button
                                          //             scrollGesturesEnabled: true,
                                          //             gestureRecognizers:
                                          //             <Factory<OneSequenceGestureRecognizer>>{
                                          //               Factory<OneSequenceGestureRecognizer>(
                                          //                     () => EagerGestureRecognizer(),
                                          //               ),
                                          //             },
                                          //             initialCameraPosition: createInitialCameraPosition(),
                                          //             // initialCameraPosition: _kGoogle,
                                          //             markers: markers,
                                          //
                                          //
                                          //
                                          //
                                          //             onMapCreated: (controller) {
                                          //               mapController = controller;
                                          //               _controller.complete(controller);
                                          //             }
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          //
                                          // Positioned(
                                          //   right: 20.0, // Adjust the top position as needed
                                          //   top: 20.0, // Adjust the left position as needed
                                          //   child: Container(
                                          //       alignment: Alignment.topRight,
                                          //       decoration: BoxDecoration(
                                          //         color: Colors.white,
                                          //         borderRadius: BorderRadius.circular(8.0),
                                          //         boxShadow: [
                                          //           BoxShadow(
                                          //             color: Colors.black.withOpacity(0.2),
                                          //             spreadRadius: 2,
                                          //             blurRadius: 4,
                                          //             offset: Offset(0, 2),
                                          //           ),
                                          //         ],
                                          //       ),
                                          //       child:  Column(
                                          //         children: [
                                          //           Container(
                                          //             height:170,
                                          //             width: 50,
                                          //             child:ListView(
                                          //               children:
                                          //               ListTile.divideTiles( //
                                          //                   context: context,
                                          //                   tiles: [
                                          //                     ListTile(
                                          //                       title: const Center(child:Icon(
                                          //                         Icons.more_vert, // Calendar icon
                                          //                         color: Color.fromRGBO(6, 43, 105, 1), //
                                          //                       ),),
                                          //                       onTap: (){
                                          //                         showModalBottomSheet(
                                          //                           context: context,
                                          //                           barrierColor: Colors.black.withAlpha(1),
                                          //                           backgroundColor: Colors.transparent,
                                          //                           builder: (BuildContext context) {
                                          //                             return Container(
                                          //
                                          //                               margin: EdgeInsets.all(10),
                                          //                               decoration: const BoxDecoration(
                                          //                                 color: Color.fromRGBO(209, 205, 208, 1.0),
                                          //                                 borderRadius: BorderRadius.only(
                                          //                                   topLeft: Radius.circular(15.0),
                                          //                                   topRight: Radius.circular(15.0),
                                          //                                   bottomRight: Radius.circular(15.0),
                                          //                                   bottomLeft: Radius.circular(15.0),
                                          //                                 ),
                                          //                               ),
                                          //                               height: 170.0,
                                          //                               child: ListView(
                                          //                                 children:
                                          //                                 ListTile.divideTiles( //
                                          //                                     context: context,
                                          //                                     tiles: [
                                          //                                       ListTile(
                                          //                                         title: const Text('Standard',
                                          //                                           textAlign: TextAlign.center,
                                          //                                         ),
                                          //                                         onTap: (){
                                          //                                           setState(() {
                                          //                                             currentMapType = MapType.terrain;
                                          //                                           });
                                          //
                                          //                                           Navigator.pop(context);
                                          //                                         },
                                          //                                       ),
                                          //                                       ListTile(
                                          //                                         title: const Text('Satelite',
                                          //                                           textAlign: TextAlign.center,
                                          //                                         ),
                                          //                                         onTap: (){
                                          //                                           setState(() {
                                          //                                             currentMapType = MapType.satellite;
                                          //                                           });
                                          //
                                          //                                           Navigator.pop(context);
                                          //                                         },
                                          //                                       ),
                                          //                                       ListTile(
                                          //                                         title: const Text('Hybrid',
                                          //                                           textAlign: TextAlign.center,
                                          //                                         ),
                                          //                                         onTap: (){
                                          //                                           setState(() {
                                          //                                             currentMapType = MapType.hybrid;
                                          //                                           });
                                          //
                                          //
                                          //
                                          //                                           Navigator.pop(context);
                                          //                                         },
                                          //
                                          //                                       ),
                                          //                                     ]
                                          //                                 ).toList(),
                                          //
                                          //                               ),
                                          //                             );
                                          //                           },
                                          //                         );
                                          //                       },
                                          //                     ),
                                          //                     ListTile(
                                          //                       title:  Icon(isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                                          //                         color: Color.fromRGBO(6, 43, 105, 1),
                                          //                       ),
                                          //                       onTap: (){
                                          //                         setState(() {
                                          //                           isFullScreen = !isFullScreen;
                                          //                         });
                                          //
                                          //
                                          //                         if (isFullScreen){
                                          //                           _height = 1000;
                                          //                         }
                                          //                         else{
                                          //                           _height = 400;
                                          //                         }
                                          //
                                          //                       },
                                          //                     ),
                                          //                     ListTile(
                                          //                       title: const  Icon(
                                          //                         Icons.send, // Calendar icon
                                          //                         color: Color.fromRGBO(6, 43, 105, 1), //
                                          //                       ),
                                          //                       onTap: () {
                                          //
                                          //                         getUserCurrentLocation().then((value) {
                                          //
                                          //                           LatLng currentCoordinate = LatLng(value.latitude, value.longitude);
                                          //
                                          //                           // markers.add(
                                          //                           //   Marker(
                                          //                           //     markerId: MarkerId("marker_235"),
                                          //                           //     position: currentCoordinate,
                                          //                           //     infoWindow: InfoWindow(
                                          //                           //       title: "Marker jan",
                                          //                           //       snippet: "Coordinates:$currentCoordinate",
                                          //                           //     ),
                                          //                           //   ),
                                          //                           // );
                                          //                           mapController.animateCamera(
                                          //                             CameraUpdate.newLatLngZoom(currentCoordinate, 20),
                                          //                           );
                                          //
                                          //                         });
                                          //                       },
                                          //
                                          //                     ),
                                          //                   ]
                                          //               ).toList(),
                                          //             ),
                                          //           ),
                                          //         ],
                                          //       )
                                          //   ),
                                          // ),
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

                ],
              ),


    );
  }



  // Future<String> getAddressFromCoordinates(LatLng latLng) async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude,latLng.longitude);
  //
  //     if (placemarks != null && placemarks.isNotEmpty) {
  //       Placemark place = placemarks[0];
  //       String address = place.country!;
  //       addressMap = address;
  //       return address;
  //     } else {
  //       return 'No address found';
  //     }
  //   } catch (e) {
  //     return 'Error fetching address';
  //   }
  // }

}















