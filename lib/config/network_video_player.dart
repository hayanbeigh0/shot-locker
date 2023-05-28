import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shot_locker/config/api_manager.dart';
import 'package:shot_locker/utility/control_media_play/control_meadia_play_cubit.dart';
import 'package:shot_locker/utility/loading_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NetworkVideoPlayerWidget extends StatefulWidget {
  final String videoURL;
  final bool allowControl;
  final bool autoPlay;
  final bool showControl;

  const NetworkVideoPlayerWidget({
    Key? key,
    required this.videoURL,
    this.allowControl = true,
    this.autoPlay = false,
    this.showControl = false,
  }) : super(key: key);

  @override
  _NetworkVideoPlayerWidgetState createState() =>
      _NetworkVideoPlayerWidgetState();
}

class _NetworkVideoPlayerWidgetState extends State<NetworkVideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isMute = true;
  bool _isVisible = true;
  bool _isPlaying = false;

  String convertTwo(int duration) {
    return duration < 10 ? '0$duration' : '$duration';
  }

  Future goToPosition(
      Duration Function(Duration currentPosition) builder) async {
    final currentPosition = await _controller!.position;
    final newPosition = builder(currentPosition!);
    await _controller!.seekTo(newPosition);
  }

  @override
  void initState() {
    if (widget.autoPlay) {
      _isPlaying = true;
    }
    _controller = VideoPlayerController.network(
      '${ApiManager.hostIp}/media/${widget.videoURL}',
    )
      ..addListener(() {})
      ..setLooping(true)
      ..initialize().then((value) async {
        //If the widget is mounted/rendered properly then run the setstate()
        if (mounted) {
          widget.autoPlay
              ? await _controller!.play()
              : await _controller!.pause();
          await _controller!.setVolume(0.0);
          setState(() {});
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    double _controlButtonSize = 50;

    return BlocListener<ControlMeadiaPlayCubit, ControlMeadiaPlayState>(
      listener: (context, state) {
        if (state is StopMediaPlay) {
          // _isPlaying = !_isPlaying;
          _isPlaying = false;
          _controller!.pause();
        }
      },
      child: VisibilityDetector(
        key: Key(widget.videoURL),
        onVisibilityChanged: (VisibilityInfo info) {
          if (mounted) {
            //If the player widget visibility is less than 1, then assign _isVisible=false, to disable
            //double tap play/pause.
            if (info.visibleFraction < 1) {
              _isVisible = false;
              //here _isPlaying=true is used for both play and pause, because when _isPlaying is true
              //then when the player visibility is equal to 1 then it is autoplay the content.
              if (_isPlaying) {
                _controller!.pause();
              }
            } else {
              _isVisible = true;
              if (_isPlaying) {
                _controller!.play();
              }
            }
          }
        },
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Flexible(
            flex: 5,
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: GestureDetector(
                onTap: () async {
                  //If _isVisible is true then allow the gesture double tap to play pause
                  if (_isVisible && widget.allowControl) {
                    //to vibrate the phone
                    await HapticFeedback.lightImpact();
                    _isPlaying = !_isPlaying;
                    setState(() {
                      _controller!.value.isPlaying
                          ? _controller!.pause()
                          : _controller!.play();
                    });
                  }
                },
                child: Stack(
                  children: [
                    _controller!.value.isInitialized
                        ? VideoPlayer(_controller!)
                        : const LoadingIndicator(),
                    // if (widget.allowControl)
                    //   VideoProgressIndicator(
                    //     _controller!,
                    //     allowScrubbing: true,
                    //     padding: const EdgeInsets.all(8),
                    //   ),
                    if (widget.showControl)
                      Align(
                        alignment: Alignment.center,
                        child: _isPlaying
                            ? const SizedBox.shrink()
                            : Icon(
                                Icons.play_arrow,
                                size: _controlButtonSize,
                                color: Colors.grey,
                              ),
                      ),
                    if (widget.allowControl)
                      Positioned(
                        left: 8,
                        top: 8,
                        child: Container(
                          height: _deviceSize.height * 0.03,
                          width: _deviceSize.width * 0.08,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black87,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              //to vibrate the phone
                              await HapticFeedback.lightImpact();
                              _isMute = !_isMute;
                              setState(() {
                                _isMute
                                    ? _controller!.setVolume(0.0)
                                    : _controller!.setVolume(1.0);
                              });
                            },
                            icon: Icon(
                              _isMute ? Icons.volume_off : Icons.volume_up,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // if (widget.showControl) SizedBox(height: _deviceSize.height * 0.03),

          //   Flexible(
          //     child:
          //         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          //       Container(
          //         decoration: BoxDecoration(
          //             border: Border.all(color: Colors.black),
          //             borderRadius: BorderRadius.circular(30)),
          //         child: IconButton(
          //           onPressed: () => goToPosition(
          //             (currentPosition) =>
          //                 currentPosition - const Duration(seconds: 5),
          //           ),
          //           icon: Icon(
          //             Icons.replay_5_sharp,
          //             size: _controlButtonSize,
          //             color: Colors.black,
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: _deviceSize.width * 0.02),
          //       Container(
          //         decoration: BoxDecoration(
          //             border: Border.all(color: Colors.black),
          //             borderRadius: BorderRadius.circular(30)),
          //         child: IconButton(
          //           onPressed: () {
          //             setState(() {
          //               _controller!.value.isPlaying
          //                   ? _controller!.pause()
          //                   : _controller!.play();
          //             });
          //           },
          //           icon: Icon(
          //             _controller!.value.isPlaying
          //                 ? Icons.pause
          //                 : Icons.play_arrow,
          //             size: _controlButtonSize,
          //             color: Colors.black,
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: _deviceSize.width * 0.02),
          //       Container(
          //         decoration: BoxDecoration(
          //             border: Border.all(color: Colors.black),
          //             borderRadius: BorderRadius.circular(30)),
          //         child: IconButton(
          //           onPressed: () => goToPosition(
          //             (currentPosition) =>
          //                 currentPosition + const Duration(seconds: 5),
          //           ),
          //           icon: Icon(
          //             Icons.forward_5,
          //             size: _controlButtonSize,
          //             color: Colors.black,
          //           ),
          //         ),
          //       ),
          //     ]),
          //   )
        ]),
      ),
    );
  }
}
