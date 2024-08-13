import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_audio_player.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_video_player.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/v2/videos/components/component_list_sentence_item/component_list_sentence_item_widget.dart';
import '/v2/videos/components/modal_select_course/modal_select_course_widget.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'videos_show_model.dart';
export 'videos_show_model.dart';

class VideosShowWidget extends StatefulWidget {
  const VideosShowWidget({
    super.key,
    required this.videoReference,
  });

  final DocumentReference? videoReference;

  @override
  State<VideosShowWidget> createState() => _VideosShowWidgetState();
}

class _VideosShowWidgetState extends State<VideosShowWidget>
    with TickerProviderStateMixin {
  late VideosShowModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VideosShowModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'videosShow'});
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, -30.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 400.ms),
          FadeEffect(
            curve: Curves.bounceOut,
            delay: 400.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 400.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 10.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          iconTheme: const IconThemeData(color: Color(0xFFFF0000)),
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
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
              logFirebaseEvent('VIDEOS_SHOW_arrow_back_rounded_ICN_ON_TA');
              context.pop();
            },
          ),
          actions: const [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Container(
            decoration: const BoxDecoration(),
            child: StreamBuilder<VideosRecord>(
              stream: VideosRecord.getDocument(widget.videoReference!)
                ..listen((columnVideosRecord) async {
                  if (_model.columnPreviousSnapshot != null &&
                      !const VideosRecordDocumentEquality().equals(
                          columnVideosRecord, _model.columnPreviousSnapshot)) {
                    logFirebaseEvent(
                        'VIDEOS_SHOW_Column_3ejjtdqt_ON_DATA_CHAN');
                    FFAppState().faceLocations = columnVideosRecord
                        .faceLocations
                        .toList()
                        .cast<FaceLocationStruct>();
                    setState(() {});

                    setState(() {});
                  }
                  _model.columnPreviousSnapshot = columnVideosRecord;
                }),
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

                final columnVideosRecord = snapshot.data!;

                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4.0,
                            color: Color(0x2C000000),
                            offset: Offset(
                              0.0,
                              2.0,
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.circular(0.0),
                        border: Border.all(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            9.0, 8.0, 12.0, 12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      40.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    columnVideosRecord.title,
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily: 'Outfit',
                                          letterSpacing: 0.0,
                                        ),
                                  ).animateOnPageLoad(animationsMap[
                                      'textOnPageLoadAnimation']!),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      height: 32.0,
                                      decoration: BoxDecoration(
                                        color: valueOrDefault<Color>(
                                          () {
                                            if (columnVideosRecord.status ==
                                                'draft') {
                                              return const Color(0x6592109C);
                                            } else if (columnVideosRecord
                                                    .status ==
                                                'processing') {
                                              return const Color(0x66FCDC0C);
                                            } else {
                                              return const Color(0x67048178);
                                            }
                                          }(),
                                          const Color(0x6692109C),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      alignment: const AlignmentDirectional(0.0, 0.0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                        child: Text(
                                          valueOrDefault<String>(
                                            functions.capitalize(
                                                columnVideosRecord.status),
                                            'Draft',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Builder(
                                      builder: (context) => Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            10.0, 0.0, 0.0, 0.0),
                                        child: FlutterFlowIconButton(
                                          borderColor: Colors.transparent,
                                          borderRadius: 20.0,
                                          borderWidth: 1.0,
                                          buttonSize: 40.0,
                                          icon: Icon(
                                            Icons.settings_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 24.0,
                                          ),
                                          onPressed: () async {
                                            logFirebaseEvent(
                                                'VIDEOS_SHOW_settings_rounded_ICN_ON_TAP');
                                            await showDialog(
                                              barrierColor: Colors.transparent,
                                              context: context,
                                              builder: (dialogContext) {
                                                return Dialog(
                                                  elevation: 0,
                                                  insetPadding: EdgeInsets.zero,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  alignment:
                                                      const AlignmentDirectional(
                                                              0.0, 0.0)
                                                          .resolve(
                                                              Directionality.of(
                                                                  context)),
                                                  child: GestureDetector(
                                                    onTap: () => FocusScope.of(
                                                            dialogContext)
                                                        .unfocus(),
                                                    child:
                                                        ModalSelectCourseWidget(
                                                      videoReference:
                                                          columnVideosRecord,
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ).animateOnPageLoad(
                        animationsMap['containerOnPageLoadAnimation']!),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: TabBarView(
                              controller: _model.tabBarController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                Builder(
                                  builder: (context) {
                                    if (columnVideosRecord.translatedVideoUrl !=
                                            '') {
                                      return Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 20.0),
                                            child: Text(
                                              'Final result:',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .displayMedium
                                                      .override(
                                                        fontFamily: 'Outfit',
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                1.0,
                                            constraints: const BoxConstraints(
                                              maxWidth: 700.0,
                                            ),
                                            decoration: const BoxDecoration(),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                FlutterFlowVideoPlayer(
                                                  path: columnVideosRecord
                                                      .translatedVideoUrl,
                                                  videoType: VideoType.network,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          1.0,
                                                  autoPlay: false,
                                                  looping: true,
                                                  showControls: true,
                                                  allowFullScreen: false,
                                                  allowPlaybackSpeedMenu: false,
                                                  lazyLoad: false,
                                                ),
                                                if (isWeb)
                                                  FFButtonWidget(
                                                    onPressed: () {
                                                      print(
                                                          'Button pressed ...');
                                                    },
                                                    text: 'Download',
                                                    options: FFButtonOptions(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          1.0,
                                                      height: 60.0,
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  24.0,
                                                                  0.0,
                                                                  24.0,
                                                                  0.0),
                                                      iconPadding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      textStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .override(
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                color: Colors
                                                                    .white,
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                      elevation: 0.0,
                                                      borderSide: const BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                                12.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                12.0),
                                                        topLeft:
                                                            Radius.circular(
                                                                0.0),
                                                        topRight:
                                                            Radius.circular(
                                                                0.0),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    } else if (columnVideosRecord
                                            .captions.isNotEmpty) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            constraints: const BoxConstraints(
                                              maxWidth: 500.0,
                                            ),
                                            decoration: const BoxDecoration(),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 20.0, 0.0, 20.0),
                                              child: FlutterFlowAudioPlayer(
                                                audio: Audio.network(
                                                  functions.videoUrlToVideoPath(
                                                      columnVideosRecord
                                                          .originalVideoUrl),
                                                  metas: Metas(
                                                    title: ' ',
                                                  ),
                                                ),
                                                titleTextStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleLarge
                                                        .override(
                                                          fontFamily:
                                                              'Plus Jakarta Sans',
                                                          letterSpacing: 0.0,
                                                        ),
                                                playbackDurationTextStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              'Plus Jakarta Sans',
                                                          letterSpacing: 0.0,
                                                        ),
                                                fillColor: const Color(0x00000000),
                                                playbackButtonColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                activeTrackColor:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                elevation: 0.0,
                                                playInBackground: PlayInBackground
                                                    .disabledRestoreOnForeground,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Builder(
                                              builder: (context) {
                                                final allSentences =
                                                    columnVideosRecord.captions
                                                        .toList();

                                                return DataTable2(
                                                  columns: [
                                                    DataColumn2(
                                                      label: DefaultTextStyle
                                                          .merge(
                                                        softWrap: true,
                                                        child: Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: Text(
                                                            'Detected Sentence',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Plus Jakarta Sans',
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn2(
                                                      label: DefaultTextStyle
                                                          .merge(
                                                        softWrap: true,
                                                        child: Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: Text(
                                                            'Translation',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Plus Jakarta Sans',
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn2(
                                                      label: DefaultTextStyle
                                                          .merge(
                                                        softWrap: true,
                                                        child: Text(
                                                          ' ',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .labelLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                      ),
                                                      fixedWidth: 60.0,
                                                    ),
                                                  ],
                                                  rows: allSentences
                                                      .mapIndexed(
                                                          (allSentencesIndex,
                                                                  allSentencesItem) =>
                                                              [
                                                                Stack(
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          const AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                      child:
                                                                          ComponentListSentenceItemWidget(
                                                                        key: Key(
                                                                            'Keytrt_${allSentencesIndex}_of_${allSentences.length}'),
                                                                        sentence:
                                                                            allSentencesItem.original,
                                                                        index:
                                                                            allSentencesIndex,
                                                                        sentenceType:
                                                                            'original',
                                                                        video:
                                                                            columnVideosRecord,
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          const AlignmentDirectional(
                                                                              1.0,
                                                                              0.0),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            2.0,
                                                                        height:
                                                                            double.infinity,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).alternate,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Stack(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          15.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          ComponentListSentenceItemWidget(
                                                                        key: Key(
                                                                            'Key0f7_${allSentencesIndex}_of_${allSentences.length}'),
                                                                        sentence:
                                                                            allSentencesItem.translated,
                                                                        index:
                                                                            allSentencesIndex,
                                                                        sentenceType:
                                                                            'translated',
                                                                        video:
                                                                            columnVideosRecord,
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          const AlignmentDirectional(
                                                                              1.0,
                                                                              0.0),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            2.0,
                                                                        height:
                                                                            double.infinity,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).alternate,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      const AlignmentDirectional(
                                                                          1.0,
                                                                          0.0),
                                                                  child:
                                                                      SizedBox(
                                                                    width: 50.0,
                                                                    height:
                                                                        50.0,
                                                                    child: custom_widgets
                                                                        .PlayAudioButton(
                                                                      width:
                                                                          50.0,
                                                                      height:
                                                                          50.0,
                                                                      beginTime:
                                                                          allSentencesItem
                                                                              .begin,
                                                                      endTime:
                                                                          allSentencesItem
                                                                              .end,
                                                                      videoUrl:
                                                                          columnVideosRecord
                                                                              .originalVideoUrl,
                                                                      buttonColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .secondary,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ]
                                                                  .map((c) =>
                                                                      DataCell(
                                                                          c))
                                                                  .toList())
                                                      .map((e) =>
                                                          DataRow(cells: e))
                                                      .toList(),
                                                  headingRowColor:
                                                      WidgetStateProperty.all(
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                  ),
                                                  headingRowHeight: 56.0,
                                                  dataRowColor:
                                                      WidgetStateProperty.all(
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                  ),
                                                  dataRowHeight: 56.0,
                                                  border: TableBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                  ),
                                                  dividerThickness: 1.0,
                                                  columnSpacing: 0.0,
                                                  showBottomBorder: true,
                                                  minWidth: 49.0,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Container(
                                        decoration: const BoxDecoration(),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 20.0),
                                              child: SizedBox(
                                                width: 50.0,
                                                height: 50.0,
                                                child: custom_widgets
                                                    .CustomSpinner(
                                                  width: 50.0,
                                                  height: 50.0,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'We are generating your captions.\nPlease wait around 5 minutes before getting them ready.',
                                              textAlign: TextAlign.center,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Plus Jakarta Sans',
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: const BoxDecoration(),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child:
                                        custom_widgets.VideoPlayerWithProgress(
                                      width: double.infinity,
                                      height: double.infinity,
                                      videoUrl:
                                          columnVideosRecord.originalVideoUrl,
                                      progressColor:
                                          FlutterFlowTheme.of(context).primary,
                                      callback: () async {
                                        logFirebaseEvent(
                                            'VIDEOS_SHOW_Container_1chzdfv2_CALLBACK');

                                        await columnVideosRecord.reference
                                            .update({
                                          ...mapToFirestore(
                                            {
                                              'faceLocations':
                                                  getFaceLocationListFirestoreData(
                                                FFAppState().faceLocations,
                                              ),
                                            },
                                          ),
                                        });
                                        _model.startLipsyncingResponse =
                                            await CloudFunctionsStartLipSyncingCall
                                                .call(
                                          videoRecordId:
                                              widget.videoReference?.id,
                                          userId: currentUserUid,
                                          faceLocationsJson: FFAppState()
                                              .faceLocations
                                              .map((e) => e.toMap())
                                              .toList(),
                                          originalVideoUrl: columnVideosRecord
                                              .originalVideoUrl,
                                        );

                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: const Alignment(0.0, 0),
                            child: TabBar(
                              labelColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              unselectedLabelColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                              labelStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    letterSpacing: 0.0,
                                  ),
                              unselectedLabelStyle: const TextStyle(),
                              indicatorColor:
                                  FlutterFlowTheme.of(context).primary,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 3.0),
                              tabs: const [
                                Tab(
                                  text: 'Speech Editor',
                                ),
                                Tab(
                                  text: 'Face Locations',
                                ),
                              ],
                              controller: _model.tabBarController,
                              onTap: (i) async {
                                [() async {}, () async {}][i]();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (((_model.tabBarCurrentIndex == 0) &&
                            (columnVideosRecord.captions.isNotEmpty) &&
                            (columnVideosRecord.translatedVideoUrl == '') &&
                            (columnVideosRecord.status !=
                                'generatingTranslation')) ||
                        ((_model.tabBarCurrentIndex == 1) &&
                            (columnVideosRecord.faceLocations.isNotEmpty)))
                      FFButtonWidget(
                        onPressed: () {
                          print('Button pressed ...');
                        },
                        text: _model.tabBarCurrentIndex == 0
                            ? 'Start Translation'
                            : 'Start LipSyncing',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 70.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
