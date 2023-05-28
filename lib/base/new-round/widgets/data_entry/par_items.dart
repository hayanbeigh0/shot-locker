import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shot_locker/base/new-round/logic/rounds_data_entry_manager/rounds_data_entry_manager_dart_cubit.dart';
import 'package:shot_locker/base/new-round/logic/shot_counter/shot_counter_cubit.dart';

class ParItems extends StatefulWidget {
  const ParItems({Key? key}) : super(key: key);

  @override
  State<ParItems> createState() => _ParItemsState();
}

class _ParItemsState extends State<ParItems> {
  @override
  Widget build(BuildContext context) {
    final List<int> _items =
        BlocProvider.of<RoundsDataEntryManagerDartCubit>(context).shotCountList;
    return SizedBox(
      height: 65.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return BlocBuilder<ShotCounterCubit, ShotCounterState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 15.0,
                ),
                child: Chip(
                  backgroundColor: state.currentShot == _items[index]
                      ? Colors.blue
                      : Colors.grey,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 5.0,
                  ),
                  label: Text(
                    'Shot ${_items[index]}',
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
