// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class LanguageStruct extends FFFirebaseStruct {
  LanguageStruct({
    String? threeDigitsCode,
    String? fourDigitsCode,
    String? name,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _threeDigitsCode = threeDigitsCode,
        _fourDigitsCode = fourDigitsCode,
        _name = name,
        super(firestoreUtilData);

  // "three_digits_code" field.
  String? _threeDigitsCode;
  String get threeDigitsCode => _threeDigitsCode ?? '';
  set threeDigitsCode(String? val) => _threeDigitsCode = val;

  bool hasThreeDigitsCode() => _threeDigitsCode != null;

  // "four_digits_code" field.
  String? _fourDigitsCode;
  String get fourDigitsCode => _fourDigitsCode ?? '';
  set fourDigitsCode(String? val) => _fourDigitsCode = val;

  bool hasFourDigitsCode() => _fourDigitsCode != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  static LanguageStruct fromMap(Map<String, dynamic> data) => LanguageStruct(
        threeDigitsCode: data['three_digits_code'] as String?,
        fourDigitsCode: data['four_digits_code'] as String?,
        name: data['name'] as String?,
      );

  static LanguageStruct? maybeFromMap(dynamic data) =>
      data is Map ? LanguageStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'three_digits_code': _threeDigitsCode,
        'four_digits_code': _fourDigitsCode,
        'name': _name,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'three_digits_code': serializeParam(
          _threeDigitsCode,
          ParamType.String,
        ),
        'four_digits_code': serializeParam(
          _fourDigitsCode,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
      }.withoutNulls;

  static LanguageStruct fromSerializableMap(Map<String, dynamic> data) =>
      LanguageStruct(
        threeDigitsCode: deserializeParam(
          data['three_digits_code'],
          ParamType.String,
          false,
        ),
        fourDigitsCode: deserializeParam(
          data['four_digits_code'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'LanguageStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LanguageStruct &&
        threeDigitsCode == other.threeDigitsCode &&
        fourDigitsCode == other.fourDigitsCode &&
        name == other.name;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([threeDigitsCode, fourDigitsCode, name]);
}

LanguageStruct createLanguageStruct({
  String? threeDigitsCode,
  String? fourDigitsCode,
  String? name,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    LanguageStruct(
      threeDigitsCode: threeDigitsCode,
      fourDigitsCode: fourDigitsCode,
      name: name,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

LanguageStruct? updateLanguageStruct(
  LanguageStruct? language, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    language
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addLanguageStructData(
  Map<String, dynamic> firestoreData,
  LanguageStruct? language,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (language == null) {
    return;
  }
  if (language.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && language.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final languageData = getLanguageFirestoreData(language, forFieldValue);
  final nestedData = languageData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = language.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getLanguageFirestoreData(
  LanguageStruct? language, [
  bool forFieldValue = false,
]) {
  if (language == null) {
    return {};
  }
  final firestoreData = mapToFirestore(language.toMap());

  // Add any Firestore field values
  language.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getLanguageListFirestoreData(
  List<LanguageStruct>? languages,
) =>
    languages?.map((e) => getLanguageFirestoreData(e, true)).toList() ?? [];
