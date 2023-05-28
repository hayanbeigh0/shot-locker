import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String? videoUrl;

  const VideoWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _videoController;
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(
      widget.videoUrl ?? '',
      // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    )..initialize().then((_) {
        setState(() {
          _loading = false;

          //_videoController.play();
          // _videoController.setLooping(true);
        });
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  bool _isPlaying = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170.0,
      width: double.infinity,
      child: _loading
          ? const Center(
              child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
            )
          : //AspectRatio(
          //aspectRatio: _videoController.value.aspectRatio,
          //child:
          ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              child: Stack(
                children: [
                  VideoPlayer(_videoController),
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (_isPlaying) {
                            _videoController.pause();
                            _isPlaying = false;
                          } else {
                            _isPlaying = true;
                            _videoController.play();
                          }
                        });
                      },
                      icon: _isPlaying
                          ? const SizedBox.shrink()
                          : const Icon(
                              Icons.play_arrow,
                              size: 40.0,
                              color: Colors.white,
                            ),
                    ),
                  )
                ],
              ),
            ),

      ///   ),
    );
  }
}
