import 'package:flutter/material.dart';
import 'package:shot_locker/base/new-round/screens/round_entry_screens/rounds_entry_screen.dart';

class TimeSelector extends StatefulWidget {
  const TimeSelector({
    Key? key,
  }) : super(key: key);

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  // DateTime? _dateTime;
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectTime() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // _dateTime = DateTime.now();

    //  final DateFormat formatter = DateFormat('dd - MM - yyyy');

    // final String formattedDate =
    //     _dateTime != null ? formatter.format(_dateTime!) : '';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const IconLabel(
          icon: Icons.schedule,
          label: 'Time',
        ),
        Text(
          '${selectedTime.hour}:${selectedTime.minute}',
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.blue,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: _selectTime,
          icon: const Icon(
            Icons.arrow_drop_down_circle_outlined,
          ),
        )
      ],
    );
  }
}
