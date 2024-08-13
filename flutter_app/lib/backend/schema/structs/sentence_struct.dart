// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class SentenceStruct extends FFFirebaseStruct {
  SentenceStruct({
    String? original,
    String? translated,
    double? end,
    String? larkRecordId,
    double? begin,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _original = original,
        _translated = translated,
        _end = end,
        _larkRecordId = larkRecordId,
        _begin = begin,
        super(firestoreUtilData);

  // "original" field.
  String? _original;
  String get original => _original ?? '';
  set original(String? val) => _original = val;

  bool hasOriginal() => _original != null;

  // "translated" field.
  String? _translated;
  String get translated => _translated ?? '';
  set translated(String? val) => _translated = val;

  bool hasTranslated() => _translated != null;

  // "end" field.
  double? _end;
  double get end => _end ?? 0.0;
  set end(double? val) => _end = val;

  void incrementEnd(double amount) => end = end + amount;

  bool hasEnd() => _end != null;

  // "lark_record_id" field.
  String? _larkRecordId;
  String get larkRecordId => _larkRecordId ?? '';
  set larkRecordId(String? val) => _larkRecordId = val;

  bool hasLarkRecordId() => _larkRecordId != null;

  // "begin" field.
  double? _begin;
  double get begin => _begin ?? 0.0;
  set begin(double? val) => _begin = val;

  void incrementBegin(double amount) => begin = begin + amount;

  bool hasBegin() => _begin != null;

  static SentenceStruct fromMap(Map<String, dynamic> data) => SentenceStruct(
        original: data['original'] as String?,
        translated: data['translated'] as String?,
        end: castToType<double>(data['end']),
        larkRecordId: data['lark_record_id'] as String?,
        begin: castToType<double>(data['begin']),
      );

  static SentenceStruct? maybeFromMap(dynamic data) =>
      data is Map ? SentenceStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'original': _original,
        'translated': _translated,
        'end': _end,
        'lark_record_id': _larkRecordId,
        'begin': _begin,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'original': serializeParam(
          _original,
          ParamType.String,
        ),
        'translated': serializeParam(
          _translated,
          ParamType.String,
        ),
        'end': serializeParam(
          _end,
          ParamType.double,
        ),
        'lark_record_id': serializeParam(
          _larkRecordId,
          ParamType.String,
        ),
        'begin': serializeParam(
          _begin,
          ParamType.double,
        ),
      }.withoutNulls;

  static SentenceStruct fromSerializableMap(Map<String, dynamic> data) =>
      SentenceStruct(
        original: deserializeParam(
          data['original'],
          ParamType.String,
          false,
        ),
        translated: deserializeParam(
          data['translated'],
          ParamType.String,
          false,
        ),
        end: deserializeParam(
          data['end'],
          ParamType.double,
          false,
        ),
        larkRecordId: deserializeParam(
          data['lark_record_id'],
          ParamType.String,
          false,
        ),
        begin: deserializeParam(
          data['begin'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'SentenceStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SentenceStruct &&
        original == other.original &&
        translated == other.translated &&
        end == other.end &&
        larkRecordId == other.larkRecordId &&
        begin == other.begin;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([original, translated, end, larkRecordId, begin]);
}

SentenceStruct createSentenceStruct({
  String? original,
  String? translated,
  double? end,
  String? larkRecordId,
  double? begin,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SentenceStruct(
      original: original,
      translated: translated,
      end: end,
      larkRecordId: larkRecordId,
      begin: begin,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SentenceStruct? updateSentenceStruct(
  SentenceStruct? sentence, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    sentence
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSentenceStructData(
  Map<String, dynamic> firestoreData,
  SentenceStruct? sentence,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (sentence == null) {
    return;
  }
  if (sentence.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && sentence.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final sentenceData = getSentenceFirestoreData(sentence, forFieldValue);
  final nestedData = sentenceData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = sentence.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSentenceFirestoreData(
  SentenceStruct? sentence, [
  bool forFieldValue = false,
]) {
  if (sentence == null) {
    return {};
  }
  final firestoreData = mapToFirestore(sentence.toMap());

  // Add any Firestore field values
  sentence.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSentenceListFirestoreData(
  List<SentenceStruct>? sentences,
) =>
    sentences?.map((e) => getSentenceFirestoreData(e, true)).toList() ?? [];
