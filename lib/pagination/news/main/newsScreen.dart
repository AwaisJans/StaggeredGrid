import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_project/pagination/dashboard_items.dart';
import 'package:test_project/pagination/news/news_items.dart';

import '../../configs/app_config.dart';

import 'package:http/http.dart' as http;

import '../../configs/default_config.dart';
import '../../extensions/color_hex.dart';
import '../models/filter_model/filter_items.dart';
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
  _LoadMoreNewsState createState() =>
      _LoadMoreNewsState(this.dashboardSingleFetchItem);
}

class _LoadMoreNewsState extends State<LoadMoreOnScrollListView> {
  final Dashboard dashboardSingleFetchItem;

  _LoadMoreNewsState(this.dashboardSingleFetchItem);

  ScrollController scrollController = ScrollController();

  bool isLoadingMore = false;
  int _limit = 10;
  late int _startLimit = 0;

  bool noMoreItems = false;

  List<News> newsItemsArray = [];

  late String urlKategory = "";

  String apiUrl = "";

  Future<void> performAsyncOperation() async {
    // Simulate an asynchronous operation
    await Future.delayed(Duration(seconds: 2));

    isFilterActivated = true;
  }
  void fetchData() async {
    setState(() {
      isLoadingMore = true;

      print("checkingFilterStatusASYNC${isFilterActivated.toString()}");



    });

    var beforeCount = newsItemsArray.length;


    if (isFilterActivated){
      String filterBaseUrl = "https://www.empfingen.de/index.php?id=265&baseColor=2727278&baseFontSize=14";
      setState(() {
        apiUrl = "$filterBaseUrl&action=getNewsItems$urlKategory&volltext=$enteredText"
            "&limitStart=$_startLimit&limitAmount=$_limit";
      });

    }
    else{
      setState(() {
        apiUrl = AppConfig.newsUrlItems(dashboardSingleFetchItem.url.toString(), _startLimit, _limit);
      });
    }

    final response = await http.get(Uri.parse(apiUrl));

    log("theNewersURl ${AppConfig.newsUrlItems(dashboardSingleFetchItem.url.toString(), _startLimit, _limit)}");
    print("checkingFilterStatusASYNC${isFilterActivated.toString()}");

    NewsItems newsItemsClass =
        NewsItems.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

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
    fetchData();
    fetchFilterData();
    handleNext();
  }

  void handleNext() {
    scrollController.addListener(() async {
      if (isLoadingMore) return;
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        log("handleNext $_startLimit");

        fetchData();
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

  ///// Categries

  List<Filters> newsFilterItemsArray = [];

  void fetchFilterData() async {
    final response =
        await http.get(Uri.parse("https://www.empfingen.de/index.php?id="
            "265&baseColor=2727278&baseFontSize=14&action=getNewsKategories"));

    NewsFilterItems newsFilterItemsClass = NewsFilterItems.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);

    newsFilterItemsArray = newsFilterItemsArray + newsFilterItemsClass.filters;
  }


  List<bool> selectedItems = List.generate(5, (index) => false);
  List<String> selectedItemsId = List.generate(5, (index) => "");

  TextEditingController textEditingController = TextEditingController();

  String enteredText = "";

  bool isFilterActivated = false;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
  String searchText = "";


  bool _counselor = false;

  bool get counselor => _counselor;

  void setCounselor(bool counselor) {
    _counselor = counselor;
  }

  void performDelayedSetState() {
    // Perform any actions you need before changing the state

    // Delayed setState after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        // Change the state (e.g., update a boolean variable)
        isFilterActivated = !counselor;
      });

      // Perform any actions after changing the state if needed
    });
  }


    @override
  Widget build(BuildContext context) {

    /// boolean for finish button
    bool allFalse = true;
    bool allTextFalse = false;
    print('checked itemsId${urlKategory.toString()}');



    if (isFilterActivated){
      print("gushduhijd ---> true");
    }
    else{
      setState(() {
        print("gushduhijd ---> false");
      });

    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          dashboardSingleFetchItem.title.toString(),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color.fromRGBO(17, 93, 165, 1),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showGeneralDialog(
                barrierLabel: "Label",
                barrierDismissible: false,
                transitionDuration: Duration(milliseconds: 700),
                context: context,
                pageBuilder: (context, anim1, anim2) {
                  return Scaffold(
                    body:
                    Container(
                      margin: EdgeInsets.only(
                          bottom: 0, left: 0, right: 0, top: 30),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(241, 241, 249, 1),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child:StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
                          GlobalKey<RefreshIndicatorState>();
                          return WillPopScope(
                              onWillPop: () async {
                            // Your favorite action when the user presses the back button
                                setState((){
                                  selectedItems = List.generate(newsFilterItemsArray.length, (index) => false);
                                  textEditingController.clear();
                                  Navigator.of(context).pop();
                                  isFilterActivated = false;
                                });
                            return true; // Return true to allow popping the dialog
                          },


                            child:
                            Column(
                            children: [
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child:
                                        RefreshIndicator(
                                        key: _refreshIndicatorKey,
                                        onRefresh: () async {
                                          // Trigger a refresh by calling the refresh method
                                          _refreshIndicatorKey.currentState?.show();
                                        },
                                    child:
                                    ListTile(
                                      title: const Text('Finish',
                                          style: TextStyle(
                                            color:
                                            Color.fromRGBO(17, 93, 165, 1),
                                          )),
                                      onTap: () async{
                                        searchText = textEditingController.text;

                                        print('checked items$selectedItems');
                                        print('checked itemsId$selectedItemsId');
                                        print('Entered Text: $searchText');



                                          setState((){
                                            // isFilterActivated = true;

                                            performDelayedSetState();


                                            // Check if each item in the list is empty using item.equals("")
                                            bool allItemsEmpty = true;
                                            Set<String> uniqueItems = {};
                                            for (String item in selectedItemsId) {
                                              if (item == "") {
                                                // If any item is not empty, set the flag to false and break the loop
                                                allItemsEmpty = false;
                                              }else{
                                                allItemsEmpty = true;
                                                // strKategory = "&kategories[]=$item";
                                                uniqueItems.add("&kategories[]=$item");

                                              }
                                            }

                                            if (allItemsEmpty)
                                            {
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                content: Text("empty"),
                                              ));
                                              urlKategory = "";
                                            }
                                            else{
                                              // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                              //   content: Text("not empty"),
                                              // ));
                                              setState((){
                                                urlKategory = uniqueItems.join("");
                                                print("khali nade"+urlKategory);
                                              });

                                            }
                                          });
                                        Navigator.of(context).pop();


                                        // Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: const Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          'Filter',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                  Expanded(
                                    child:  Visibility(
                                      visible: !allFalse || allTextFalse,
                                      child: ListTile(
                                        title: const Align(
                                          alignment: Alignment.topRight,
                                          child: Text('Reset',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    17, 93, 165, 1),
                                              )),
                                        ),
                                        onTap: () {
                                          setState((){
                                            selectedItems = List.generate(newsFilterItemsArray.length, (index) => false);
                                            textEditingController.clear();
                                            isFilterActivated = false;
                                          });

                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: SizedBox(
                                  height: 30,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Full Text Search",
                                        style: TextStyle(
                                          color: Color.fromRGBO(95, 94, 97, 1),
                                          fontSize: 15,
                                          decoration: TextDecoration.none,
                                        )),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: TextField(
                                    controller: textEditingController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter search text',
                                      border: InputBorder
                                          .none, // Set the hint text
                                    ),
                                    onChanged: (text){
                                      enteredText = text;
                                      setState((){
                                        if (enteredText == "" || enteredText.isEmpty){
                                          allTextFalse = false;
                                        }else{
                                          allTextFalse = true;
                                        }

                                      });
                                    },
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: SizedBox(
                                  height: 30,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Categories",
                                        style: TextStyle(
                                          color: Color.fromRGBO(95, 94, 97, 1),
                                          fontSize: 15,
                                          decoration: TextDecoration.none,
                                        )),
                                  ),
                                ),
                              ),
                              ListView.separated(
                                shrinkWrap: true,
                                itemCount: newsFilterItemsArray.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                const Divider(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  Filters item = newsFilterItemsArray[index];
                                  return Container(
                                    color: Colors.white,
                                    child: ListTile(
                                      title: Text(item.bezeichnung),
                                      trailing: selectedItems[index]
                                          ? const Icon(Icons.check,
                                          color: Color.fromRGBO(17, 93, 165,
                                              1)) // Show check mark if selected
                                          : null,
                                      onTap: () {
                                        setState(() {
                                          // Toggle the selected state when tapped
                                          selectedItems[index] =
                                          !selectedItems[index];

                                          /// allfalse will be true if all values are false
                                          allFalse = selectedItems.every(
                                                  (element) => element == false);
                                          if (selectedItems[index]) {
                                            String id = item.id.toString();
                                            selectedItemsId[index] = id;
                                            print("id=>${urlKategory.toString()}");

                                          } else {
                                            selectedItemsId[index] = "";
                                          }
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                            );
                        },
                      ),
                    ),

                  );
                },
                transitionBuilder: (context, anim1, anim2, child) {
                  return SlideTransition(
                    position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
                        .animate(anim1),
                    child: child,
                  );
                },
              );
            }, // Image tapped
            child: Container(
              margin: EdgeInsets.all(8),
              height: 40,
              width: 70,
              child: SvgPicture.asset(
                'assets/images/search.svg',
                color: Color.fromRGBO(17, 93, 165, 1),
                alignment: Alignment.topRight,
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey.shade300,
      body: ListView.builder(
        controller: scrollController,
        itemCount: newsItemsArray.length + 1,
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        // Adjust the margin values as needed

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

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        newsDetail(newsSingleFetchItem: item)),
              );
            },
            child: Card(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              // Adjust the margin values as needed
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight:
                          Radius.circular(DefaultConfig.newsCardCornerRadius),
                      topLeft:
                          Radius.circular(DefaultConfig.newsCardCornerRadius),
                      bottomLeft:
                          Radius.circular(DefaultConfig.newsCardCornerRadius),
                      topRight:
                          Radius.circular(DefaultConfig.newsCardCornerRadius)),
                  side: BorderSide(
                      width: 1,
                      color: HexColor(
                          DefaultConfig.mainCollectionViewCellBorderColor))),

              child: Container(
                child: Column(children: [
                  /// Image from top

                  Visibility(
                    visible:
                        item.teaserbild != null && item.teaserbild.isNotEmpty,
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
                              topLeft: Radius.circular(
                                  DefaultConfig.newsCardCornerRadius),
                              topRight: Radius.circular(
                                  DefaultConfig.newsCardCornerRadius)),
                        ),
                      ),
                    ),
                  ),

                  /// date and calendar icon

                  Container(
                    padding: EdgeInsets.fromLTRB(AppConfig.newsCardLeftMargin,
                        10, AppConfig.newsCardRightMargin, 10),
                    // Adjust the margin values as needed
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.calendar_today, // Calendar icon
                          color: Colors.grey, // Adjust the color as needed
                        ),
                        const SizedBox(width: 8),
                        // Adjust the spacing between the icon and text
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 16, // Adjust the font size as needed
                            color:
                                Colors.grey, // Adjust the text color as needed
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// title and subtitle

                  Container(
                    padding: const EdgeInsets.fromLTRB(
                        10, 10, 0, 15), // Adjust the margin values as needed
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.bezeichnung,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontSize: 18, // Adjust the font size as needed
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
                                fontSize: 16, // Adjust the font size as needed
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
                                padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
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
