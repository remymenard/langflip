import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'component_no_video_course_model.dart';
export 'component_no_video_course_model.dart';

class ComponentNoVideoCourseWidget extends StatefulWidget {
  const ComponentNoVideoCourseWidget({super.key});

  @override
  State<ComponentNoVideoCourseWidget> createState() =>
      _ComponentNoVideoCourseWidgetState();
}

class _ComponentNoVideoCourseWidgetState
    extends State<ComponentNoVideoCourseWidget> {
  late ComponentNoVideoCourseModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ComponentNoVideoCourseModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 20.0,
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Text(
              'No video found in this course.',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    fontFamily: 'Plus Jakarta Sans',
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
