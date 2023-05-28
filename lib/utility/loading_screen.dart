import 'package:flutter/material.dart';
import 'package:shot_locker/utility/back_ground_theme.dart';
import 'package:shot_locker/utility/loading_indicator.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: ShotLockerBackgroundTheme(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: LoadingIndicator(),
            ),
          ),
        ),
      );
}
