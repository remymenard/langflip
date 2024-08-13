import 'package:flutter/material.dart';
import 'flutter_flow/request_manager.dart';
import '/backend/backend.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  List<FaceLocationStruct> _faceLocations = [];
  List<FaceLocationStruct> get faceLocations => _faceLocations;
  set faceLocations(List<FaceLocationStruct> value) {
    _faceLocations = value;
  }

  void addToFaceLocations(FaceLocationStruct value) {
    faceLocations.add(value);
  }

  void removeFromFaceLocations(FaceLocationStruct value) {
    faceLocations.remove(value);
  }

  void removeAtIndexFromFaceLocations(int index) {
    faceLocations.removeAt(index);
  }

  void updateFaceLocationsAtIndex(
    int index,
    FaceLocationStruct Function(FaceLocationStruct) updateFn,
  ) {
    faceLocations[index] = updateFn(_faceLocations[index]);
  }

  void insertAtIndexInFaceLocations(int index, FaceLocationStruct value) {
    faceLocations.insert(index, value);
  }

  final _getUserCoursesManager = StreamRequestManager<List<CoursesRecord>>();
  Stream<List<CoursesRecord>> getUserCourses({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<CoursesRecord>> Function() requestFn,
  }) =>
      _getUserCoursesManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearGetUserCoursesCache() => _getUserCoursesManager.clear();
  void clearGetUserCoursesCacheKey(String? uniqueKey) =>
      _getUserCoursesManager.clearRequest(uniqueKey);
}
