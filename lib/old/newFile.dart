import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:boxy/boxy.dart';
import 'package:boxy/flex.dart';
import 'package:boxy/padding.dart';
import 'package:boxy/slivers.dart';
import 'package:boxy/utils.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: SingleChildScrollView(
        child:Container(
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(''),fit:BoxFit.fill)),
        child: Column(
          children: [
          // show header

          // show grid view
          Container(

     /*GridView.custom(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          repeatPattern: QuiltedGridRepeatPattern.inverted,
          pattern: [
            QuiltedGridTile(2, 2),
            QuiltedGridTile(1, 1),
            QuiltedGridTile(1, 1),
            QuiltedGridTile(1, 2),
          ],
        ),
        childrenDelegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return GridTile(
              child: GestureDetector(
                onTap: () {
                  Fluttertoast.showToast(
                    msg: 'Tapped on item $index',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,);
                },
                child: Card(
                  color: Colors.blueGrey[100 * (index % 9)],
                  child: Center(
                    child: Text(
                      'Tile $index',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: 20, // Set the total number of items
        ),
      ),*/

          ),

          Container(



          ),


        ],
      ),
    ),

    ),

    );
  }
}



class Tile extends StatelessWidget {
  final int index;

  const Tile({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Tile $index',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}