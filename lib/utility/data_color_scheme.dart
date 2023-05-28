import 'package:flutter/material.dart';

class DataColorScheme {
  static Color dataColor({required String data}) {
    final numData = double.parse(data);
    if (numData < 0) {
      return const Color(0xffFF3131);
    } else if (numData == 0) {
      return Colors.white;
    } else {
      return const Color(0xff39FF14);
    }
  }
}
