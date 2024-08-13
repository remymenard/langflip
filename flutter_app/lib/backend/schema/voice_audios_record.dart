import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class VoiceAudiosRecord extends FirestoreRecord {
  VoiceAudiosRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "url" field.
  String? _url;
  String get url => _url ?? '';
  bool hasUrl() => _url != null;

  // "duration" field.
  int? _duration;
  int get duration => _duration ?? 0;
  bool hasDuration() => _duration != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _url = snapshotData['url'] as String?;
    _duration = castToType<int>(snapshotData['duration']);
    _createdAt = snapshotData['created_at'] as DateTime?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('voiceAudios')
          : FirebaseFirestore.instance.collectionGroup('voiceAudios');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('voiceAudios').doc(id);

  static Stream<VoiceAudiosRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => VoiceAudiosRecord.fromSnapshot(s));

  static Future<VoiceAudiosRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => VoiceAudiosRecord.fromSnapshot(s));

  static VoiceAudiosRecord fromSnapshot(DocumentSnapshot snapshot) =>
      VoiceAudiosRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static VoiceAudiosRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      VoiceAudiosRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'VoiceAudiosRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is VoiceAudiosRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createVoiceAudiosRecordData({
  String? url,
  int? duration,
  DateTime? createdAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'url': url,
      'duration': duration,
      'created_at': createdAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class VoiceAudiosRecordDocumentEquality implements Equality<VoiceAudiosRecord> {
  const VoiceAudiosRecordDocumentEquality();

  @override
  bool equals(VoiceAudiosRecord? e1, VoiceAudiosRecord? e2) {
    return e1?.url == e2?.url &&
        e1?.duration == e2?.duration &&
        e1?.createdAt == e2?.createdAt;
  }

  @override
  int hash(VoiceAudiosRecord? e) =>
      const ListEquality().hash([e?.url, e?.duration, e?.createdAt]);

  @override
  bool isValidKey(Object? o) => o is VoiceAudiosRecord;
}
