import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class VideosRecord extends FirestoreRecord {
  VideosRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "originalLanguageCode" field.
  String? _originalLanguageCode;
  String get originalLanguageCode => _originalLanguageCode ?? '';
  bool hasOriginalLanguageCode() => _originalLanguageCode != null;

  // "targetLanguageCode" field.
  String? _targetLanguageCode;
  String get targetLanguageCode => _targetLanguageCode ?? '';
  bool hasTargetLanguageCode() => _targetLanguageCode != null;

  // "voiceGender" field.
  String? _voiceGender;
  String get voiceGender => _voiceGender ?? '';
  bool hasVoiceGender() => _voiceGender != null;

  // "faceLocations" field.
  List<FaceLocationStruct>? _faceLocations;
  List<FaceLocationStruct> get faceLocations => _faceLocations ?? const [];
  bool hasFaceLocations() => _faceLocations != null;

  // "user_id" field.
  DocumentReference? _userId;
  DocumentReference? get userId => _userId;
  bool hasUserId() => _userId != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "course" field.
  DocumentReference? _course;
  DocumentReference? get course => _course;
  bool hasCourse() => _course != null;

  // "larkUrl" field.
  String? _larkUrl;
  String get larkUrl => _larkUrl ?? '';
  bool hasLarkUrl() => _larkUrl != null;

  // "captions" field.
  List<SentenceStruct>? _captions;
  List<SentenceStruct> get captions => _captions ?? const [];
  bool hasCaptions() => _captions != null;

  // "originalVideoUrl" field.
  String? _originalVideoUrl;
  String get originalVideoUrl => _originalVideoUrl ?? '';
  bool hasOriginalVideoUrl() => _originalVideoUrl != null;

  // "targetVoice" field.
  DocumentReference? _targetVoice;
  DocumentReference? get targetVoice => _targetVoice;
  bool hasTargetVoice() => _targetVoice != null;

  // "translatedVideoUrl" field.
  String? _translatedVideoUrl;
  String get translatedVideoUrl => _translatedVideoUrl ?? '';
  bool hasTranslatedVideoUrl() => _translatedVideoUrl != null;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _status = snapshotData['status'] as String?;
    _originalLanguageCode = snapshotData['originalLanguageCode'] as String?;
    _targetLanguageCode = snapshotData['targetLanguageCode'] as String?;
    _voiceGender = snapshotData['voiceGender'] as String?;
    _faceLocations = getStructList(
      snapshotData['faceLocations'],
      FaceLocationStruct.fromMap,
    );
    _userId = snapshotData['user_id'] as DocumentReference?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _course = snapshotData['course'] as DocumentReference?;
    _larkUrl = snapshotData['larkUrl'] as String?;
    _captions = getStructList(
      snapshotData['captions'],
      SentenceStruct.fromMap,
    );
    _originalVideoUrl = snapshotData['originalVideoUrl'] as String?;
    _targetVoice = snapshotData['targetVoice'] as DocumentReference?;
    _translatedVideoUrl = snapshotData['translatedVideoUrl'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('videos');

  static Stream<VideosRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => VideosRecord.fromSnapshot(s));

  static Future<VideosRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => VideosRecord.fromSnapshot(s));

  static VideosRecord fromSnapshot(DocumentSnapshot snapshot) => VideosRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static VideosRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      VideosRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'VideosRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is VideosRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createVideosRecordData({
  String? title,
  String? status,
  String? originalLanguageCode,
  String? targetLanguageCode,
  String? voiceGender,
  DocumentReference? userId,
  DateTime? createdAt,
  DocumentReference? course,
  String? larkUrl,
  String? originalVideoUrl,
  DocumentReference? targetVoice,
  String? translatedVideoUrl,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'status': status,
      'originalLanguageCode': originalLanguageCode,
      'targetLanguageCode': targetLanguageCode,
      'voiceGender': voiceGender,
      'user_id': userId,
      'created_at': createdAt,
      'course': course,
      'larkUrl': larkUrl,
      'originalVideoUrl': originalVideoUrl,
      'targetVoice': targetVoice,
      'translatedVideoUrl': translatedVideoUrl,
    }.withoutNulls,
  );

  return firestoreData;
}

class VideosRecordDocumentEquality implements Equality<VideosRecord> {
  const VideosRecordDocumentEquality();

  @override
  bool equals(VideosRecord? e1, VideosRecord? e2) {
    const listEquality = ListEquality();
    return e1?.title == e2?.title &&
        e1?.status == e2?.status &&
        e1?.originalLanguageCode == e2?.originalLanguageCode &&
        e1?.targetLanguageCode == e2?.targetLanguageCode &&
        e1?.voiceGender == e2?.voiceGender &&
        listEquality.equals(e1?.faceLocations, e2?.faceLocations) &&
        e1?.userId == e2?.userId &&
        e1?.createdAt == e2?.createdAt &&
        e1?.course == e2?.course &&
        e1?.larkUrl == e2?.larkUrl &&
        listEquality.equals(e1?.captions, e2?.captions) &&
        e1?.originalVideoUrl == e2?.originalVideoUrl &&
        e1?.targetVoice == e2?.targetVoice &&
        e1?.translatedVideoUrl == e2?.translatedVideoUrl;
  }

  @override
  int hash(VideosRecord? e) => const ListEquality().hash([
        e?.title,
        e?.status,
        e?.originalLanguageCode,
        e?.targetLanguageCode,
        e?.voiceGender,
        e?.faceLocations,
        e?.userId,
        e?.createdAt,
        e?.course,
        e?.larkUrl,
        e?.captions,
        e?.originalVideoUrl,
        e?.targetVoice,
        e?.translatedVideoUrl
      ]);

  @override
  bool isValidKey(Object? o) => o is VideosRecord;
}
