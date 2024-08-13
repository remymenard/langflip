import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'modal_select_course_widget.dart' show ModalSelectCourseWidget;
import 'package:flutter/material.dart';

class ModalSelectCourseModel extends FlutterFlowModel<ModalSelectCourseWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Read Document] action in modal_SelectCourse widget.
  VideosRecord? currentDoc;
  // State field(s) for SelectCourseDropdown widget.
  String? selectCourseDropdownValue;
  FormFieldController<String>? selectCourseDropdownValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
