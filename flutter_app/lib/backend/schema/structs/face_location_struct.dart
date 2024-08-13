// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class FaceLocationStruct extends FFFirebaseStruct {
  FaceLocationStruct({
    double? begin,
    double? end,
    bool? isFace,
    int? screenWidth,
    int? screenHeight,
    double? topLeftCornerX,
    double? topLeftCornerY,
    double? bottomRightCornerX,
    double? bottomRightCornerY,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _begin = begin,
        _end = end,
        _isFace = isFace,
        _screenWidth = screenWidth,
        _screenHeight = screenHeight,
        _topLeftCornerX = topLeftCornerX,
        _topLeftCornerY = topLeftCornerY,
        _bottomRightCornerX = bottomRightCornerX,
        _bottomRightCornerY = bottomRightCornerY,
        super(firestoreUtilData);

  // "begin" field.
  double? _begin;
  double get begin => _begin ?? 0.0;
  set begin(double? val) => _begin = val;

  void incrementBegin(double amount) => begin = begin + amount;

  bool hasBegin() => _begin != null;

  // "end" field.
  double? _end;
  double get end => _end ?? 0.0;
  set end(double? val) => _end = val;

  void incrementEnd(double amount) => end = end + amount;

  bool hasEnd() => _end != null;

  // "isFace" field.
  bool? _isFace;
  bool get isFace => _isFace ?? false;
  set isFace(bool? val) => _isFace = val;

  bool hasIsFace() => _isFace != null;

  // "screenWidth" field.
  int? _screenWidth;
  int get screenWidth => _screenWidth ?? 0;
  set screenWidth(int? val) => _screenWidth = val;

  void incrementScreenWidth(int amount) => screenWidth = screenWidth + amount;

  bool hasScreenWidth() => _screenWidth != null;

  // "screenHeight" field.
  int? _screenHeight;
  int get screenHeight => _screenHeight ?? 0;
  set screenHeight(int? val) => _screenHeight = val;

  void incrementScreenHeight(int amount) =>
      screenHeight = screenHeight + amount;

  bool hasScreenHeight() => _screenHeight != null;

  // "topLeftCornerX" field.
  double? _topLeftCornerX;
  double get topLeftCornerX => _topLeftCornerX ?? 0.0;
  set topLeftCornerX(double? val) => _topLeftCornerX = val;

  void incrementTopLeftCornerX(double amount) =>
      topLeftCornerX = topLeftCornerX + amount;

  bool hasTopLeftCornerX() => _topLeftCornerX != null;

  // "topLeftCornerY" field.
  double? _topLeftCornerY;
  double get topLeftCornerY => _topLeftCornerY ?? 0.0;
  set topLeftCornerY(double? val) => _topLeftCornerY = val;

  void incrementTopLeftCornerY(double amount) =>
      topLeftCornerY = topLeftCornerY + amount;

  bool hasTopLeftCornerY() => _topLeftCornerY != null;

  // "bottomRightCornerX" field.
  double? _bottomRightCornerX;
  double get bottomRightCornerX => _bottomRightCornerX ?? 0.0;
  set bottomRightCornerX(double? val) => _bottomRightCornerX = val;

  void incrementBottomRightCornerX(double amount) =>
      bottomRightCornerX = bottomRightCornerX + amount;

  bool hasBottomRightCornerX() => _bottomRightCornerX != null;

  // "bottomRightCornerY" field.
  double? _bottomRightCornerY;
  double get bottomRightCornerY => _bottomRightCornerY ?? 0.0;
  set bottomRightCornerY(double? val) => _bottomRightCornerY = val;

  void incrementBottomRightCornerY(double amount) =>
      bottomRightCornerY = bottomRightCornerY + amount;

  bool hasBottomRightCornerY() => _bottomRightCornerY != null;

  static FaceLocationStruct fromMap(Map<String, dynamic> data) =>
      FaceLocationStruct(
        begin: castToType<double>(data['begin']),
        end: castToType<double>(data['end']),
        isFace: data['isFace'] as bool?,
        screenWidth: castToType<int>(data['screenWidth']),
        screenHeight: castToType<int>(data['screenHeight']),
        topLeftCornerX: castToType<double>(data['topLeftCornerX']),
        topLeftCornerY: castToType<double>(data['topLeftCornerY']),
        bottomRightCornerX: castToType<double>(data['bottomRightCornerX']),
        bottomRightCornerY: castToType<double>(data['bottomRightCornerY']),
      );

  static FaceLocationStruct? maybeFromMap(dynamic data) => data is Map
      ? FaceLocationStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'begin': _begin,
        'end': _end,
        'isFace': _isFace,
        'screenWidth': _screenWidth,
        'screenHeight': _screenHeight,
        'topLeftCornerX': _topLeftCornerX,
        'topLeftCornerY': _topLeftCornerY,
        'bottomRightCornerX': _bottomRightCornerX,
        'bottomRightCornerY': _bottomRightCornerY,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'begin': serializeParam(
          _begin,
          ParamType.double,
        ),
        'end': serializeParam(
          _end,
          ParamType.double,
        ),
        'isFace': serializeParam(
          _isFace,
          ParamType.bool,
        ),
        'screenWidth': serializeParam(
          _screenWidth,
          ParamType.int,
        ),
        'screenHeight': serializeParam(
          _screenHeight,
          ParamType.int,
        ),
        'topLeftCornerX': serializeParam(
          _topLeftCornerX,
          ParamType.double,
        ),
        'topLeftCornerY': serializeParam(
          _topLeftCornerY,
          ParamType.double,
        ),
        'bottomRightCornerX': serializeParam(
          _bottomRightCornerX,
          ParamType.double,
        ),
        'bottomRightCornerY': serializeParam(
          _bottomRightCornerY,
          ParamType.double,
        ),
      }.withoutNulls;

  static FaceLocationStruct fromSerializableMap(Map<String, dynamic> data) =>
      FaceLocationStruct(
        begin: deserializeParam(
          data['begin'],
          ParamType.double,
          false,
        ),
        end: deserializeParam(
          data['end'],
          ParamType.double,
          false,
        ),
        isFace: deserializeParam(
          data['isFace'],
          ParamType.bool,
          false,
        ),
        screenWidth: deserializeParam(
          data['screenWidth'],
          ParamType.int,
          false,
        ),
        screenHeight: deserializeParam(
          data['screenHeight'],
          ParamType.int,
          false,
        ),
        topLeftCornerX: deserializeParam(
          data['topLeftCornerX'],
          ParamType.double,
          false,
        ),
        topLeftCornerY: deserializeParam(
          data['topLeftCornerY'],
          ParamType.double,
          false,
        ),
        bottomRightCornerX: deserializeParam(
          data['bottomRightCornerX'],
          ParamType.double,
          false,
        ),
        bottomRightCornerY: deserializeParam(
          data['bottomRightCornerY'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'FaceLocationStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FaceLocationStruct &&
        begin == other.begin &&
        end == other.end &&
        isFace == other.isFace &&
        screenWidth == other.screenWidth &&
        screenHeight == other.screenHeight &&
        topLeftCornerX == other.topLeftCornerX &&
        topLeftCornerY == other.topLeftCornerY &&
        bottomRightCornerX == other.bottomRightCornerX &&
        bottomRightCornerY == other.bottomRightCornerY;
  }

  @override
  int get hashCode => const ListEquality().hash([
        begin,
        end,
        isFace,
        screenWidth,
        screenHeight,
        topLeftCornerX,
        topLeftCornerY,
        bottomRightCornerX,
        bottomRightCornerY
      ]);
}

FaceLocationStruct createFaceLocationStruct({
  double? begin,
  double? end,
  bool? isFace,
  int? screenWidth,
  int? screenHeight,
  double? topLeftCornerX,
  double? topLeftCornerY,
  double? bottomRightCornerX,
  double? bottomRightCornerY,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    FaceLocationStruct(
      begin: begin,
      end: end,
      isFace: isFace,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      topLeftCornerX: topLeftCornerX,
      topLeftCornerY: topLeftCornerY,
      bottomRightCornerX: bottomRightCornerX,
      bottomRightCornerY: bottomRightCornerY,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

FaceLocationStruct? updateFaceLocationStruct(
  FaceLocationStruct? faceLocation, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    faceLocation
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addFaceLocationStructData(
  Map<String, dynamic> firestoreData,
  FaceLocationStruct? faceLocation,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (faceLocation == null) {
    return;
  }
  if (faceLocation.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && faceLocation.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final faceLocationData =
      getFaceLocationFirestoreData(faceLocation, forFieldValue);
  final nestedData =
      faceLocationData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = faceLocation.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getFaceLocationFirestoreData(
  FaceLocationStruct? faceLocation, [
  bool forFieldValue = false,
]) {
  if (faceLocation == null) {
    return {};
  }
  final firestoreData = mapToFirestore(faceLocation.toMap());

  // Add any Firestore field values
  faceLocation.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getFaceLocationListFirestoreData(
  List<FaceLocationStruct>? faceLocations,
) =>
    faceLocations?.map((e) => getFaceLocationFirestoreData(e, true)).toList() ??
    [];
