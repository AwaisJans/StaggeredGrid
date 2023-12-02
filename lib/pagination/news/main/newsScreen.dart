import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late final Dashboard dashboardSingleFetchItem;


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
      // print("checkingFilterStatusASYNC${isFilterActivated.toString()}");
    });

    List<int> itemIds = List.generate(50, (index) => index + 1);

    var beforeCount = newsItemsArray.length;

    var response;

    if (isFilterActivated) {
      String urlFiltered =
          "https://www.empfingen.de/index.php?id=265&baseColor=2727278&baseFontSize=14"
          "&action=getNewsItems$urlKategory&volltext=${enteredText}"
          "&limitStart=$_startLimit&limitAmount=$_limit";
      response = await http.get(Uri.parse(urlFiltered));
      print("true");
    } else {
      String urlUnFiltered =
          "https://www.schaeferlauf-markgroeningen.de/index.php?id=269&baseColor=0571B1&baseFontSize=16"
          "&action=getNewsItems&limitStart=$_startLimit&limitAmount=$_limit";
      response = await http.get(Uri.parse(urlUnFiltered));
      print("false");
    }

    print("checkingFilterStatusASYNC${isFilterActivated.toString()}");
    bool newbool = isFilterActivated;

    if (newbool) {

      String urlFiltered =
          "https://www.empfingen.de/index.php?id=265&baseColor=2727278&baseFontSize=14"
          "&action=getNewsItems$urlKategory&volltext=$enteredText"
          "&limitStart=$_startLimit&limitAmount=$_limit";
      response = await http.get(Uri.parse(urlFiltered));

      print('Using async/await syntax: $voltText');


      print("newbool-true");
    }
    else {
      String urlUnFiltered =
          "https://www.schaeferlauf-markgroeningen.de/index.php?id=269&baseColor=0571B1&baseFontSize=16"
          "&action=getNewsItems&limitStart=$_startLimit&limitAmount=$_limit";
      response = await http.get(Uri.parse(urlUnFiltered));
      print("newbool-false");
    }

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
    retrieveList();
    loadBooleanValue();
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
  String voltText = "";
  List<Filters> newsFilterItemsArray = [];
  List<Filters> Sample = [];

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
        saveBooleanValue(isFilterActivated);
      });

      // Perform any actions after changing the state if needed
    });
  }


  Future<void> _reload(var value) async {}
  List<int> itemIds = List.generate(50, (index) => index + 1);
  bool allFalse = false;
  bool allTextFalse = false;


  String PREF_KEY_VOLT_TEXT = "voltText";





  @override
  Widget build(BuildContext context) {

      print('checked itemsId${urlKategory.toString()}');
      print('checked prefs itemsId${selectedItems}');

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            dashboardSingleFetchItem.navTitle!.toString(),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: const Color.fromRGBO(17, 93, 165, 1),
            onPressed: () {
                saveBooleanValue(false);
                selectedItems = List.generate(
                    newsFilterItemsArray.length,
                        (index) => false);
                storeList(selectedItems);
                textEditingController.clear();

                Navigator.of(context)
                    .pop();
                Navigator.of(context)
                    .pop();
            },
          ),
          actions: [
            GestureDetector(
              onTap: () {
                if (newsFilterItemsArray.isNotEmpty){
                  dialogCode();
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:  Text("No Filters Available"),
                  ));
                  // don't open it
                }
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
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            controller: scrollController,
            slivers: [


              SliverToBoxAdapter(
                child: Column(
                  children: [
                    /// if filter is activted then it will make visible

                    Visibility(
                      visible: isFilterActivated,
                      // Invert the condition to control visibility
                      child: Container(
                        height: 40,
                        color: const Color.fromRGBO(17, 93, 165, 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 50.0),
                                  child: Text(
                                    'Filter is Activated',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.white, // Set cross color to white
                              ),
                              onPressed: () {
                                setState(() {
                                  saveBooleanValue(false);
                                  selectedItems = List.generate(
                                      newsFilterItemsArray.length,
                                          (index) => false);
                                  storeList(selectedItems);
                                  textEditingController.clear();
                                  // storeList(selectedItemsId);
                                  saveStringValue(PREF_KEY_VOLT_TEXT,"");
                                  print("khali nade$urlKategory");
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                      builder: (context) => newsApp(dashboardSingleFetchItem: dashboardSingleFetchItem)))
                                      .then((value) => _reload(value));
                                });
                                // Add any onPressed functionality here
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              ///     ListView  -----------------> News Items
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: newsItemsArray.length + 1,
                      (BuildContext context, int index) {
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
                                bottomRight: Radius.circular(
                                    DefaultConfig.newsCardCornerRadius),
                                topLeft: Radius.circular(
                                    DefaultConfig.newsCardCornerRadius),
                                bottomLeft: Radius.circular(
                                    DefaultConfig.newsCardCornerRadius),
                                topRight: Radius.circular(
                                    DefaultConfig.newsCardCornerRadius)),
                            side: BorderSide(
                                width: 1,
                                color: HexColor(DefaultConfig
                                    .mainCollectionViewCellBorderColor))),

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
                              padding: EdgeInsets.fromLTRB(
                                  AppConfig.newsCardLeftMargin,
                                  10,
                                  AppConfig.newsCardRightMargin,
                                  10),
                              // Adjust the margin values as needed
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.calendar_today, // Calendar icon
                                    color:
                                    Colors.grey, // Adjust the color as needed
                                  ),
                                  const SizedBox(width: 8),
                                  // Adjust the spacing between the icon and text
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      // Adjust the font size as needed
                                      color: Colors
                                          .grey, // Adjust the text color as needed
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// title and subtitle

                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 15),
                              // Adjust the margin values as needed
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      item.bezeichnung,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          // Adjust the font size as needed
                                          color: Colors.black,
                                          // Adjust the text color as needed
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      item.teasertext,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          // Adjust the font size as needed
                                          color: Colors.grey,
                                          // Adjust the text color as needed
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
                                          padding: const EdgeInsets.fromLTRB(
                                              4, 2, 4, 2),
                                          child: Text(
                                            // item.bezeichnung,
                                            item as String,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white),
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
              ),
            ],
          ),
        ),
      );
    }

// -----------> Methods for Current Screen

  /// SharedPrefs Method for saving and getting Booleans
  void loadBooleanValue() async {
    // Use SharedPreferencesHelper to get the boolean value without explicitly handling a Future
    bool value = await SharedPreferencesHelper.getBool('my_boolean_key');
    setState(() {
      isFilterActivated = value;
      print('checked filter boolean${isFilterActivated.toString()}');
    });
  }

  void saveBooleanValue(bool value) async {
    // Use SharedPreferencesHelper to set the boolean value without explicitly handling a Future
    await SharedPreferencesHelper.setBool('my_boolean_key', value);
    // Reload the boolean value
    loadBooleanValue();
  }

  /// SharedPrefs Method for saving and getting String Values
  Future<String> loadStringValue(String key) async {
    // Use SharedPreferencesHelper to get the boolean value without explicitly handling a Future
    String value = await SharedPreferencesHelper.getStr(key);
    return value;
  }

  void saveStringValue(String key,String value) async {
    // Use SharedPreferencesHelper to set the boolean value without explicitly handling a Future
    await SharedPreferencesHelper.setStr(key, value);
    // Reload the boolean value
    loadStringValue(key);
  }

  /// Method for Refresh ListView
  Future<void> _refresh() async {
    // Simulate a network request or any asynchronous operation
    await Future.delayed(Duration(seconds: 1));

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => newsApp(dashboardSingleFetchItem: dashboardSingleFetchItem,)))
        .then((value) => _reload(value));
  }


  Future<void> storeList(List<bool> itemList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the list to a JSON string
    String itemListString = jsonEncode(itemList);

    // Store the JSON string in SharedPreferences
    prefs.setString('itemListKey', itemListString);

    print('List stored in SharedPreferences');
  }

  Future<void> retrieveList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the JSON string from SharedPreferences
    String? itemListString = prefs.getString('itemListKey');



    if (itemListString != null) {
      // Parse the JSON string to get the list directly as List<bool>
      // selectedItems = jsonDecode(itemListString).cast<bool>();
      print("newList$itemListString");

      List<String> items = itemListString.substring(1, itemListString.length - 1).split(',');

      // Convert the string values to boolean
      List<bool> itemList = items.map((item) => item.trim() == 'true').toList();
      selectedItems = itemList ;

      // Display the result
      print("Converted List: $selectedItems");


      // print('Retrieved List: $selectedItems');
    } else {
      print('List not found in SharedPreferences');
    }
  }


  /// Method to show filter dialog
  void dialogCode(){

    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          body: Container(
            margin: const EdgeInsets.only(
                bottom: 0, left: 0, right: 0, top: 30),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(241, 241, 249, 1),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),

            child:
            StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  Row(
                    children: [
                      /// Finish Button
                      Expanded(
                        child: ListTile(
                          title: const Text('Finish',
                              style: TextStyle(
                                color:
                                Color.fromRGBO(17, 93, 165, 1),
                              )),
                          onTap: () async {
                            searchText = textEditingController.text;

                            print('checked items$selectedItems');
                            print(
                                'checked itemsId$selectedItemsId');
                            print('Entered Text: ${loadStringValue(PREF_KEY_VOLT_TEXT)}');

                            setState(() {
                              // isFilterActivated = true;

                              // Check if each item in the list is empty using item.equals("")
                              bool allItemsEmpty = true;
                              Set<String> uniqueItems = {};
                              // retrieveList();


                              // for (String item in selectedItemsId) {
                              //   print("new->$item");
                              //   if (item == "") {
                              //     // If any item is not empty, set the flag to false and break the loop
                              //     allItemsEmpty = false;
                              //     // uniqueItems
                              //     //     .add("&kategories[]=$item");
                              //   } else {
                              //     allItemsEmpty = true;
                              //     // strKategory = "&kategories[]=$item";
                              //     uniqueItems
                              //         .add("&kategories[]=$item");
                              //   }
                              // }


                              List<String> nonEmptyItems = selectedItemsId.where((item) => item.isNotEmpty).toList();

                              // Print the non-empty items
                              print("Non-empty items: $nonEmptyItems");
                              for (String item in nonEmptyItems) {

                                if (item == "") {
                                  // If any item is not empty, set the flag to false and break the loop
                                  allItemsEmpty = true;
                                  // uniqueItems
                                  //     .add("&kategories[]=$item");
                                } else {
                                  allItemsEmpty = false;
                                  // strKategory = "&kategories[]=$item";
                                  uniqueItems
                                      .add("&kategories[]=$item");
                                }
                              }


                              if (allItemsEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("empty"),
                                ));
                                urlKategory = "";
                              } else {
                                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                //   content: Text("not empty"),
                                // ));
                                setState(() {
                                  urlKategory =
                                      uniqueItems.join("");
                                  print("khali nade$urlKategory");

                                  if (uniqueItems.isEmpty) {
                                  } else {
                                    performDelayedSetState();
                                    showDialog(
                                        context: context,
                                        builder:
                                            (BuildContext context) {
                                          return const AlertDialog();
                                        }).then((value) {
                                      showDialog(
                                        // Second dialog open
                                        context: context,
                                        builder:
                                            (BuildContext context) {
                                          Future.delayed(
                                              const Duration(
                                                  seconds: 2), () {
                                            Navigator.of(context)
                                                .pop(true);
                                            Navigator.of(context)
                                                .pop(true);
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                    newsApp(dashboardSingleFetchItem: dashboardSingleFetchItem,)))
                                                .then((value) =>
                                                _reload(value));
                                          });
                                          return const AlertDialog(
                                            content: Column(
                                              mainAxisSize:
                                              MainAxisSize.min,
                                              children: [
                                                CircularProgressIndicator(),
                                                SizedBox(
                                                    height: 16.0),
                                                Text(
                                                    'Loading Items...'),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    });
                                  }
                                });
                              }
                            });

                            Navigator.pop(context);
                          },
                        ),
                      ),
                      /// Filter Text
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
                      /// Reset Button
                      Expanded(
                        child: Visibility(
                          maintainState: true,
                          visible: allFalse || allTextFalse,
                          child:
                          ListTile(
                            title: const Align(
                              alignment: Alignment.topRight,
                              child: Text('Reset',
                                  style: TextStyle(
                                    color: Color.fromRGBO(
                                        17, 93, 165, 1),
                                  )),
                            ),
                            onTap: () {
                              setState(() {
                                selectedItems = List.generate(
                                    newsFilterItemsArray.length,
                                        (index) => false);
                                textEditingController.clear();
                                saveBooleanValue(false);
                                saveStringValue(PREF_KEY_VOLT_TEXT,"");
                                // storeList(selectedItemsId);
                                setState(() {
                                  allFalse = false;
                                  allTextFalse = false;
                                  print(
                                      "${allFalse.toString()} and ${allTextFalse.toString()}");
                                });
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                            children: [
                              /// Search Text Heading
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
                              /// Search Box
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
                                      saveStringValue(PREF_KEY_VOLT_TEXT, enteredText);
                                      setState((){
                                        if (enteredText == "" || enteredText.isEmpty){
                                          allTextFalse = false;
                                          allFalse = false;
                                        }else{
                                          allTextFalse = true;
                                          allFalse = true;
                                        }

                                      });
                                    },
                                  ),
                                ),
                              ),
                              /// Categories Heading
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
                              /// Filter List Appears here
                              ListView.separated(
                                itemCount: newsFilterItemsArray.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),// Allow the GridView to wrap its content
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                const Divider(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  Filters item = newsFilterItemsArray[index];


                                  return Container(
                                    color: Colors.white,
                                    child: ListTile(
                                      title: Text(item.bezeichnung.toString()),
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

                                          storeList(selectedItems);

                                          /// allfalse will be true if all values are false

                                          if (selectedItems[index]) {
                                            String id = item.id.toString();
                                            selectedItemsId[index] = id;
                                            // storeList(selectedItemsId);
                                            print("id=>${urlKategory.toString()}");
                                            setState((){
                                              allFalse = true;
                                              allTextFalse = true;
                                            });

                                          } else {
                                            selectedItemsId[index] = "";
                                            setState((){
                                              if (selectedItems.every((element) => element == false))
                                                {
                                                  allFalse = false;
                                                  allTextFalse = false;
                                                }

                                            });
                                          }
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ]
                        ),
                      ),
                    ),
                  ),
                ],
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
  }

}

class SharedPreferencesHelper {

  // Methods to get Boolean Values
  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }
  static Future<void> setBool(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
  // Methods to get Boolean Values
  static Future<String> getStr(String key, {String defaultValue = ""}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? defaultValue;
  }

  static Future<void> setStr(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }


}

