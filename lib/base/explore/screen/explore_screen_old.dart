import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shot_locker/base/explore/widget/video_widget.dart';
import 'package:shot_locker/base/logic/go_to_home/go_to_home_cubit.dart';
import 'package:shot_locker/constants/constants.dart';
import 'package:shot_locker/utility/custom_appbar.dart';
import '/models/explore_media.dart';

class ExploreScreenOld extends StatefulWidget {
  const ExploreScreenOld({Key? key}) : super(key: key);

  @override
  State<ExploreScreenOld> createState() => _ExploreScreenOldState();
}

class _ExploreScreenOldState extends State<ExploreScreenOld> {
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardB = GlobalKey();
  static const List<ExploreMedia> _exploreMedia = [
    ExploreMedia(
      title: 'What is Lorem Ipsum?',
      media:
          'https://dm0qx8t0i9gc9.cloudfront.net/watermarks/video/4Xw4byPvl/golfer-on-the-putting-green-sinks-a-short-putt_srvxbhsw__1fed5a3e3dca7909390d07c1538b0a58__P360.mp4',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book',
    ),
    ExploreMedia(
      title: 'What is Lorem Ipsum?',
      media:
          ' https://dm0qx8t0i9gc9.cloudfront.net/watermarks/video/SuFLR1_Nwkex4zo1y/videoblocks-unrecognizable-professional-male-golf-player-hitting-ball-to-lake-playing-at-green-golf-park-alone-in-sunny-day_bj6zgsusu__7b253266ab086f8edf976daf221e82c8__P360.mp4',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book',
    ),
    ExploreMedia(
      title: 'What is Lorem Ipsum?',
      media:
          '  https://dm0qx8t0i9gc9.cloudfront.net/watermarks/video/SuFLR1_Nwkex4zo1y/videoblocks-close-up-of-white-golf-ball-falling-into-hole-on-green-meadow-at-country-golf-club_bkm-0qdju__7ce06c8d71c262ab163a576836e1c600__P360.mp4',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book',
    ),
  ];

  Future<bool> willPopScope(BuildContext context) async {
    await BlocProvider.of<GoToHomeCubit>(context).goToHome();
    //Return false to not to close the app when the back button will triggered.
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => willPopScope(context),
      child: Scaffold(
        body: Container(
          decoration: Constants.gradientBackground,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  const SizedBox(height: 10.0),
                  CustomAppBar(
                    centreWidget: Text(
                      'Explore',
                      style: GoogleFonts.rubik(
                        fontSize: 23.0,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _exploreMedia.length,
                      itemBuilder: (context, index) {
                        final eMedia = _exploreMedia[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: MediaWidget(cardKey: cardB, media: eMedia),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MediaWidget extends StatelessWidget {
  final GlobalKey<ExpansionTileCardState>? cardKey;
  final ExploreMedia media;

  const MediaWidget({
    Key? key,
    this.cardKey,
    required this.media,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VideoWidget(videoUrl: media.media ?? ''
            //'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            ),
        ExpansionTileCard(
          baseColor: Colors.white,
          expandedTextColor: Colors.white,

          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
          elevation: 0.0,
          // key: cardKey,
          title: Text(
            media.title ?? '',
            style: const TextStyle(color: Colors.black),
          ),
          subtitle: const Text(
            '09/12/21',
            style: TextStyle(fontSize: 15.0, color: Colors.black),
          ),
          children: [
            const Divider(
              thickness: 1.0,
              height: 1.0,
              color: Colors.grey,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                  media.description ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontSize: 16, color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
