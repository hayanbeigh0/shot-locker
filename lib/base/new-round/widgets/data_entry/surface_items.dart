// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/base/new-round/logic/rounds_data_entry_manager/rounds_data_entry_manager_dart_cubit.dart';
import 'package:shot_locker/base/new-round/logic/shot_counter/shot_counter_cubit.dart';
import 'package:shot_locker/base/new-round/logic/surface_selector/surface_selector_cubit.dart';

class SurfaceItems extends StatelessWidget {
  const SurfaceItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _deviceSize = MediaQuery.of(context).size;

    final roundDataManagerCubit =
        BlocProvider.of<RoundsDataEntryManagerDartCubit>(context);
    return SizedBox(
      height: 90.h,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 6.w / 2.h,
          mainAxisSpacing: 5.h,
        ),
        itemCount: roundDataManagerCubit.surfaceType.length,
        itemBuilder: (context, index) {
          return BlocBuilder<ShotCounterCubit, ShotCounterState>(
            builder: (context, shotState) {
              return BlocBuilder<SurfaceSelectorCubit, SurfaceSelectorState>(
                builder: (context, state) => Visibility(
                  visible: index < roundDataManagerCubit.surfaceType.length - 1,
                  child: InkWell(
                    onTap: () async {
                      await HapticFeedback.lightImpact();
                      if (shotState.currentShot != 1) {
                        await BlocProvider.of<RoundsDataEntryManagerDartCubit>(
                                context)
                            .onSurfaceSelected(index: index);
                      }
                      return;
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 2.h,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: roundDataManagerCubit.surfaceType[index] ==
                                    state.currentSurface
                                ? Colors.black
                                : Colors.white,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(6.r)),
                          color: roundDataManagerCubit.surfaceType[index] ==
                                  state.currentSurface
                              ? Colors.green
                              : Colors.transparent,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                        ),
                        child: Text(
                          roundDataManagerCubit.surfaceType[index],
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
