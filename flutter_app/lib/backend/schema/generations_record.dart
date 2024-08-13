import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GenerationsRecord extends FirestoreRecord {
  GenerationsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "url" field.
  String? _url;
  String get url => _url ?? '';
  bool hasUrl() => _url != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "duration" field.
  int? _duration;
  int get duration => _duration ?? 0;
  bool hasDuration() => _duration != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "language" field.
  String? _language;
  String get language => _language ?? '';
  bool hasLanguage() => _language != null;

  // "speed" field.
  double? _speed;
  double get speed => _speed ?? 0.0;
  bool hasSpeed() => _speed != null;

  // "show_in_generations" field.
  bool? _showInGenerations;
  bool get showInGenerations => _showInGenerations ?? false;
  bool hasShowInGenerations() => _showInGenerations != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _url = snapshotData['url'] as String?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _duration = castToType<int>(snapshotData['duration']);
    _status = snapshotData['status'] as String?;
    _language = snapshotData['language'] as String?;
    _speed = castToType<double>(snapshotData['speed']);
    _showInGenerations = snapshotData['show_in_generations'] as bool?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('generations')
          : FirebaseFirestore.instance.collectionGroup('generations');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('generations').doc(id);

  static Stream<GenerationsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => GenerationsRecord.fromSnapshot(s));

  static Future<GenerationsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => GenerationsRecord.fromSnapshot(s));

  static GenerationsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      GenerationsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static GenerationsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      GenerationsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'GenerationsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is GenerationsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createGenerationsRecordData({
  String? url,
  DateTime? createdAt,
  int? duration,
  String? status,
  String? language,
  double? speed,
  bool? showInGenerations,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'url': url,
      'created_at': createdAt,
      'duration': duration,
      'status': status,
      'language': language,
      'speed': speed,
      'show_in_generations': showInGenerations,
    }.withoutNulls,
  );

  return firestoreData;
}

class GenerationsRecordDocumentEquality implements Equality<GenerationsRecord> {
  const GenerationsRecordDocumentEquality();

  @override
  bool equals(GenerationsRecord? e1, GenerationsRecord? e2) {
    return e1?.url == e2?.url &&
        e1?.createdAt == e2?.createdAt &&
        e1?.duration == e2?.duration &&
        e1?.status == e2?.status &&
        e1?.language == e2?.language &&
        e1?.speed == e2?.speed &&
        e1?.showInGenerations == e2?.showInGenerations;
  }

  @override
  int hash(GenerationsRecord? e) => const ListEquality().hash([
        e?.url,
        e?.createdAt,
        e?.duration,
        e?.status,
        e?.language,
        e?.speed,
        e?.showInGenerations
      ]);

  @override
  bool isValidKey(Object? o) => o is GenerationsRecord;
}
