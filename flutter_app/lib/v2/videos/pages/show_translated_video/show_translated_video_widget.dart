import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_video_player.dart';
import 'package:flutter/material.dart';
import 'show_translated_video_model.dart';
export 'show_translated_video_model.dart';

class ShowTranslatedVideoWidget extends StatefulWidget {
  const ShowTranslatedVideoWidget({
    super.key,
    required this.translationReference,
  });

  final DocumentReference? translationReference;

  @override
  State<ShowTranslatedVideoWidget> createState() =>
      _ShowTranslatedVideoWidgetState();
}

class _ShowTranslatedVideoWidgetState extends State<ShowTranslatedVideoWidget> {
  late ShowTranslatedVideoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ShowTranslatedVideoModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'ShowTranslatedVideo'});
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 60.0,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 30.0,
                ),
                onPressed: () async {
                  logFirebaseEvent('SHOW_TRANSLATED_VIDEO_arrow_back_rounded');
                  context.pop();
                },
              ),
            ],
          ),
          actions: const [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: StreamBuilder<TranslationsRecord>(
            stream:
                TranslationsRecord.getDocument(widget.translationReference!),
            builder: (context, snapshot) {
              // Customize what your widget looks like when it's loading.
              if (!snapshot.hasData) {
                return const Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFD946EF),
                      ),
                    ),
                  ),
                );
              }

              final containerTranslationsRecord = snapshot.data!;

              return Container(
                decoration: const BoxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0.0, 0.0),
                        child: FlutterFlowVideoPlayer(
                          path: containerTranslationsRecord.lipsyncedVideoUrl,
                          videoType: VideoType.network,
                          width: 900.0,
                          autoPlay: false,
                          looping: true,
                          showControls: true,
                          allowFullScreen: true,
                          allowPlaybackSpeedMenu: false,
                          lazyLoad: false,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
