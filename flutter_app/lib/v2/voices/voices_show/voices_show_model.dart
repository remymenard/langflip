import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'voices_show_widget.dart' show VoicesShowWidget;
import 'package:flutter/material.dart';

class VoicesShowModel extends FlutterFlowModel<VoicesShowWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for Slider widget.
  double? sliderValue;
  // State field(s) for MessageInput widget.
  FocusNode? messageInputFocusNode;
  TextEditingController? messageInputTextController;
  String? Function(BuildContext, String?)? messageInputTextControllerValidator;
  String? _messageInputTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 10) {
      return 'Requires at least 10 characters.';
    }

    return null;
  }

  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  GenerationsRecord? createGenerationOutput;
  // Stores action output result for [Backend Call - API (Runpod OpenVoice)] action in Button widget.
  ApiCallResponse? openVoiceResult;

  @override
  void initState(BuildContext context) {
    messageInputTextControllerValidator = _messageInputTextControllerValidator;
  }

  @override
  void dispose() {
    messageInputFocusNode?.dispose();
    messageInputTextController?.dispose();
  }
}
