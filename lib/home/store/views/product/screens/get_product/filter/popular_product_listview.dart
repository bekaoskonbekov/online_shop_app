import 'package:flutter/material.dart';

class PopularProductListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          // Build item for popular products
          return Container(); // Replace with actual product item widget
        },
      ),
    );
  }
}
