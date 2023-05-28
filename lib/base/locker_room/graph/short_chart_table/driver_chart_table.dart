import 'package:flutter/material.dart';
import 'package:shot_locker/base/locker_room/graph/widgets/helper/graph_data_helper.dart';
import 'package:shot_locker/base/locker_room/model/graph_data_model.dart';

class DriverChartTable extends StatelessWidget {
  final DriverModel driverModel;

  const DriverChartTable({
    Key? key,
    required this.driverModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return Table(
      defaultColumnWidth: FixedColumnWidth(_deviceSize.width * 0.3),
      border: TableBorder.all(
        color: Colors.white,
        style: BorderStyle.solid,
        width: 1.5,
      ),
      children: [
        const TableRow(children: [
          TableHeading(label: 'TEE SHOTS'),
        ]),
        TableRow(children: [
          TableEntry(value: driverModel.driver),
        ]),
      ],
    );
  }
}
