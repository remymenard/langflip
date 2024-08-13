// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';

import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWithCallbacks extends StatefulWidget {
  final String videoUrl;
  final Color progressColor;
  final Future<dynamic> Function() callback;
  final double? width;
  final double? height;

  VideoPlayerWithCallbacks({
    Key? key,
    this.width,
    this.height,
    required this.videoUrl,
    required this.callback,
    this.progressColor = Colors.greenAccent,
  });

  @override
  State<VideoPlayerWithCallbacks> createState() =>
      VideoPlayerWithCallbacksState();
}

class VideoPlayerWithCallbacksState extends State<VideoPlayerWithCallbacks> {
  late VideoPlayerController _controller;
  Size _videoSize = Size.zero;

  void pauseVideo() async {
    await _controller.pause();
    setState(() {});
  }

  void sendCallback() {
    widget.callback();
  }

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayer();
    Timer.periodic(
        const Duration(milliseconds: 200), (Timer t) => sendCallback());
    super.initState();
  }

  Future<void> _initializeVideoPlayer() async {
    await _controller.initialize();
    _controller.setLooping(true);
  }

  IconData _getPlayPauseIcon() {
    return _controller.value.isPlaying ? Icons.pause : Icons.play_arrow;
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Stack(
                          children: [
                            VideoPlayer(_controller),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: InkWell(
                            onTap: _togglePlayPause,
                            child: Icon(_getPlayPauseIcon(), size: 45.0),
                          ),
                        ),
                      ),
                      SmoothVideoProgress(
                        controller: _controller,
                        builder: (context, position, duration, _) => Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                _VideoProgressSlider(
                                  position: position,
                                  duration: duration,
                                  controller: _controller,
                                  swatch: widget.progressColor,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25.0),
                              child: Text(
                                "${_formatDuration(position)} / ${_formatDuration(duration)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        : const Center(
            child: CustomSpinner(
            width: 50,
            height: 50,
          ));
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _VideoProgressSlider extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final VideoPlayerController controller;
  final Color swatch;

  const _VideoProgressSlider({
    Key? key,
    required this.position,
    required this.duration,
    required this.controller,
    required this.swatch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final max = duration.inMilliseconds.toDouble();
    final value = position.inMilliseconds.clamp(0, max).toDouble();
    return Slider(
      activeColor: swatch,
      min: 0,
      max: max,
      value: value,
      onChanged: (newValue) {
        controller.seekTo(Duration(milliseconds: newValue.round()));
      },
      onChangeStart: (_) {
        controller.pause();
      },
      onChangeEnd: (_) {
        // controller.play();
      },
    );
  }
}
