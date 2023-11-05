import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test_project/pagination/dashboardViews/common.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class QuiltedPage extends StatelessWidget {
  const QuiltedPage({
    Key? key,
  }) : super(key: key);

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
    return AppScaffold(
      title: 'QuiltedTest',
      child: GridView.custom(
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          repeatPattern: QuiltedGridRepeatPattern.same,
          pattern: pattern,
        ),
        childrenDelegate: SliverChildBuilderDelegate(
              (context, index) => Container(
            color: Colors.cyanAccent,
            child: Text("$index"),
          ),
          childCount: 14,
      ),
      ),
    );
  }
}
