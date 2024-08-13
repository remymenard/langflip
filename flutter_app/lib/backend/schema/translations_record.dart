import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TranslationsRecord extends FirestoreRecord {
  TranslationsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "target_language" field.
  String? _targetLanguage;
  String get targetLanguage => _targetLanguage ?? '';
  bool hasTargetLanguage() => _targetLanguage != null;

  // "user_id" field.
  DocumentReference? _userId;
  DocumentReference? get userId => _userId;
  bool hasUserId() => _userId != null;

  // "voice_id" field.
  DocumentReference? _voiceId;
  DocumentReference? get voiceId => _voiceId;
  bool hasVoiceId() => _voiceId != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "lipsynced_video_url" field.
  String? _lipsyncedVideoUrl;
  String get lipsyncedVideoUrl => _lipsyncedVideoUrl ?? '';
  bool hasLipsyncedVideoUrl() => _lipsyncedVideoUrl != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _targetLanguage = snapshotData['target_language'] as String?;
    _userId = snapshotData['user_id'] as DocumentReference?;
    _voiceId = snapshotData['voice_id'] as DocumentReference?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _lipsyncedVideoUrl = snapshotData['lipsynced_video_url'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('translations')
          : FirebaseFirestore.instance.collectionGroup('translations');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('translations').doc(id);

  static Stream<TranslationsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TranslationsRecord.fromSnapshot(s));

  static Future<TranslationsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TranslationsRecord.fromSnapshot(s));

  static TranslationsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      TranslationsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TranslationsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TranslationsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TranslationsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TranslationsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTranslationsRecordData({
  String? targetLanguage,
  DocumentReference? userId,
  DocumentReference? voiceId,
  DateTime? createdAt,
  String? lipsyncedVideoUrl,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'target_language': targetLanguage,
      'user_id': userId,
      'voice_id': voiceId,
      'created_at': createdAt,
      'lipsynced_video_url': lipsyncedVideoUrl,
    }.withoutNulls,
  );

  return firestoreData;
}

class TranslationsRecordDocumentEquality
    implements Equality<TranslationsRecord> {
  const TranslationsRecordDocumentEquality();

  @override
  bool equals(TranslationsRecord? e1, TranslationsRecord? e2) {
    return e1?.targetLanguage == e2?.targetLanguage &&
        e1?.userId == e2?.userId &&
        e1?.voiceId == e2?.voiceId &&
        e1?.createdAt == e2?.createdAt &&
        e1?.lipsyncedVideoUrl == e2?.lipsyncedVideoUrl;
  }

  @override
  int hash(TranslationsRecord? e) => const ListEquality().hash([
        e?.targetLanguage,
        e?.userId,
        e?.voiceId,
        e?.createdAt,
        e?.lipsyncedVideoUrl
      ]);

  @override
  bool isValidKey(Object? o) => o is TranslationsRecord;
}
