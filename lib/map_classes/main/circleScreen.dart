import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CircleMapScreen extends StatefulWidget {
  @override
  _CircleMapScreenState createState() => _CircleMapScreenState();
}

class _CircleMapScreenState extends State<CircleMapScreen> {
  late GoogleMapController mapController;

  LatLng loc1 = const LatLng(34.022723637768, 71.52425824981451);
  LatLng loc2 = const LatLng(34.2329048623674, 71.5378010904082);

  Set<Polyline> polylines={};

  @override
  void initState() {
    drawPolylines();
    super.initState();
  }

  drawPolylines() async {
    polylines.add(Polyline(
      polylineId: PolylineId(loc1.toString()),
      visible: true,
      width: 5, //width of polyline
      points: [
        loc1, //start point
        loc2, //end point
      ],
      color: Colors.deepPurpleAccent, //color of polyline
    ));

    setState(() {
      //refresh UI
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Circle Map Example'),
        backgroundColor: Colors.black,
      ),
      body: GoogleMap( //Map widget from google_maps_flutter package
        zoomGesturesEnabled: true, //enable Zoom in, out on map
        initialCameraPosition: CameraPosition( //innital position in map
          target: loc1, //initial position
          zoom: 10.0, //initial zoom level
        ),
        polylines: polylines, //polylines list
        mapType: MapType.normal, //map type
        onMapCreated: (controller) { //method called when map is created
          setState(() {
            mapController = controller;
          });
        },
      )
    );
  }




}
