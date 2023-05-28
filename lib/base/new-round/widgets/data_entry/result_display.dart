import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/base/new-round/logic/numberpad/numberpaddata_cubit.dart';
import 'package:shot_locker/base/new-round/logic/surface_selector/surface_selector_cubit.dart';

class ResultDisplay extends StatelessWidget {
  const ResultDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: Colors.white, fontSize: 28.sp);
    return Container(
      alignment: Alignment.bottomRight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
        color: Colors.transparent,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 10.h,
        ),
        child: Wrap(
          children: [
            BlocBuilder<SurfaceSelectorCubit, SurfaceSelectorState>(
              builder: (context, state) {
                return Text(
                  '${state.currentSurface} ',
                  style: textStyle,
                );
              },
            ),
            BlocBuilder<NumberPadDataCubit, NumberPadDataState>(
              builder: (context, state) {
                return Text(
                  '${state.currentText} ',
                  style: textStyle,
                );
              },
            ),
            BlocBuilder<SurfaceSelectorCubit, SurfaceSelectorState>(
              builder: (context, state) {
                return Text(
                  state.currentSurface.contains('Green') ? 'feet' : 'yards',
                  style: textStyle,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
