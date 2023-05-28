import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/base/locker_room/graph/widgets/sample_chat_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphColumnDataHandler {
  List<ColumnSeries<ChartSampleData, String>> getDefaultColumnSeries(
      {required List<ChartSampleData> chartData}) {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(fontSize: 10),
        ),
      )
    ];
  }
}

class TableHeading extends StatelessWidget {
  final String label;

  const TableHeading({Key? key, required this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Text(label),
    ));
  }
}

class TableEntry extends StatelessWidget {
  final String value;

  const TableEntry({Key? key, this.value = '1.0'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(value),
    ));
  }
}
