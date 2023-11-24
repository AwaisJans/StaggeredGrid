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
  LatLng loc3 = const LatLng(33.9203419727611, 71.4692384490439);


  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};


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
        onMapCreated: _onMapCreated,
        circles: _circles,
      )
    );
  }


  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      _addCircles();

    });
  }


  void _addCircles() {
    List<LatLng> coordinates = [
      loc1,
      loc2,
      loc3,
      // Add more coordinates as needed
    ];

    for (LatLng coordinate in coordinates) {
      _addCircle(coordinate);
    }
  }

  void _addCircle(LatLng center) {
    final CircleId circleId = CircleId(center.toString());

    final Circle circle = Circle(
        circleId: circleId,
        center: center,
        radius: 5000,
        // Radius in meters
        strokeWidth: 5,
        strokeColor: Colors.red,
        fillColor: Colors.red.withOpacity(0.3),
        consumeTapEvents: true,
        onTap: () {


          if (center.toString() == loc1.toString()){
            // Handle tap on the circle
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Peshawar'),
            ));
          }
          else if (center.toString() == loc2.toString()){
            // Handle tap on the circle
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Shabqadar'),
            ));
          }
          else if (center.toString() == loc3.toString()){
            // Handle tap on the circle
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Bara'),
            ));
          }

        },
      );

    setState(() {
      _circles.add(circle);
    });
  }

}
