import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'component_list_sentence_item_model.dart';
export 'component_list_sentence_item_model.dart';

class ComponentListSentenceItemWidget extends StatefulWidget {
  const ComponentListSentenceItemWidget({
    super.key,
    this.sentence,
    required this.index,
    required this.sentenceType,
    required this.video,
  });

  final String? sentence;
  final int? index;
  final String? sentenceType;
  final VideosRecord? video;

  @override
  State<ComponentListSentenceItemWidget> createState() =>
      _ComponentListSentenceItemWidgetState();
}

class _ComponentListSentenceItemWidgetState
    extends State<ComponentListSentenceItemWidget> {
  late ComponentListSentenceItemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ComponentListSentenceItemModel());

    _model.textController ??= TextEditingController(text: widget.sentence);
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldFocusNode!.addListener(
      () async {
        logFirebaseEvent('COMPONENT_LIST_SENTENCE_ITEM_TextField_e');
        if (!(_model.textFieldFocusNode?.hasFocus ?? false)) {
          _model.captions =
              widget.video!.captions.toList().cast<SentenceStruct>();
          if (widget.sentenceType == 'original') {
            _model.updateCaptionsAtIndex(
              widget.index!,
              (e) => e..original = _model.textController.text,
            );
          } else {
            _model.updateCaptionsAtIndex(
              widget.index!,
              (e) => e..translated = _model.textController.text,
            );
          }

          await widget.video!.reference.update({
            ...mapToFirestore(
              {
                'captions': getSentenceListFirestoreData(
                  _model.captions,
                ),
              },
            ),
          });
          _model.hasChanged = false;
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 8.0, 8.0),
            child: TextFormField(
              controller: _model.textController,
              focusNode: _model.textFieldFocusNode,
              onChanged: (_) => EasyDebounce.debounce(
                '_model.textController',
                const Duration(milliseconds: 2000),
                () async {
                  logFirebaseEvent('COMPONENT_LIST_SENTENCE_ITEM_TextField_e');
                  _model.hasChanged = true;
                },
              ),
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                suffixIcon: _model.textController!.text.isNotEmpty
                    ? InkWell(
                        onTap: () async {
                          _model.textController?.clear();
                          logFirebaseEvent(
                              'COMPONENT_LIST_SENTENCE_ITEM_TextField_e');
                          _model.hasChanged = true;
                          setState(() {});
                        },
                        child: Icon(
                          Icons.clear,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 15.0,
                        ),
                      )
                    : null,
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Plus Jakarta Sans',
                    letterSpacing: 0.0,
                  ),
              maxLines: 4,
              cursorColor: FlutterFlowTheme.of(context).secondary,
              validator: _model.textControllerValidator.asValidator(context),
            ),
          ),
        ),
      ],
    );
  }
}
