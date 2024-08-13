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

import 'package:video_player/video_player.dart';
import 'dart:async';

class PlayAudioButton extends StatefulWidget {
  const PlayAudioButton({
    Key? key,
    this.width,
    this.height,
    required this.beginTime,
    required this.endTime,
    required this.videoUrl,
    required this.buttonColor,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double beginTime;
  final double endTime;
  final String videoUrl;
  final Color buttonColor;

  @override
  _PlayAudioButtonState createState() => _PlayAudioButtonState();
}

class _PlayAudioButtonState extends State<PlayAudioButton> {
  VideoPlayerController? _controller;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: IconButton(
          color: widget.buttonColor,
          splashRadius: widget.width! / 4,
          icon: _controller?.value.isPlaying ?? false
              ? const Icon(Icons.pause)
              : const Icon(Icons.play_arrow),
          onPressed: () {
            if (_controller?.value.isPlaying ?? false) {
              _controller?.pause();
              _timer?.cancel();
            } else {
              _controller = VideoPlayerController.network(widget.videoUrl)
                ..initialize().then((_) {
                  print(widget.beginTime * 1000);
                  _controller!.play();
                  _controller!.seekTo(
                      Duration(milliseconds: (widget.beginTime * 1000).ceil()));
                  _timer =
                      Timer.periodic(const Duration(milliseconds: 50), (timer) {
                    print(_controller!.value.position.inMilliseconds);
                    if (_controller!.value.position.inMilliseconds >
                        (widget.endTime * 1000).ceil()) {
                      _controller!.pause();
                      _timer!.cancel();
                    }
                    setState(() {});
                  });

                  setState(() {});
                });
            }
            setState(() {});
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _controller?.dispose();
  }
}
