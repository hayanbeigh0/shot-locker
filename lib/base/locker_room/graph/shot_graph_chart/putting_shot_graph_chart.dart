import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/base/locker_room/model/graph_data_model.dart';
import 'package:shot_locker/base/locker_room/graph/widgets/helper/graph_data_helper.dart';
import 'package:shot_locker/base/locker_room/graph/widgets/sample_chat_data.dart';
import 'package:shot_locker/utility/data_color_scheme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PuttingShortGraphChart extends StatefulWidget {
  final PuttingModel puttingModel;
  const PuttingShortGraphChart({
    Key? key,
    required this.puttingModel,
  }) : super(key: key);

  @override
  _PuttingShortGraphChartState createState() => _PuttingShortGraphChartState();
}

class _PuttingShortGraphChartState extends State<PuttingShortGraphChart> {
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: SfCartesianChart(
        palette: [
          DataColorScheme.dataColor(
            data: widget.puttingModel.the515.val515,
          ),
        ],
        plotAreaBorderWidth: 0,
        title: ChartTitle(borderColor: Colors.green),
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0, color: Colors.green),
        ),
        primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 2, color: Colors.grey),
          labelFormat: '{value}',
          majorTickLines: const MajorTickLines(size: 0),
        ),
        series: GraphColumnDataHandler()
            .getDefaultColumnSeries(chartData: <ChartSampleData>[
          ChartSampleData(
            x: 'OVER 15',
            y: (double.parse(widget.puttingModel.over15.valOver15)),
            pointColor: DataColorScheme.dataColor(
              data: (widget.puttingModel.over15.valOver15),
            ),
          ),
          ChartSampleData(
            x: '5 TO 15',
            y: (double.parse(widget.puttingModel.the515.val515)),
            pointColor: DataColorScheme.dataColor(
              data: (widget.puttingModel.the515.val515),
            ),
          ),
          ChartSampleData(
            x: 'UNDER 5',
            y: double.parse(widget.puttingModel.under5.valUnder5),
            pointColor: DataColorScheme.dataColor(
              data: (widget.puttingModel.under5.valUnder5),
            ),
          ),
        ]),
        tooltipBehavior: _tooltipBehavior,
      ),
    );
  }
}
