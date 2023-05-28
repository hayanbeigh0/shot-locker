import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/base/locker_room/model/graph_data_model.dart';
import 'package:shot_locker/base/locker_room/graph/widgets/helper/graph_data_helper.dart';
import 'package:shot_locker/base/locker_room/graph/widgets/sample_chat_data.dart';
import 'package:shot_locker/utility/data_color_scheme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DriverShotGraphChart extends StatefulWidget {
  final DriverModel driverModel;
  const DriverShotGraphChart({
    Key? key,
    required this.driverModel,
  }) : super(key: key);

  @override
  _DriverShotGraphChartState createState() => _DriverShotGraphChartState();
}

class _DriverShotGraphChartState extends State<DriverShotGraphChart> {
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
            data: widget.driverModel.driver,
          ),
        ],
        plotAreaBorderWidth: 0,
        title: ChartTitle(borderColor: Colors.green),
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 2.w, color: Colors.grey),
          labelFormat: '{value}',
          majorTickLines: const MajorTickLines(size: 0),
        ),
        series: GraphColumnDataHandler().getDefaultColumnSeries(
          chartData: <ChartSampleData>[
            ChartSampleData(
              x: 'Tee shots',
              y: widget.driverModel.driver == 'null'
                  ? 0
                  : (double.parse(widget.driverModel.driver)),
              pointColor: DataColorScheme.dataColor(
                data: (widget.driverModel.driver),
              ),
            ),
          ],
        ),
        tooltipBehavior: _tooltipBehavior,
      ),
    );
  }
}
