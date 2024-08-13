import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'show_translated_video_widget.dart' show ShowTranslatedVideoWidget;
import 'package:flutter/material.dart';

class ShowTranslatedVideoModel
    extends FlutterFlowModel<ShowTranslatedVideoWidget> {
  ///  Local state fields for this page.

  List<SentenceStruct> captionsStored = [];
  void addToCaptionsStored(SentenceStruct item) => captionsStored.add(item);
  void removeFromCaptionsStored(SentenceStruct item) =>
      captionsStored.remove(item);
  void removeAtIndexFromCaptionsStored(int index) =>
      captionsStored.removeAt(index);
  void insertAtIndexInCaptionsStored(int index, SentenceStruct item) =>
      captionsStored.insert(index, item);
  void updateCaptionsStoredAtIndex(
          int index, Function(SentenceStruct) updateFn) =>
      captionsStored[index] = updateFn(captionsStored[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
