import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/base/locker_room/model/graph_data_model.dart';
import 'package:shot_locker/base/locker_room/graph/widgets/helper/graph_data_helper.dart';
import 'package:shot_locker/base/locker_room/graph/widgets/sample_chat_data.dart';
import 'package:shot_locker/utility/data_color_scheme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ApproacheShortGraphChart extends StatefulWidget {
  final ApproachesModel approachesModel;
  const ApproacheShortGraphChart({
    Key? key,
    required this.approachesModel,
  }) : super(key: key);

  @override
  _ApproacheShortGraphChartState createState() =>
      _ApproacheShortGraphChartState();
}

class _ApproacheShortGraphChartState extends State<ApproacheShortGraphChart> {
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
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      child: SfCartesianChart(
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
            x: '226+ yds',
            y: (double.parse(widget.approachesModel.the226Yds.val226Yds)),
            pointColor: DataColorScheme.dataColor(
              data: (widget.approachesModel.the226Yds.val226Yds),
            ),
          ),
          ChartSampleData(
            x: '176-226 yds',
            y: (double.parse(widget.approachesModel.the176226Yds.val176226Yds)),
            pointColor: DataColorScheme.dataColor(
              data: (widget.approachesModel.the176226Yds.val176226Yds),
            ),
          ),
          ChartSampleData(
            x: '126-175 yds',
            y: double.parse(widget.approachesModel.the126175Yds.val126175Yds),
            pointColor: DataColorScheme.dataColor(
              data: (widget.approachesModel.the126175Yds.val126175Yds),
            ),
          ),
          ChartSampleData(
            x: '50-125 yds',
            y: double.parse(widget.approachesModel.the50125Yds.val50125Yds),
            pointColor: DataColorScheme.dataColor(
              data: (widget.approachesModel.the50125Yds.val50125Yds),
            ),
          ),
        ]),
        tooltipBehavior: _tooltipBehavior,
      ),
    );
  }
}
