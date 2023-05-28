import 'package:flutter/material.dart';
import 'package:shot_locker/config/network_video_player.dart';
import 'package:shot_locker/utility/display_image.dart';
import 'package:shot_locker/utility/media_checker.dart';

class ShowMediaContent extends StatelessWidget {
  final String mediaUrl;
  const ShowMediaContent({
    Key? key,
    required this.mediaUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('${ApiManager.hostIp}/media/${widget.videoURL}');
    final _deviceSize = MediaQuery.of(context).size;

    return MediaChecker.isVideo(mediaUrl)
        ? Container(
            alignment: Alignment.center,
            height: _deviceSize.height * 0.2,
            child: NetworkVideoPlayerWidget(
              videoURL: mediaUrl,
              showControl: true,
            ),
          )
        : DisplayImage(
            height: 200.0,
            imageUrl: mediaUrl,
          );
  }
}
