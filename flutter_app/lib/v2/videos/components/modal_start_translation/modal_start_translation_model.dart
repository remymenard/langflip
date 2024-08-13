import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'modal_start_translation_widget.dart' show ModalStartTranslationWidget;
import 'package:flutter/material.dart';

class ModalStartTranslationModel
    extends FlutterFlowModel<ModalStartTranslationWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for SelectLanguageDropdown widget.
  String? selectLanguageDropdownValue;
  FormFieldController<String>? selectLanguageDropdownValueController;
  // State field(s) for SelectVoiceDropdown widget.
  String? selectVoiceDropdownValue;
  FormFieldController<String>? selectVoiceDropdownValueController;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  TranslationsRecord? translationDocument;
  // Stores action output result for [Backend Call - API (Start Lipsync)] action in Button widget.
  ApiCallResponse? apiResultr1x;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
