import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'component_no_translation_model.dart';
export 'component_no_translation_model.dart';

class ComponentNoTranslationWidget extends StatefulWidget {
  const ComponentNoTranslationWidget({super.key});

  @override
  State<ComponentNoTranslationWidget> createState() =>
      _ComponentNoTranslationWidgetState();
}

class _ComponentNoTranslationWidgetState
    extends State<ComponentNoTranslationWidget> {
  late ComponentNoTranslationModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ComponentNoTranslationModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.videocam_off,
            color: FlutterFlowTheme.of(context).secondary,
            size: 90.0,
          ),
          Container(
            decoration: const BoxDecoration(),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20.0, 30.0, 20.0, 0.0),
              child: Text(
                'No translation found.\nGo to the caption tab and press the \"New Translation\" button.',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: 'Outfit',
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
