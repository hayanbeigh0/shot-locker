import 'package:flutter/material.dart';

///Chart sample data
class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData({
    required this.x,
    required this.y,
    required this.pointColor,
  });

  /// Holds x value of the datapoint
  final String x;

  /// Holds y value of the datapoint
  final num y;

  /// Holds point color of the datapoint
  final Color pointColor;
}
