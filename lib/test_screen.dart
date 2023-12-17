import 'dart:convert';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: testView()));
}

class testView extends StatefulWidget {
  @override
  _testViewState createState() => _testViewState();
}

class _testViewState extends State<testView> {
  List<Product>? productsData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      List<dynamic> data = json.decode(response.body);
      setState(() {
        productsData = data.map((item) => Product.fromJson(item)).toList();
        print('JSON Data: $productsData');
      });
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
    }
  }

  static const pattern = [
    QuiltedGridTile(2, 2),
    QuiltedGridTile(4, 2),
    QuiltedGridTile(2, 2),
    QuiltedGridTile(2, 4),
    QuiltedGridTile(2, 2),
    QuiltedGridTile(2, 2),
    QuiltedGridTile(2, 4)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,

        /// Title Name
        title: const Text(
          "Products",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.grey,
      body: Center(
        child: productsData == null
            ? CircularProgressIndicator() // Show loading indicator if data is being fetched
            : GridView.builder(
                shrinkWrap: true,
                // Allow the GridView to wrap its content
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: productsData!.length,
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                // Set padding for the whole GridView
                gridDelegate: SliverQuiltedGridDelegate(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  repeatPattern: QuiltedGridRepeatPattern.same,
                  pattern: pattern,
                ),

                itemBuilder: (context, index) {
                  Product item = productsData![index];

                  return GestureDetector(
                    onTap: () {
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //   content: Text(snapshot.data!.dashboard![index].title),
                      // ));
                    },
                    child: ProductCard(
                      title: item.title,
                      price: 22.3,
                      description: item.description,
                      category: item.category,
                      imageUrl: item.image,
                      rating: 4.1,
                    )
                  );
                },
              ),
      ),
    );
  }
}


class ProductCard extends StatelessWidget {
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;

  ProductCard({
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.0),
                Text(
                  'Category: $category',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 8.0),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow),
                    SizedBox(width: 4.0),
                    Text(
                      '$rating',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: Rating.fromJson(json['rating']),
    );
  }
}

class Rating {
  final double rate;
  final int count;

  Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: json['rate'].toDouble(),
      count: json['count'],
    );
  }
}
