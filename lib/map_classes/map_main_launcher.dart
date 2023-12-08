import 'package:flutter/material.dart';
import 'package:test_project/map_classes/main/circleScreen.dart';

import 'main/clusterScreenApproach2.dart';
import 'main/clusterScreenApproach3.dart';
import 'main/polygonScreen.dart';

void main() {
  runApp(MaterialApp(
    home: ButtonsMainScreen(),
  ));
}



class ButtonsMainScreen extends StatefulWidget {
  @override
  _ButtonsMainScreenState createState() => _ButtonsMainScreenState();
}

class _ButtonsMainScreenState extends State<ButtonsMainScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Example'),
        backgroundColor: Colors.black,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
          children: [

            Center(
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child:

                Column(
                  children: [

                    Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 280,
                      height: 70,
                      color: Colors.black,
                      child:ElevatedButton(

                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PolygonMapScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black, // Change the background color here
                        ),
                        child: const Text('Line Polygon Example',
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                      ),
                    ),


                    Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 280,
                      height: 70,
                      color: Colors.black,
                      child:ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CircleMapScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black, // Change the background color here
                        ),
                        child: const Text('Circle on Map Example',
                          style: TextStyle(
                              fontSize: 18
                          ),),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 280,
                      height: 70,
                      color: Colors.black,
                      child:ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black, // Change the background color here
                        ),
                        child: const Text('Rectangle on Map Example',
                          style: TextStyle(
                              fontSize: 18
                          ),),
                      ),
                    ),



                    Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 280,
                      height: 70,
                      color: Colors.black,
                      child:ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ClusterView()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black, // Change the background color here
                        ),
                        child: const Text('Clusters Example',
                          style: TextStyle(
                              fontSize: 18
                          ),),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 280,
                      height: 70,
                      color: Colors.black,
                      child:ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black, // Change the background color here
                        ),
                        child: const Text('All in One Example',
                          style: TextStyle(
                              fontSize: 18
                          ),),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
    );
  }
}





