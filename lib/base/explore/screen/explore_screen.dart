import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shot_locker/base/logic/go_to_home/go_to_home_cubit.dart';
import 'package:shot_locker/config/.env.dart';
import 'package:shot_locker/utility/back_ground_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  Future<bool> willPopScope(BuildContext context) async {
    await BlocProvider.of<GoToHomeCubit>(context).goToHome();
    //Return false to not to close the app when the back button will triggered.
    return false;
  }

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => willPopScope(context),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: const Text(
            'Explore',
            style: TextStyle(
              letterSpacing: 1.2,
            ),
          ),
        ),
        body: const ShotLockerBackgroundTheme(
          child: WebView(
            initialUrl: twitterLink,
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}
