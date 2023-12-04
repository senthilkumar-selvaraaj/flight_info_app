import 'package:flutter/material.dart';

class AppSnackBar {
  static void show(BuildContext context, String title) {
// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      content: Text(title),));
  }
}
