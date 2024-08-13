import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'modal_create_video_widget.dart' show ModalCreateVideoWidget;
import 'package:flutter/material.dart';

class ModalCreateVideoModel extends FlutterFlowModel<ModalCreateVideoWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading1 = false;
  FFUploadedFile uploadedLocalFile1 =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // State field(s) for projectName widget.
  FocusNode? projectNameFocusNode;
  TextEditingController? projectNameTextController;
  String? Function(BuildContext, String?)? projectNameTextControllerValidator;
  String? _projectNameTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 4) {
      return 'Requires at least 4 characters.';
    }

    return null;
  }

  bool isDataUploading2 = false;
  FFUploadedFile uploadedLocalFile2 =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl2 = '';

  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  VideosRecord? videoWithDoc;
  // Stores action output result for [Backend Call - API (CreateCaptions)] action in Button widget.
  ApiCallResponse? apiResultsfc;

  @override
  void initState(BuildContext context) {
    projectNameTextControllerValidator = _projectNameTextControllerValidator;
  }

  @override
  void dispose() {
    projectNameFocusNode?.dispose();
    projectNameTextController?.dispose();
  }
}
