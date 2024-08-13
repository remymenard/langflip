import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'modal_create_course_widget.dart' show ModalCreateCourseWidget;
import 'package:flutter/material.dart';

class ModalCreateCourseModel extends FlutterFlowModel<ModalCreateCourseWidget> {
  ///  Local state fields for this component.

  LanguageStruct? originalLanguage;
  void updateOriginalLanguageStruct(Function(LanguageStruct) updateFn) {
    updateFn(originalLanguage ??= LanguageStruct());
  }

  LanguageStruct? targetLanguage;
  void updateTargetLanguageStruct(Function(LanguageStruct) updateFn) {
    updateFn(targetLanguage ??= LanguageStruct());
  }

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for courseName widget.
  FocusNode? courseNameFocusNode;
  TextEditingController? courseNameTextController;
  String? Function(BuildContext, String?)? courseNameTextControllerValidator;
  String? _courseNameTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 4) {
      return 'Requires at least 4 characters.';
    }

    return null;
  }

  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  CoursesRecord? videoWithDoc;

  @override
  void initState(BuildContext context) {
    courseNameTextControllerValidator = _courseNameTextControllerValidator;
  }

  @override
  void dispose() {
    courseNameFocusNode?.dispose();
    courseNameTextController?.dispose();
  }
}
