import 'package:flutter/material.dart';
import 'package:shot_locker/base/locker_room/graph/widgets/helper/graph_data_helper.dart';
import 'package:shot_locker/base/locker_room/model/graph_data_model.dart';

class ApproacheChartTable extends StatelessWidget {
  final ApproachesModel approachesModel;
  const ApproacheChartTable({
    Key? key,
    required this.approachesModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return Expanded(
      child: Table(
        columnWidths: {
          0: FlexColumnWidth(_deviceSize.width * 0.2),
          1: FlexColumnWidth(_deviceSize.width * 0.25),
          2: FlexColumnWidth(_deviceSize.width * 0.25),
          3: FlexColumnWidth(_deviceSize.width * 0.25),
        },
        // defaultColumnWidth: FixedColumnWidth(_deviceSize.width * 0.25),
        border: TableBorder.all(
          color: Colors.white,
          style: BorderStyle.solid,
          width: 1.5,
        ),
        children: [
          const TableRow(children: [
            TableHeading(label: '226+'),
            TableHeading(label: '176-226'),
            TableHeading(label: '126-175'),
            TableHeading(label: '50-125'),
          ]),
          TableRow(children: [
            TableEntry(value: approachesModel.the226Yds.val226Yds),
            TableEntry(value: approachesModel.the176226Yds.val176226Yds),
            TableEntry(value: approachesModel.the126175Yds.val126175Yds),
            TableEntry(value: approachesModel.the50125Yds.val50125Yds),
          ]),
        ],
      ),
    );
  }
}
