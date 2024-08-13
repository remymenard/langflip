// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:dio/dio.dart';

Future<bool> startLipSyncing(
  String videoUrl,
  String userId,
  String videoFirestoreId,
  List<dynamic> faceLocations,
) async {
  var dio = Dio();

  // Extracting the ID from the video URL
  var idPattern = RegExp(r'uploads%2F(\d+)\.mp4');
  var match = idPattern.firstMatch(videoUrl);
  String recordId = match?.group(1) ?? '';

  var data = {
    "record_id": recordId,
    "user_id": userId,
    "firestore_id": videoFirestoreId,
    "data": faceLocations
  };

  try {
    Response response = await dio.post(
      'https://europe-west4-langflip-e8589.cloudfunctions.net/lipsyncing_preprocess',
      data: data,
    );
    print(response.data);
    return true;
  } catch (e) {
    print('Error sending the POST request: $e');
    return false;
  }
}
