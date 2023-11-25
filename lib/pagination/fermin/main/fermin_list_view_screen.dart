import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_project/pagination/fermin/main/fermin_google_map.dart';

import '../../configs/default_config.dart';
import '../../extensions/color_hex.dart';
import '../model/ferminListViewModel/fermin_items.dart';


import 'package:http/http.dart' as http;

import 'fermin_item_details.dart';





class MyFerminListView extends StatefulWidget {
  @override
  _MyFerminListViewState createState() => _MyFerminListViewState();
}

class _MyFerminListViewState extends State<MyFerminListView> {
  final testItems = <String>[
    'Packing & Unpacking',
    'Cleaning',
    'Painting',
  ];

  ScrollController scrollController = ScrollController();

  bool isLoadingMore = false;
  int _limit = 10;
  int _startLimit = 0;

  bool noMoreItems = false;

  List<Fermin> ferminItemsArray = [];

  void fetchData(startLimit) async {
    setState(() {
      isLoadingMore = true;
    });

    var beforeCount = ferminItemsArray.length;

    final response = await http.get(Uri.parse("https://www.empfingen.de/index.php?id=265&baseColor=2727278&baseFontSize=14&action=getFirmaItems&"
        "limitStart=$_startLimit&limitAmount=$_limit"));

    FerminItems newsItemsClass = FerminItems.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);

    ferminItemsArray = ferminItemsArray + newsItemsClass.fermin;
    int localOffset = _startLimit + _limit;

    var afterCount = ferminItemsArray.length;

    setState(() {
      ferminItemsArray;
      isLoadingMore = false;
      _startLimit = localOffset;


      if (beforeCount == afterCount) {
        noMoreItems = true;


      }
    });
  }



  @override
  void initState() {

    super.initState();
    fetchData(_startLimit);
    handleNext();
  }

  void handleNext() {
    scrollController.addListener(() async {
      if (isLoadingMore) return;
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        fetchData(_startLimit);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      CustomScrollView(
        controller: scrollController,
        slivers: [

//      Header  -----------------> Google Map

          SliverToBoxAdapter(
            child: Container(
              child: MyFerminGoogleMap(),
            ),
          ),


///     ListView  -----------------> Fermin Items
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                if (index == ferminItemsArray.length) {
                      return isLoadingMore
                          ? Container(
                        height: 200,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                          ),
                        ),
                      )
                          : Container();

                    }

                    Fermin item = ferminItemsArray[index];

                    return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            ferminItemDetails(
                                ferminSingleFetchItem: item
                            )),
                                              );
                    },


                    child:Card(
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                      // Adjust the margin values as needed
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(
                                  DefaultConfig.newsCardCornerRadius),
                              topLeft: Radius.circular(
                                  DefaultConfig.newsCardCornerRadius),
                              bottomLeft: Radius.circular(
                                  DefaultConfig.newsCardCornerRadius),
                              topRight: Radius.circular(
                                  DefaultConfig.newsCardCornerRadius)
                          ),
                          side: BorderSide(width: 1, color: HexColor(DefaultConfig.mainCollectionViewCellBorderColor))),

                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Column(
                          children:
                          [

                              Text(item.bezeichnung!,
                              style: const TextStyle(fontSize: 13,
                                  // Adjust the font size as needed
                                  color: Colors.black),
                            ),

                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.location_city, // Calendar icon
                                    color:
                                    Colors.grey, //
                                  ),

                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        15, 0, 0, 0),
                                    //apply padding to all four sides
                                    child: Text(
                                      item.strasse! + " - " + item.plz! +
                                          " " + item.ort!,
                                      style: const TextStyle(fontSize: 13,
                                          // Adjust the font size as needed
                                          color: Colors.grey),
                                    ),
                                  ),

                                ]
                            ),


                            Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0,
                                15), // Adjust the margin values as needed
                            child: Wrap(
                              children: [
                                // for (var item in kategoriens)
                                for (var item in testItems)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      border: Border.all(color: Colors.red),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(13)),
                                    ),
                                    // you can change margin to increase spacing between containers
                                    margin: const EdgeInsets.all(3),
                                    padding:
                                    const EdgeInsets.fromLTRB(4, 2, 4, 2),
                                    child: Text(
                                      // item.bezeichnung,
                                      item as String,
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                ),
                        ],
                        ),

                    ),
                  ),

                  );

              },

              childCount: ferminItemsArray.length+1,
            ),
          ),
        ],
      );
  }
}

