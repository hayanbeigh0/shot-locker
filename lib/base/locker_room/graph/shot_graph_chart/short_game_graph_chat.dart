import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/base/locker_room/model/graph_data_model.dart';
import 'package:shot_locker/base/locker_room/graph/widgets/helper/graph_data_helper.dart';
import 'package:shot_locker/base/locker_room/graph/widgets/sample_chat_data.dart';
import 'package:shot_locker/utility/data_color_scheme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ShortGameGraphChart extends StatefulWidget {
  final ShortGameModel shortGameModel;
  const ShortGameGraphChart({
    Key? key,
    required this.shortGameModel,
  }) : super(key: key);

  @override
  _ShortGameGraphChartState createState() => _ShortGameGraphChartState();
}

class _ShortGameGraphChartState extends State<ShortGameGraphChart> {
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
            data: widget.shortGameModel.the1030Yds.val1030Yds,
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
            x: '31-50 yds',
            y: (double.parse(widget.shortGameModel.the3150Yds.val3150Yds)),
            pointColor: DataColorScheme.dataColor(
              data: (widget.shortGameModel.the3150Yds.val3150Yds),
            ),
          ),
          ChartSampleData(
            x: '10-30 yds',
            y: (double.parse(widget.shortGameModel.the1030Yds.val1030Yds)),
            pointColor: DataColorScheme.dataColor(
              data: (widget.shortGameModel.the1030Yds.val1030Yds),
            ),
          ),
          ChartSampleData(
            x: 'BUNKER',
            y: double.parse(widget.shortGameModel.bunker.valBunker),
            pointColor: DataColorScheme.dataColor(
              data: (widget.shortGameModel.bunker.valBunker),
            ),
          ),
        ]),
        tooltipBehavior: _tooltipBehavior,
      ),
    );
  }
}
