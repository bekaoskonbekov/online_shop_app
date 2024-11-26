import 'package:flutter/material.dart';

class CategoryPathWidget extends StatelessWidget {
  final List<String> path;

  const CategoryPathWidget({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: path.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) => _buildPathItem(context, index),
        separatorBuilder: (_, __) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.chevron_right, size: 16),
        ),
      ),
    );
  }

  Widget _buildPathItem(BuildContext context, int index) {
    final isLast = index == path.length - 1;
    return Center(
      child: GestureDetector(
        onTap: isLast ? null : () => Navigator.of(context).pop(),
        child: Text(
          path[index],
          style: TextStyle(
            color: Colors.blue,
            fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
