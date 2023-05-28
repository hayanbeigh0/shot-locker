import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shot_locker/constants/constants.dart';

class TableCalendarWidget extends StatefulWidget {
  final DateTime firstDay;
  final DateTime lastDay;
  final void Function(DateTime) onDateSelected;
  const TableCalendarWidget({
    Key? key,
    required this.firstDay,
    required this.lastDay,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<TableCalendarWidget> createState() => _TableCalendarWidgetState();
}

class _TableCalendarWidgetState extends State<TableCalendarWidget> {
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  BoxDecoration _boxDecoration({Color? boxColor, Color? boxBorderColor}) =>
      BoxDecoration(
        color: boxColor,
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: boxBorderColor ?? Colors.transparent),
      );
  final _titleTextStyleStyle = GoogleFonts.poppins(
      textStyle: TextStyle(
    color: Constants.calendarTextColor,
    fontWeight: FontWeight.w500,
    fontSize: 18,
  ));
  final _daysOfWeekTextStyleStyle = GoogleFonts.poppins(
      textStyle: TextStyle(
    color: Constants.calendarTextColor,
    fontWeight: FontWeight.w500,
    fontSize: 14,
  ));

  TextStyle _calendarTextStyleStyle(
          {Color? textColor, required FontWeight fontWeight}) =>
      GoogleFonts.poppins(
          textStyle: TextStyle(
        color: textColor ?? Colors.black,
        fontWeight: fontWeight,
        fontSize: 14,
      ));

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: widget.firstDay,
      lastDay: widget.lastDay,
      focusedDay: _focusedDay,
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      rangeSelectionMode: _rangeSelectionMode,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
        rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white),
        titleTextStyle: _titleTextStyleStyle,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: _daysOfWeekTextStyleStyle,
        weekendStyle: _daysOfWeekTextStyleStyle,
      ),
      calendarStyle: CalendarStyle(
        rangeHighlightColor: Colors.transparent,
        selectedDecoration: _boxDecoration(
          boxColor: Constants.calendarBackgroundColor,
        ),
        selectedTextStyle: _calendarTextStyleStyle(fontWeight: FontWeight.w500),
        weekendTextStyle: _calendarTextStyleStyle(
          textColor: Constants.calendarTextColor,
          fontWeight: FontWeight.w500,
        ),
        weekendDecoration: _boxDecoration(),
        disabledDecoration: _boxDecoration(),
        disabledTextStyle: _calendarTextStyleStyle(
          textColor: Colors.white24,
          fontWeight: FontWeight.w100,
        ),
        defaultDecoration: _boxDecoration(),
        defaultTextStyle: _calendarTextStyleStyle(
          textColor: Constants.calendarTextColor,
          fontWeight: FontWeight.w500,
        ),
        outsideDecoration: _boxDecoration(),
        outsideTextStyle: _calendarTextStyleStyle(
          textColor: Colors.white30,
          fontWeight: FontWeight.w500,
        ),
        rangeStartDecoration: _boxDecoration(
          boxColor: Constants.calendarBackgroundColor,
        ),
        rangeStartTextStyle: _calendarTextStyleStyle(
          fontWeight: isSameDay(_rangeStart, DateTime.now())
              ? FontWeight.w600
              : FontWeight.w400,
        ),
        rangeEndDecoration: _boxDecoration(
          boxColor: Constants.calendarBackgroundColor,
        ),
        withinRangeDecoration: _boxDecoration(
          boxColor: Constants.calendarBackgroundColor,
        ),
        withinRangeTextStyle: _calendarTextStyleStyle(
          textColor: Constants.calendarTextColor,
          fontWeight: FontWeight.w500,
        ),
        todayDecoration: _boxDecoration(
          boxBorderColor: Constants.calendarTextColor,
        ),
        todayTextStyle: _calendarTextStyleStyle(
          fontWeight: FontWeight.w600,
          textColor: Constants.calendarTextColor,
        ),
      ),
      onDaySelected: (selectedDay, focusedDay) async {
        if (!isSameDay(_selectedDay, selectedDay)) {
          await HapticFeedback.lightImpact();
          widget.onDateSelected(selectedDay);
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _rangeStart = null; // Important to clean those
            _rangeEnd = null;
            _rangeSelectionMode = RangeSelectionMode.toggledOff;
          });
        }
      },
    );
  }
}
