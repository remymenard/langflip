import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_audio_player.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/v2/videos/components/component_no_translation/component_no_translation_widget.dart';
import '/v2/videos/components/modal_start_translation/modal_start_translation_widget.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'show_video_model.dart';
export 'show_video_model.dart';

class ShowVideoWidget extends StatefulWidget {
  const ShowVideoWidget({
    super.key,
    required this.videoReference,
  });

  final DocumentReference? videoReference;

  @override
  State<ShowVideoWidget> createState() => _ShowVideoWidgetState();
}

class _ShowVideoWidgetState extends State<ShowVideoWidget>
    with TickerProviderStateMixin {
  late ShowVideoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ShowVideoModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'ShowVideo'});
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 20.0),
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
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
              logFirebaseEvent('SHOW_VIDEO_arrow_back_rounded_ICN_ON_TAP');
              context.pop();
            },
          ),
          actions: const [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Align(
                alignment: const Alignment(0.0, 0),
                child: TabBar(
                  labelColor: FlutterFlowTheme.of(context).primaryText,
                  unselectedLabelColor:
                      FlutterFlowTheme.of(context).secondaryText,
                  labelStyle: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Plus Jakarta Sans',
                        letterSpacing: 0.0,
                      ),
                  unselectedLabelStyle: const TextStyle(),
                  indicatorColor: FlutterFlowTheme.of(context).primary,
                  padding: const EdgeInsets.all(4.0),
                  tabs: const [
                    Tab(
                      text: 'Captions',
                    ),
                    Tab(
                      text: 'Translations',
                    ),
                  ],
                  controller: _model.tabBarController,
                  onTap: (i) async {
                    [() async {}, () async {}][i]();
                  },
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _model.tabBarController,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          40.0, 20.0, 40.0, 25.0),
                      child: StreamBuilder<VideosRecord>(
                        stream:
                            VideosRecord.getDocument(widget.videoReference!),
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

                          final containerVideosRecord = snapshot.data!;

                          return Container(
                            decoration: const BoxDecoration(),
                            child: Builder(
                              builder: (context) {
                                if (containerVideosRecord.captions.isNotEmpty) {
                                  return Stack(
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 20.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 0.0, 5.0),
                                                  child: Text(
                                                    'Captions',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .headlineLarge
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          lineHeight: 1.0,
                                                        ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          20.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'Powered by ',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              fontSize: 12.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                            ),
                                                      ),
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.asset(
                                                          'assets/images/Google_Gemini_logo.svg.png',
                                                          width: 77.0,
                                                          height: 23.0,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 4.0, 0.0, 8.0),
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  1.0,
                                              height: 1.0,
                                              decoration: const BoxDecoration(
                                                color: Color(0x46606A85),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 20.0, 0.0, 40.0),
                                            child: Container(
                                              constraints: const BoxConstraints(
                                                maxWidth: 500.0,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0x2792109C),
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 20.0, 0.0, 20.0),
                                                child: FlutterFlowAudioPlayer(
                                                  audio: Audio.network(
                                                    functions.videoUrlToVideoPath(
                                                        containerVideosRecord
                                                            .originalVideoUrl),
                                                    metas: Metas(
                                                      title: ' ',
                                                    ),
                                                  ),
                                                  titleTextStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLarge
                                                          .override(
                                                            fontFamily:
                                                                'Plus Jakarta Sans',
                                                            letterSpacing: 0.0,
                                                          ),
                                                  playbackDurationTextStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                'Plus Jakarta Sans',
                                                            letterSpacing: 0.0,
                                                          ),
                                                  fillColor: const Color(0x00000000),
                                                  playbackButtonColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondary,
                                                  activeTrackColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .alternate,
                                                  elevation: 0.0,
                                                  playInBackground: PlayInBackground
                                                      .disabledRestoreOnForeground,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Builder(
                                            builder: (context) {
                                              final captions =
                                                  containerVideosRecord.captions
                                                      .toList();

                                              return ListView.builder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount: captions.length,
                                                itemBuilder:
                                                    (context, captionsIndex) {
                                                  final captionsItem =
                                                      captions[captionsIndex];
                                                  return Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      8.0,
                                                                      0.0,
                                                                      8.0,
                                                                      0.0),
                                                          child: custom_widgets
                                                              .ColoredTextField(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                1.0,
                                                            height: 0.0,
                                                            initialText:
                                                                captionsItem
                                                                    .original,
                                                            textColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                            highlightedTextColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .warning,
                                                            callback:
                                                                (newText) async {
                                                              logFirebaseEvent(
                                                                  'SHOW_VIDEO_Container_h14l93h7_CALLBACK');
                                                              _model.captionsStored =
                                                                  containerVideosRecord
                                                                      .captions
                                                                      .toList()
                                                                      .cast<
                                                                          SentenceStruct>();
                                                              _model
                                                                  .updateCaptionsStoredAtIndex(
                                                                captionsIndex,
                                                                (e) => e
                                                                  ..original =
                                                                      newText,
                                                              );
                                                              setState(() {});

                                                              await widget
                                                                  .videoReference!
                                                                  .update({
                                                                ...mapToFirestore(
                                                                  {
                                                                    'captions':
                                                                        getSentenceListFirestoreData(
                                                                      _model
                                                                          .captionsStored,
                                                                    ),
                                                                  },
                                                                ),
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                1.0, 0.0),
                                                        child: SizedBox(
                                                          width: 50.0,
                                                          height: 50.0,
                                                          child: custom_widgets
                                                              .PlayAudioButton(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            beginTime:
                                                                captionsItem
                                                                    .begin,
                                                            endTime:
                                                                captionsItem
                                                                    .end,
                                                            videoUrl:
                                                                containerVideosRecord
                                                                    .originalVideoUrl,
                                                            buttonColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment:
                                            const AlignmentDirectional(1.0, 1.0),
                                        child: Builder(
                                          builder: (context) => FFButtonWidget(
                                            onPressed: () async {
                                              logFirebaseEvent(
                                                  'SHOW_VIDEO_NEW_TRANSLATION_BTN_ON_TAP');
                                              await showDialog(
                                                context: context,
                                                builder: (dialogContext) {
                                                  return Dialog(
                                                    elevation: 0,
                                                    insetPadding:
                                                        EdgeInsets.zero,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    alignment:
                                                        const AlignmentDirectional(
                                                                0.0, 0.0)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          FocusScope.of(
                                                                  dialogContext)
                                                              .unfocus(),
                                                      child:
                                                          ModalStartTranslationWidget(
                                                        videoReference:
                                                            containerVideosRecord,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            text: 'New Translation',
                                            options: FFButtonOptions(
                                              width: 247.0,
                                              height: 61.0,
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      24.0, 0.0, 24.0, 0.0),
                                              iconPadding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily:
                                                            'Plus Jakarta Sans',
                                                        color: Colors.white,
                                                        letterSpacing: 0.0,
                                                      ),
                                              elevation: 3.0,
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                                width: 1.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Align(
                                    alignment: const AlignmentDirectional(0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 80.0,
                                          height: 80.0,
                                          child: custom_widgets.CustomSpinner(
                                            width: 80.0,
                                            height: 80.0,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 20.0, 0.0, 0.0),
                                          child: Text(
                                            'We are currently generating  your captions. \nIt might take around a minute.',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      'Plus Jakarta Sans',
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(),
                      child: StreamBuilder<List<TranslationsRecord>>(
                        stream: queryTranslationsRecord(
                          parent: widget.videoReference,
                          queryBuilder: (translationsRecord) =>
                              translationsRecord.orderBy('created_at',
                                  descending: true),
                        ),
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
                          List<TranslationsRecord>
                              listViewTranslationsRecordList = snapshot.data!;
                          if (listViewTranslationsRecordList.isEmpty) {
                            return const ComponentNoTranslationWidget();
                          }

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            itemCount: listViewTranslationsRecordList.length,
                            itemBuilder: (context, listViewIndex) {
                              final listViewTranslationsRecord =
                                  listViewTranslationsRecordList[listViewIndex];
                              return Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 8.0, 16.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    logFirebaseEvent(
                                        'SHOW_VIDEO_Container_t9ausxji_ON_TAP');

                                    context.pushNamed(
                                      'ShowTranslatedVideo',
                                      queryParameters: {
                                        'translationReference': serializeParam(
                                          listViewTranslationsRecord.reference,
                                          ParamType.DocumentReference,
                                        ),
                                      }.withoutNulls,
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 60.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 3.0,
                                          color: Color(0x20000000),
                                          offset: Offset(
                                            0.0,
                                            1.0,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          8.0, 8.0, 12.0, 8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      65.0, 0.0, 0.0, 0.0),
                                              child: Text(
                                                listViewTranslationsRecord
                                                    .targetLanguage,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily:
                                                              'Plus Jakarta Sans',
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                            ),
                                          ),
                                          if (listViewTranslationsRecord
                                                      .lipsyncedVideoUrl ==
                                                  '')
                                            SizedBox(
                                              width: 40.0,
                                              height: 40.0,
                                              child:
                                                  custom_widgets.CustomSpinner(
                                                width: 40.0,
                                                height: 40.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ).animateOnPageLoad(animationsMap[
                                    'containerOnPageLoadAnimation']!),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
