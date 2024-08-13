import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class VoicesRecord extends FirestoreRecord {
  VoicesRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "photo" field.
  String? _photo;
  String get photo => _photo ?? '';
  bool hasPhoto() => _photo != null;

  // "user_id" field.
  DocumentReference? _userId;
  DocumentReference? get userId => _userId;
  bool hasUserId() => _userId != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "updated_at" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  bool hasUpdatedAt() => _updatedAt != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "totalTrainingTime" field.
  int? _totalTrainingTime;
  int get totalTrainingTime => _totalTrainingTime ?? 0;
  bool hasTotalTrainingTime() => _totalTrainingTime != null;

  // "audioUrl" field.
  String? _audioUrl;
  String get audioUrl => _audioUrl ?? '';
  bool hasAudioUrl() => _audioUrl != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _photo = snapshotData['photo'] as String?;
    _userId = snapshotData['user_id'] as DocumentReference?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _updatedAt = snapshotData['updated_at'] as DateTime?;
    _status = snapshotData['status'] as String?;
    _totalTrainingTime = castToType<int>(snapshotData['totalTrainingTime']);
    _audioUrl = snapshotData['audioUrl'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('voices');

  static Stream<VoicesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => VoicesRecord.fromSnapshot(s));

  static Future<VoicesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => VoicesRecord.fromSnapshot(s));

  static VoicesRecord fromSnapshot(DocumentSnapshot snapshot) => VoicesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static VoicesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      VoicesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'VoicesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is VoicesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createVoicesRecordData({
  String? name,
  String? photo,
  DocumentReference? userId,
  DateTime? createdAt,
  DateTime? updatedAt,
  String? status,
  int? totalTrainingTime,
  String? audioUrl,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'photo': photo,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status,
      'totalTrainingTime': totalTrainingTime,
      'audioUrl': audioUrl,
    }.withoutNulls,
  );

  return firestoreData;
}

class VoicesRecordDocumentEquality implements Equality<VoicesRecord> {
  const VoicesRecordDocumentEquality();

  @override
  bool equals(VoicesRecord? e1, VoicesRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.photo == e2?.photo &&
        e1?.userId == e2?.userId &&
        e1?.createdAt == e2?.createdAt &&
        e1?.updatedAt == e2?.updatedAt &&
        e1?.status == e2?.status &&
        e1?.totalTrainingTime == e2?.totalTrainingTime &&
        e1?.audioUrl == e2?.audioUrl;
  }

  @override
  int hash(VoicesRecord? e) => const ListEquality().hash([
        e?.name,
        e?.photo,
        e?.userId,
        e?.createdAt,
        e?.updatedAt,
        e?.status,
        e?.totalTrainingTime,
        e?.audioUrl
      ]);

  @override
  bool isValidKey(Object? o) => o is VoicesRecord;
}
