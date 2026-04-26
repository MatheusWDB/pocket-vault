import 'package:flutter/material.dart';

class CategoryColorUtils {
  CategoryColorUtils._();

  static Color getCategoryColor(int? id) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.amber,
      Colors.purple,
      Colors.cyan,
      Colors.orange,
      Colors.indigo,
      Colors.teal,
      Colors.pink,
      Colors.lime,
      Colors.deepPurple,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.deepOrange,

      Colors.blueAccent,
      Colors.redAccent,
      Colors.greenAccent,
      Colors.amberAccent,
      Colors.purpleAccent,
      Colors.cyanAccent,
      Colors.orangeAccent,
      Colors.indigoAccent,
      Colors.tealAccent,
      Colors.pinkAccent,
      Colors.limeAccent,
      Colors.deepPurpleAccent,
      Colors.lightBlueAccent,
      Colors.lightGreenAccent,
      Colors.deepOrangeAccent,

      Colors.blueGrey,
      Colors.brown,
      Colors.grey,
      Colors.black,
      Colors.yellow,
      Colors.blue[900]!,
      Colors.red[900]!,
      Colors.green[900]!,
      Colors.brown[300]!,
      Colors.grey[400]!,
    ];
    return colors[(id ?? 0) % colors.length];
  }
}
