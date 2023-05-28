import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/base/new-round/widgets/show_dialog_content_widget.dart';
import 'package:shot_locker/constants/constants.dart';

class SelectHoleTypeWidget extends StatefulWidget {
  final String selectedOption;
  final String showDialogHeading;
  final List<ShowDialogContentWidget> showDialogContents;
  final void Function(String selectedValue) onValueSelected;

  const SelectHoleTypeWidget({
    Key? key,
    required this.selectedOption,
    required this.showDialogHeading,
    required this.showDialogContents,
    required this.onValueSelected,
  }) : super(key: key);

  @override
  _SelectHoleTypeWidgetState createState() => _SelectHoleTypeWidgetState();
}

class _SelectHoleTypeWidgetState extends State<SelectHoleTypeWidget> {
  String? updatedSelectedValue;
  Future<dynamic> _showMyDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Constants.boxBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
            side: const BorderSide(color: Colors.white),
          ),
          title: Text(
            widget.showDialogHeading,
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.showDialogContents,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    updatedSelectedValue = widget.selectedOption;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          updatedSelectedValue ?? 'N/A',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        IconButton(
          onPressed: () async {
            await HapticFeedback.lightImpact();
            await _showMyDialog().then((selectedValue) {
              if (selectedValue == null) {
                // ShowSnackBar.showSnackBar(
                //   context,
                //   'Please select a option.',
                // );
                return;
              } else {
                setState(() {
                  //Update the currently selected value
                  updatedSelectedValue = selectedValue;
                });
                widget.onValueSelected.call(selectedValue);
                return;
              }
            });
          },
          icon: const Icon(
            Icons.arrow_drop_down_circle_outlined,
          ),
        )
      ],
    );
  }
}
