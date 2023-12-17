import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MyImageView extends StatefulWidget {
  List<String>? imgList;

  MyImageView({super.key, required this.imgList});

  @override
  _MyImageViewState createState() => _MyImageViewState();
}

class _MyImageViewState extends State<MyImageView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body:

        Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.imgList!.length,
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              pageController: PageController(),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 30,top: 30),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context)
                          .pop();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    String item = widget.imgList![index];
    if (!item.endsWith(".jpg") | !item.endsWith(".jpg")){
      item = "https://www.empfingen.de/fileadmin/_processed_/6/1/csm_10.10.2023_Bild_2_e2edca7543.jpeg";
    }
    return  PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(item),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: index),
    );
  }


}








