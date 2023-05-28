import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shot_locker/config/.env.dart';
import 'package:url_launcher/url_launcher.dart';
part 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit() : super(ExploreInitial());

  Future<void> launchInWebViewWithJavaScript() async {
    if (!await launch(
      twitterLink,
      forceSafariVC: true,
      forceWebView: true,
      enableJavaScript: true,
    )) {
      throw 'Could not launch $twitterLink';
    }
  }
}
