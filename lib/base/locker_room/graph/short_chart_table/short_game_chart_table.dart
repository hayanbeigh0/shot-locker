import 'package:flutter/material.dart';
import 'package:shot_locker/base/locker_room/graph/widgets/helper/graph_data_helper.dart';
import 'package:shot_locker/base/locker_room/model/graph_data_model.dart';

class ShortGameChartTable extends StatelessWidget {
  final ShortGameModel shortGameModel;
  const ShortGameChartTable({
    Key? key,
    required this.shortGameModel,
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
          TableHeading(label: '31-50 yds'),
          TableHeading(label: '10-30 yds'),
          TableHeading(label: 'BUNKER'),
        ]),
        TableRow(children: [
          TableEntry(value: shortGameModel.the3150Yds.val3150Yds),
          TableEntry(value: shortGameModel.the1030Yds.val1030Yds),
          TableEntry(value: shortGameModel.bunker.valBunker),
        ]),
      ],
    );
  }
}
