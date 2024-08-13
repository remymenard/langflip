import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'component_list_sentence_item_widget.dart'
    show ComponentListSentenceItemWidget;
import 'package:flutter/material.dart';

class ComponentListSentenceItemModel
    extends FlutterFlowModel<ComponentListSentenceItemWidget> {
  ///  Local state fields for this component.

  List<SentenceStruct> captions = [];
  void addToCaptions(SentenceStruct item) => captions.add(item);
  void removeFromCaptions(SentenceStruct item) => captions.remove(item);
  void removeAtIndexFromCaptions(int index) => captions.removeAt(index);
  void insertAtIndexInCaptions(int index, SentenceStruct item) =>
      captions.insert(index, item);
  void updateCaptionsAtIndex(int index, Function(SentenceStruct) updateFn) =>
      captions[index] = updateFn(captions[index]);

  bool hasChanged = false;

  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
