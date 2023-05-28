import 'package:flutter/material.dart';
import 'package:shot_locker/base/locker_room/graph/widgets/helper/graph_data_helper.dart';
import 'package:shot_locker/base/locker_room/model/graph_data_model.dart';

class PuttingChartTable extends StatelessWidget {
  final PuttingModel puttingModel;
  const PuttingChartTable({
    Key? key,
    required this.puttingModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return Table(
      defaultColumnWidth: FixedColumnWidth(_deviceSize.width * 0.25),
      border: TableBorder.all(
        color: Colors.white,
        style: BorderStyle.solid,
        width: 1.5,
      ),
      children: [
        const TableRow(children: [
          TableHeading(label: 'OVER 15'),
          TableHeading(label: '5 TO 15'),
          TableHeading(label: 'UNDER 5'),
        ]),
        TableRow(children: [
          TableEntry(value: puttingModel.over15.valOver15),
          TableEntry(value: puttingModel.the515.val515),
          TableEntry(value: puttingModel.under5.valUnder5),
        ]),
      ],
    );
  }
}
