import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'show_video_widget.dart' show ShowVideoWidget;
import 'package:flutter/material.dart';

class ShowVideoModel extends FlutterFlowModel<ShowVideoWidget> {
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

  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
