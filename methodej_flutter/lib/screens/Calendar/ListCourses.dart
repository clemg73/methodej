import 'package:flutter/material.dart';
import '../../models/course.dart';
import 'CourseItem.dart';

class CoursesList extends StatelessWidget {
  final List<Course> items;

  CoursesList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 230),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return CourseItem(item: items[index]);
      },
    );
  }
}
