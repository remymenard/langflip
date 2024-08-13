import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'videos_show_widget.dart' show VideosShowWidget;
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class VideosShowModel extends FlutterFlowModel<VideosShowWidget> {
  ///  State fields for stateful widgets in this page.

  VideosRecord? columnPreviousSnapshot;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Stores action output result for [Backend Call - API (Cloud Functions Start LipSyncing)] action in VideoPlayerWithProgress widget.
  ApiCallResponse? startLipsyncingResponse;

  @override
  void initState(BuildContext context) {
    dataTableShowLogs = false; // Disables noisy DataTable2 debug statements.
  }

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
