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

  bool isLoadingMore = false;

  final scrollController = ScrollController();

  final int _page = 0;
  int _limit = 10;
  Future<NewsItems> fetchAlbum() async {
    final response = await http.get(Uri.parse(AppConfig.newsUrlItems(
        dashboardSingleFetchItem.url.toString(), _page, _limit)));

    if (response.statusCode == 200) {

      return NewsItems.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load album');
    }
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

  void _scrollListener(){
    if (scrollController.position.pixels ==
    scrollController.position.maxScrollExtent){
      log('scrolled');
      setState(() {
        isLoadingMore = true;
      });

      _limit = _limit + 10;


      setState(() {
        isLoadingMore = false;
      });


    }

  }

  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dashboardSingleFetchItem.title.toString()),
      ),
        backgroundColor: Colors.grey.shade300,
        body: FutureBuilder<NewsItems>(
          future: fetchAlbum(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (snapshot.hasData) {
                List<News> items = snapshot.data!.news;

                // List<kategorien> kategoriens = snapshot.data!.news[0].kategoriens;

                return ListView.builder(
                  padding: const EdgeInsets.all(12.0), // Adjust the margin values as needed
                  controller: scrollController,
                  itemCount: isLoadingMore ? items!.length + 10 : items.length,
                  itemBuilder: (context, index) {
                    News item = items[index];
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


                    if (index < items.length){
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => newsDetail(
                                newsSingleFetchItem : snapshot.data!.news![index]
                            )),
                          );
                        },
                        child: Card(
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
                    }
                    else{
                      return Center(
                        child:CircularProgressIndicator(),
                      );
                    }



                  },
                );
              }
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
    );

  }

}
