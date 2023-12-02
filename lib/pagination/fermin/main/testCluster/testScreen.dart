
import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_project/pagination/fermin/model/fermin_map_model/fermin_map_items.dart';

import '../../../dashboard_items.dart';
import 'package:http/http.dart' as http;

import '../../../extensions/color_hex.dart';
import '../../model/ferminListViewModel/fermin_items.dart';



import 'package:test_project/pagination/fermin/main/testCluster/place.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';




void main() {
  runApp(testApp());
}

class testApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      home: testMapCluster(),
    );
  }
}


class testMapCluster extends StatefulWidget { /// stateful widget
  testMapCluster({super.key});

  @override
  _testMapClusterState createState() => _testMapClusterState();
}

class _testMapClusterState extends State<testMapCluster> {  /// state widget

  late double _height = 400;
  List<LatLng> coordinates = [ ];
  MapType currentMapType = MapType.normal;
  LatLng coordinate1 = LatLng(0, 0);
  late GoogleMapController mapController;
  LatLng loc1 = const LatLng(34.022723637768, 71.52425824981451);
  bool isFullScreen = false;
  Future<FerminMapItems> fetchAlbum() async {

    final response = await http.get(Uri.parse("https://www.empfingen.de/index.php?id=265&baseColor=2727278&baseFontSize=14"
        "&action=getFirmaMarkers"));

    if (response.statusCode == 200) {

      return FerminMapItems.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {

      throw Exception('Failed to load album');
    }
  }
  Set<Marker> markers = <Marker>{
    const Marker(
      markerId: MarkerId("marker_1"),
      position: LatLng(37.7749, -122.4194),
      infoWindow: InfoWindow(
        title: "Marker Title",
        snippet: "Marker Snippet",
      ),
    ),
  };


  // ------------> Sample Code

  late ClusterManager _manager;

  Completer<GoogleMapController> _controller = Completer();

  // Set<Marker> markers = Set();





  List<Place> items = [
  //     Place(
  //         name: 'Place 1',
  //         isClosed: true,
  //         latLng:  const LatLng(48.39503446981762, 8.699648380279541)),
  //
  // Place(
  // name: 'Place 2',
  // isClosed: true,
  // latLng:  const LatLng(48.39729713260604, 8.70231342317311)),

    for (int i = 0; i < 10; i++)
      Place(
          name: 'Restaurant $i',
          isClosed: i % 2 == 0,
          latLng: LatLng(48.858265 - i * 0.001, 2.350107 + i * 0.001)),


    for (int i = 0; i < 10; i++)
      Place(
          name: 'Bar $i',
          latLng: LatLng(48.858265 + i * 0.01, 2.350107 - i * 0.01)),
    for (int i = 0; i < 10; i++)
      Place(
          name: 'Hotel $i',
          latLng: LatLng(48.858265 - i * 0.1, 2.350107 - i * 0.01)),
  ];

  List<Place> items2 = [
    for (int i = 0; i < 10; i++)
      Place(
          name: 'Place $i',
          latLng: LatLng(48.848200 + i * 0.001, 2.319124 + i * 0.001)),
    for (int i = 0; i < 10; i++)
      Place(
          name: 'Test $i',
          latLng: LatLng(48.858265 + i * 0.1, 2.350107 + i * 0.1)),
    for (int i = 0; i < 10; i++)
      Place(
          name: 'Test2 $i',
          latLng: LatLng(48.858265 + i * 1, 2.350107 + i * 1)),




  ];

  @override
  void initState() {
    _manager = _initClusterManager();
    super.initState();
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(items, _updateMarkers,
        markerBuilder: _markerBuilder);
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
    });
  }


  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
          (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            print('---- $cluster');
            cluster.items.forEach((p) => print(p));
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      };
  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    if (kIsWeb) size = (size / 2).floor();

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()
      ..color = Colors.orange;
    final Paint paint2 = Paint()
      ..color = Colors.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
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


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map Cluster Example"),
      ),
      backgroundColor: Colors.grey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
        child: Icon(isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
      ),

      body: ListView(
        children:[
          /// Google Map
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
                    List<fermanMapItem> items = snapshot.data!.ferminMap;
                    int item_length = items.length;
                    for(int i=0;i<=item_length;i++){
                      if (i < item_length){
                        fermanMapItem item = items[i];

                        double lat = double.parse(item.lat!);
                        double lng = double.parse(item.lng!);

                        // coordinates.add(LatLng(lat, lng));

                      }
                    }
                    for (int i = 0; i < coordinates.length; i++) {
                      // markers.add(
                      //   Marker(
                      //     markerId: MarkerId("marker_$i"),
                      //     position: coordinates[i],
                      //     infoWindow: InfoWindow(
                      //       title: "Marker $i",
                      //       snippet: "Coordinates: ${coordinates[i]}",
                      //     ),
                      //   ),
                      // );
                    }
                    // coordinate1 = coordinates[0];
                    return ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                        bottomRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        heightFactor: 1.0,
                        widthFactor: 2.5,
                        child: Container(
                          width: double.infinity,
                          height: _height,
                          child:GoogleMap( //Map widget from google_maps_flutter package
                              zoomGesturesEnabled: true, //enable Zoom in, out on map
                              tiltGesturesEnabled: true,
                              mapType: currentMapType,
                              myLocationEnabled: true, // Enable the "My Location" button
                              myLocationButtonEnabled: true,
                              scrollGesturesEnabled: true,
                              gestureRecognizers:
                              <Factory<OneSequenceGestureRecognizer>>{
                                Factory<OneSequenceGestureRecognizer>(
                                      () => EagerGestureRecognizer(),
                                ),
                              },
                              initialCameraPosition: const CameraPosition( //innital position in map
                                // target: coordinate1, //initial position
                                target: LatLng(48.39503446981762, 8.699648380279541), //initial position
                                zoom: 10.0, //initial zoom level
                              ),
                              // initialCameraPosition: _kGoogle,
                              markers: markers,
                              onMapCreated: (controller) {


                                _controller.complete(controller);
                                _manager.setMapId(controller.mapId);
                              },
                              onCameraMove: _manager.onCameraMove,
                              onCameraIdle: _manager.updateMap,
                          ),
                        ),
                      ),
                    );
                  };
                };
                return const Center();
              }
          ),
        ],
      ),
    );
  }

}
