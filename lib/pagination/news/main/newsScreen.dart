import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_project/pagination/dashboard_items.dart';
import 'package:test_project/pagination/news/news_items.dart';

import '../../configs/app_config.dart';

import 'package:http/http.dart' as http;



import '../../configs/default_config.dart';
import '../../extensions/color_hex.dart';
import 'news_details_screen.dart';




class newsApp extends StatelessWidget {

  /// const newsApp({Key? key}) : super(key: key);

  final Dashboard dashboardSingleFetchItem;
  newsApp({super.key, required this.dashboardSingleFetchItem});


  @override
  Widget build(BuildContext context) {
    return LoadMoreOnScrollListView(this.dashboardSingleFetchItem);
  }
}


class LoadMoreOnScrollListView extends StatefulWidget {

  final Dashboard dashboardSingleFetchItem;


  LoadMoreOnScrollListView(this.dashboardSingleFetchItem);

  @override
  _LoadMoreNewsState createState() => _LoadMoreNewsState(this.dashboardSingleFetchItem);
}




class _LoadMoreNewsState extends State<LoadMoreOnScrollListView> {


  final Dashboard dashboardSingleFetchItem;

  _LoadMoreNewsState(this.dashboardSingleFetchItem);


  ScrollController scrollController = ScrollController();

  bool isLoadingMore = false;
  int _limit = 10;
  int _startLimit = 0;

  bool noMoreItems = false;

  List<News> newsItemsArray = [];

  void fetchData(startLimit) async {
    setState(() {
      isLoadingMore = true;
    });

    var beforeCount = newsItemsArray.length;

    final response = await http.get(Uri.parse(AppConfig.newsUrlItems(
        dashboardSingleFetchItem.url.toString(), startLimit, _limit)));

    log("theNewersURl ${AppConfig.newsUrlItems(dashboardSingleFetchItem.url.toString(), startLimit, _limit)}");

    NewsItems newsItemsClass = NewsItems.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);

    newsItemsArray = newsItemsArray + newsItemsClass.news;
    int localOffset = _startLimit + _limit;

    var afterCount = newsItemsArray.length;

    setState(() {
      newsItemsArray;
      isLoadingMore = false;
      _startLimit = localOffset;
      log("localOffset $_startLimit");

      if (beforeCount == afterCount) {
        noMoreItems = true;
        log("noMoreItemsCalled $noMoreItems");
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
        log("handleNext $_startLimit");

        fetchData(_startLimit);
      }
    });
  }


  final testItems = <String>[
    'Packing & Unpacking',
    'Cleaning',
    'Painting',
    'Heavy Lifting',
    'Shopping',
    'Watching Netflix',
    'sadfdsfe eaf',
    'ewfsfeagga,' 'gegea',
    'gaegaewgv ewaggaa aweegaage',
    'safa asdfesadfv esfsdf',
    'sadfdsfe eaf',
    'ewfsfeagga,' 'gegea',
    'awfgraga wsg sfage aegea',
    'gaegaewgv ewaggaa aweegaage',
    'asdfehtrbfawefa garevaa aewf a'
  ];

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: Text(dashboardSingleFetchItem.title.toString()),
      ),
        backgroundColor: Colors.grey.shade300,


      body:

      ListView.builder(
        controller: scrollController,
        itemCount: newsItemsArray.length + 1,
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5), // Adjust the margin values as needed

        itemBuilder: (context, index) {
          if (index == newsItemsArray.length) {
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

          News item = newsItemsArray[index];
          int timeStamp = item.datum;

          /// converting timestamp to date format
          int unixTimestamp = timeStamp; // Your Unix timestamp
          DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);

          /// If the timestamp is in seconds, multiply by 1000 to convert it to milliseconds
          String formattedDate =
              '${dateTime.year}-${dateTime.month}-${dateTime.day}';

          /// Customize the date format as needed
          log("theNewsImage ${[index]} ${item.teaserbild}");
          log("theNewsTitle ${[index]} ${item.bezeichnung}");
          log("theNewssubTitle ${[index]} ${item.teasertext}");

          return
          InkWell(
              onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  newsDetail(
                      newsSingleFetchItem: item
                  )),
            );
          },


            child:Card(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 5), // Adjust the margin values as needed
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(DefaultConfig.newsCardCornerRadius),
                    topLeft: Radius.circular(DefaultConfig.newsCardCornerRadius),
                    bottomLeft: Radius.circular(DefaultConfig.newsCardCornerRadius),
                    topRight: Radius.circular(DefaultConfig.newsCardCornerRadius)
                ),
                side: BorderSide(width: 1, color: HexColor(DefaultConfig.mainCollectionViewCellBorderColor))),

            child: Container(
              child: Column(children: [
                /// Image from top

                Visibility(
                  visible: item.teaserbild != null &&
                      item.teaserbild.isNotEmpty,
                  child: AspectRatio(
                    aspectRatio: 4 / 2,
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          alignment: FractionalOffset.centerLeft,
                          image: NetworkImage(item.teaserbild),
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(DefaultConfig.newsCardCornerRadius),
                            topRight: Radius.circular(DefaultConfig.newsCardCornerRadius)),
                      ),
                    ),
                  ),
                ),

                /// date and calendar icon

                Container(
                  padding: EdgeInsets.fromLTRB(AppConfig.newsCardLeftMargin, 10, AppConfig.newsCardRightMargin, 10), // Adjust the margin values as needed
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.calendar_today, // Calendar icon
                        color:
                        Colors.grey, // Adjust the color as needed
                      ),
                      const SizedBox(
                          width:
                          8), // Adjust the spacing between the icon and text
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize:
                          16, // Adjust the font size as needed
                          color: Colors
                              .grey, // Adjust the text color as needed
                        ),
                      ),
                    ],
                  ),
                ),

                /// title and subtitle

                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0,
                      15), // Adjust the margin values as needed
                  child:
                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.bezeichnung,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize:
                              18, // Adjust the font size as needed
                              color: Colors
                                  .black, // Adjust the text color as needed
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.teasertext,
                          style: const TextStyle(
                              fontSize:
                              16, // Adjust the font size as needed
                              color: Colors
                                  .grey, // Adjust the text color as needed
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),

                /// bottom categories

                Align(
                    alignment: Alignment.topLeft,
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
                    )),
              ]),
            ),
            ),
          );

        },
      ),



    );

  }

}
