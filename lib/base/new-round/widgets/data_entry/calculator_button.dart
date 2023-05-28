import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final void Function(String selectedValue) onTap;
  final Color labelColor;

  const CalculatorButton({
    Key? key,
    required this.label,
    required this.onTap,
    required this.labelColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          border: Border.all(color: labelColor),
          borderRadius: BorderRadius.all(Radius.circular(6.r)),
        ),
        child: InkWell(
          onTap: () => onTap.call(label),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                color: labelColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
