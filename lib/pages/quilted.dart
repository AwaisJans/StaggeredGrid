import 'package:flutter/material.dart';
import 'package:test_project/common.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class QuiltedPage extends StatelessWidget {
  const QuiltedPage({
    Key? key,
  }) : super(key: key);





  static const pattern = [
    QuiltedGridTile(2, 2),
    QuiltedGridTile(1, 1),
    QuiltedGridTile(1, 1),
    QuiltedGridTile(1, 1),
    QuiltedGridTile(1, 1),
    QuiltedGridTile(1, 1),
    QuiltedGridTile(1, 3),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'QuiltedTest',
      child: GridView.custom(
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          repeatPattern: QuiltedGridRepeatPattern.mirrored,
          pattern: pattern,
        ),
        childrenDelegate: SliverChildBuilderDelegate(
              (context, index) => Container(
            color: Colors.cyanAccent,
            child: Text("$index"),
          ),
          childCount: 7,
      ),
      ),
    );
  }
}
