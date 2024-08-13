import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'component_empty_list_model.dart';
export 'component_empty_list_model.dart';

class ComponentEmptyListWidget extends StatefulWidget {
  const ComponentEmptyListWidget({super.key});

  @override
  State<ComponentEmptyListWidget> createState() =>
      _ComponentEmptyListWidgetState();
}

class _ComponentEmptyListWidgetState extends State<ComponentEmptyListWidget> {
  late ComponentEmptyListModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ComponentEmptyListModel());

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
            Icons.voice_over_off_outlined,
            color: FlutterFlowTheme.of(context).secondary,
            size: 90.0,
          ),
          Container(
            decoration: const BoxDecoration(),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20.0, 30.0, 20.0, 0.0),
              child: Text(
                'No voice found',
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
