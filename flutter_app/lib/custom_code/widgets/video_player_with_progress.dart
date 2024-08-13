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

// import 'package:lang_flip/app_state.dart';

import 'dart:async';

import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:video_player/video_player.dart';
import 'package:multi_thumb_slider/multi_thumb_slider.dart';
import 'package:widget_size/widget_size.dart';

class VideoPlayerWithProgress extends StatefulWidget {
  final String videoUrl;
  final Color progressColor;
  final Future<dynamic> Function() callback;
  final double? width;
  final double? height;

  VideoPlayerWithProgress({
    Key? key,
    this.width,
    this.height,
    required this.videoUrl,
    required this.callback,
    this.progressColor = Colors.greenAccent,
  });

  @override
  State<VideoPlayerWithProgress> createState() =>
      _VideoPlayerWithProgressState();
}

class _VideoPlayerWithProgressState extends State<VideoPlayerWithProgress> {
  late VideoPlayerController _controller;
  Size _videoSize = Size.zero;

  List timezones = [
    {
      "begin": 00,
      "end": 1,
      "isFace": false,
      "topLeftCorner": {"x": 0, "y": 0},
      "bottomRightCorner": {"x": 20, "y": 20},
    }
  ];

  void pauseVideo() async {
    await _controller.pause();
    setState(() {});
  }

  bool showRectangle = false;
  int getCurrentTimezoneIndex() {
    // Assuming videoController is already defined and initialized.
    Duration? currentPosition = _controller.value.position;
    double videoDurationInMilliseconds =
        _controller.value.duration.inMilliseconds.toDouble();
    double currentPositionFraction =
        currentPosition!.inMilliseconds.toDouble() /
            videoDurationInMilliseconds;

    // Find the timezone where the current position fraction falls between 'begin' and 'end'
    return timezones.indexWhere((timezone) =>
        currentPositionFraction >= timezone['begin'] &&
        currentPositionFraction <= timezone['end']);
  }

  void updateIsFace() {
    int timezoneIndex = getCurrentTimezoneIndex();

    if (timezoneIndex != -1) {
      // If found, toggle the 'detectFace' variable
      // Assuming the 'detectFace' key exists and is a boolean
      try {
        showRectangle = timezones[timezoneIndex]['isFace'];
        rect = Rect.fromPoints(
            Offset(timezones[timezoneIndex]["topLeftCorner"]["x"],
                timezones[timezoneIndex]["topLeftCorner"]["y"]),
            Offset(timezones[timezoneIndex]["bottomRightCorner"]["x"],
                timezones[timezoneIndex]["bottomRightCorner"]["y"]));
        setState(() {});
      } catch (e) {}
    }
  }

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayer();
    Timer.periodic(
        const Duration(milliseconds: 200), (Timer t) => updateIsFace());
    super.initState();
  }

  void toggleRectangle(newValue) {
    if (showRectangle != newValue) {
      setState(() {
        showRectangle = newValue;
      });
    }
  }

  Future<void> _initializeVideoPlayer() async {
    await _controller.initialize();
    _controller.setLooping(true);

    setState(() {
      _videoSize = _controller.value.size;
      var stateTimezones = FFAppState().faceLocations;
      if (stateTimezones.isNotEmpty) {
        print("stateTimezones");
        print(stateTimezones);
        timezones = stateTimezones.map((timezone) {
          _videoWidth = timezone.screenWidth.toDouble();
          _videoHeight = timezone.screenHeight.toDouble();
          print('_videoWidth');
          print(_videoWidth);
          print('_videoHeight');
          print(_videoHeight);
          double coefWidthChange = _videoWidth / timezone.screenWidth;
          double coefHeightChange = _videoHeight / timezone.screenHeight;
          return {
            "begin": timezone.begin,
            "end": timezone.end,
            "isFace": timezone.isFace,
            "screenWidth": timezone.screenWidth,
            "screenHeight": timezone.screenHeight,
            "topLeftCorner": {
              "x": timezone.topLeftCornerX / coefWidthChange,
              "y": timezone.topLeftCornerY / coefHeightChange
            },
            "bottomRightCorner": {
              "x": timezone.bottomRightCornerX / coefWidthChange,
              "y": timezone.bottomRightCornerY / coefHeightChange
            },
          };
        }).toList();
      }
    });
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

  late Rect rect = Rect.fromCenter(
    center: MediaQuery.of(context).size.center(Offset.zero),
    width: 400,
    height: 300,
  );

  double _videoWidth = 20;
  double _videoHeight = 20;

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
                            WidgetSize(
                                onChange: (newSize) {
                                  double coefWidthChange =
                                      _videoWidth / newSize.width;
                                  double coefHeightChange =
                                      _videoHeight / newSize.height;

                                  setState(() {
                                    try {
                                      for (var timezone in timezones) {
                                        timezone['screenWidth'] = newSize.width;
                                        timezone['screenHeight'] =
                                            newSize.height;
                                        timezone['topLeftCorner']['x'] =
                                            timezone['topLeftCorner']['x'] /
                                                coefWidthChange;
                                        timezone['topLeftCorner']['y'] =
                                            timezone['topLeftCorner']['y'] /
                                                coefHeightChange;
                                        timezone['bottomRightCorner']['x'] =
                                            timezone['bottomRightCorner']['x'] /
                                                coefWidthChange;
                                        timezone['bottomRightCorner']['y'] =
                                            timezone['bottomRightCorner']['y'] /
                                                coefHeightChange;
                                      }
                                    } catch (e) {
                                      print(
                                          "page loaded or error when resizing video");
                                    }
                                    _videoWidth = newSize.width + 1;
                                    _videoHeight = newSize.height + 1;
                                  });
                                },
                                child: VideoPlayer(_controller)),
                            if (showRectangle)
                              TransformableBox(
                                rect: rect,
                                clampingRect: Rect.fromPoints(Offset(0, 0),
                                    Offset(_videoWidth, _videoHeight)),
                                onChanged: (result, event) {
                                  int currentZoneIndex =
                                      getCurrentTimezoneIndex();
                                  timezones[currentZoneIndex]
                                      ['topLeftCorner'] = {
                                    "x": result.rect.topLeft.dx,
                                    "y": result.rect.topLeft.dy
                                  };
                                  timezones[currentZoneIndex]
                                      ['bottomRightCorner'] = {
                                    "x": result.rect.bottomRight.dx,
                                    "y": result.rect.bottomRight.dy
                                  };
                                  setState(() {
                                    rect = result.rect;
                                  });
                                },
                                contentBuilder: (context, rect, flip) {
                                  return DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  );
                                },
                              ),
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0),
                                  child: OverdragMoveUsecase.unlocked(
                                      videoController: _controller,
                                      timezones: timezones,
                                      pauseVideo: pauseVideo),
                                ),
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 160.0, bottom: 12),
                  child: Ink(
                    decoration: const ShapeDecoration(
                        color: Color(0xFFD946EF),
                        shape: CircleBorder(),
                        shadows: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                            offset: Offset(0.0, 0.0),
                          )
                        ]),
                    child: IconButton(
                      icon: const Icon(Icons.check),
                      color: Colors.white,
                      onPressed: () {
                        FFAppState().update(() {
                          FFAppState().faceLocations = timezones
                              .map((timezone) => FaceLocationStruct(
                                  begin: timezone["begin"],
                                  end: timezone["end"],
                                  isFace: timezone["isFace"],
                                  screenWidth:
                                      timezones[0]["screenWidth"].round(),
                                  screenHeight:
                                      timezones[0]["screenHeight"].round(),
                                  bottomRightCornerX:
                                      timezone["bottomRightCorner"]["x"]
                                          .round(),
                                  bottomRightCornerY:
                                      timezone["bottomRightCorner"]["y"]
                                          .round(),
                                  topLeftCornerX:
                                      timezone["topLeftCorner"]["x"].round(),
                                  topLeftCornerY:
                                      timezone["topLeftCorner"]["y"].round()))
                              .toList();
                        });
                        widget.callback();
                      },
                    ),
                  ),
                ),
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

class OverdragMoveUsecase extends StatefulWidget {
  const OverdragMoveUsecase.locked(
      {super.key,
      required this.videoController,
      required this.timezones,
      required this.pauseVideo})
      : locked = true;

  const OverdragMoveUsecase.unlocked(
      {super.key,
      required this.videoController,
      required this.timezones,
      required this.pauseVideo})
      : locked = false;

  final Function pauseVideo;
  final bool locked;
  final VideoPlayerController videoController;
  final List timezones;

  @override
  State<OverdragMoveUsecase> createState() => _OverdragMoveUsecaseState();
}

class _OverdragMoveUsecaseState extends State<OverdragMoveUsecase> {
  List<double> stops = [];
  List<double> duplicatedStops = [];
  List<Color> duplicatedColors = [];

  MultiThumbSliderController controller = MultiThumbSliderController();

  List<double> convertTimeZonesToStops() {
    stops = widget.timezones
        .map((timezone) => timezone['begin'])
        .cast<double>()
        .toList();

    if (stops.length < 2) {
      stops = [0, 1];
    }

    stops.add(1);
    duplicatedStops = widget.timezones
        .map((timezone) {
          // Explicitly cast the values to double
          double begin = (timezone['begin'] as num).toDouble();
          double end = (timezone['end'] as num).toDouble();
          return [begin, end];
        })
        .expand((element) => element)
        .cast<double>()
        .toList();

    duplicatedColors = widget.timezones
        .map((timezone) {
          Color color = timezone['isFace'] ? Color(0xFFD946EF) : Colors.black12;
          return [color, color];
        })
        .expand((element) => element)
        .cast<Color>()
        .toList();
    return stops;
  }

  int getCurrentTimezoneIndex() {
    // Assuming videoController is already defined and initialized.
    Duration? currentPosition = widget.videoController.value.position;
    double videoDurationInMilliseconds =
        widget.videoController.value.duration.inMilliseconds.toDouble();
    double currentPositionFraction =
        currentPosition!.inMilliseconds.toDouble() /
            videoDurationInMilliseconds;

    // Find the timezone where the current position fraction falls between 'begin' and 'end'
    return widget.timezones.indexWhere((timezone) =>
        currentPositionFraction >= timezone['begin'] &&
        currentPositionFraction <= timezone['end']);
  }

  void toggleDetectFace() {
    int timezoneIndex = getCurrentTimezoneIndex();

    if (timezoneIndex != -1) {
      // If found, toggle the 'detectFace' variable
      // Assuming the 'detectFace' key exists and is a boolean
      widget.timezones[timezoneIndex]['isFace'] =
          !(widget.timezones[timezoneIndex]['isFace'] ?? false);
      convertTimeZonesToStops();

      setState(() {});
    }
  }

  bool isDetectFaceInCurrentTimezone() {
    int timezoneIndex = getCurrentTimezoneIndex();

    // If a timezone is found and it has the 'detectFace' property, return that property
    if (timezoneIndex != -1 &&
        widget.timezones[timezoneIndex].containsKey('isFace')) {
      return widget.timezones[timezoneIndex]['isFace'];
    }

    // If no timezone is found or it doesn't have the 'detectFace' property, return false
    return false;
  }

  void updateTimeZones(List<double> newStops) {
    // Assuming newStops are sorted and the last stop is always 1.0
    int stopsCount = newStops.length;
    double? updatedValue;
    Duration? totalDuration = widget.videoController.value.duration;

    // SEEK TO THE SELECTED NEW STOP
    for (int i = 0; i < stopsCount; i++) {
      if (i >= stops.length || newStops[i] != stops[i]) {
        updatedValue = newStops[i];
        // Once the updated value is found, seek to the corresponding duration in the video
        double ratio = updatedValue;
        int seekMilliseconds =
            (totalDuration.inMilliseconds.toDouble() * ratio).toInt();
        widget.videoController.seekTo(Duration(milliseconds: seekMilliseconds));
        break; // Exit the loop after finding the updated value
      }
    }

    // UPDATE THEwidget.timezones
    for (int i = 0; i < widget.timezones.length; i++) {
      // Update the 'begin' of the timezone with the corresponding stop.
      widget.timezones[i]['begin'] = newStops[i];

      // Update the 'end' of the timezone.
      // If it's the last timezone, set 'end' to 1.
      // Otherwise, set 'end' to the next stop.
      if (i == widget.timezones.length - 1) {
        widget.timezones[i]['end'] = 1.0;
      } else {
        // If there aren't enough stops for the remainingwidget.timezones, break the loop
        // This avoids accessing out-of-bounds index in newStops.
        if (i + 1 >= stopsCount) {
          break;
        }
        widget.timezones[i]['end'] = newStops[i + 1];
      }
    }

    convertTimeZonesToStops();
  }

  @override
  void initState() {
    convertTimeZonesToStops();
    super.initState();
  }

  void _removeMarker() async {
    await widget.pauseVideo();
    int timezoneIndex = getCurrentTimezoneIndex();

    // Ensure that the timezoneIndex is valid before trying to remove it
    if (timezoneIndex > 0 && timezoneIndex < widget.timezones.length) {
      widget.timezones.removeAt(timezoneIndex);

      setState(() {
        // Update any dependent state here
        convertTimeZonesToStops();
      });
    } else {
      // Handle the case where the timezoneIndex is not valid (e.g., show an error or ignore)
      print("No timezone matches the current position or list is empty.");
    }
  }

  void _addMarker() async {
    await widget.pauseVideo();
    Duration? currentPosition = await widget.videoController.position;
    Duration? totalDuration = widget.videoController.value.duration;

    // Calculate the ratio of the current position to the total duration
    final double positionRatio = currentPosition!.inMilliseconds.toDouble() /
        totalDuration.inMilliseconds.toDouble();

    // Find the correct index to insert the newTimeZone and calculate the end value
    int insertIndex = widget.timezones.indexWhere(
      (timezone) => positionRatio < timezone['begin'],
    );

    double endValue;
    if (insertIndex == -1) {
      // If there is no next timezone, set end to 1
      endValue = 1.0;
      insertIndex = widget.timezones.length; // Add to the end of the list
    } else {
      // If there is a next timezone, use its begin as the end for the new timezone
      endValue = widget.timezones[insertIndex]['begin'];
      // Update the begin of the next timezone to the end of the new timezone
      widget.timezones[insertIndex]['begin'] = endValue;
    }

    final newTimeZone = {
      "begin": positionRatio,
      "end": endValue,
      "isFace": true,
      "topLeftCorner": widget.timezones[insertIndex - 1]["topLeftCorner"],
      "bottomRightCorner": widget.timezones[insertIndex - 1]
          ["bottomRightCorner"],
    };

    widget.timezones.insert(insertIndex, newTimeZone);

    // Update the end of the previous timezone, if there is one
    if (insertIndex > 0) {
      widget.timezones[insertIndex - 1]['end'] = positionRatio;
    }

    convertTimeZonesToStops();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Generate duplicated colors and stops for gradient
    return SizedBox(
      height: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _removeMarker,
                icon: const Icon(Icons.remove_circle),
              ),
              Checkbox(
                value: isDetectFaceInCurrentTimezone(),
                fillColor: MaterialStateProperty.all(Colors.black),
                onChanged: (bool? newValue) {
                  // When the checkbox is pressed, toggle the detectFace value.
                  toggleDetectFace();
                },
              ),
              IconButton(
                onPressed: _addMarker,
                icon: const Icon(Icons.add_circle),
              ),
            ],
          ),
          MultiThumbSlider(
            controller: controller,
            lockBehaviour: ThumbLockBehaviour.both,
            valuesChanged: (values) {
              setState(() {
                updateTimeZones(values);
              });
            },
            thumbBuilder: (context, index) => MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: Container(
                height: 110,
                width: 3,
                color: Colors.black,
              ),
            ),
            initalSliderValues: stops,
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: duplicatedColors,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: duplicatedStops,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
