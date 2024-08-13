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

import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadFileToFirebase(
  String fileName,
  FFUploadedFile uploadedFile,
) async {
  final storageRef = FirebaseStorage.instance.ref();

  try {
    print('uploadFile() fileName => $fileName');

    await storageRef.child('uploads/$fileName').putData(uploadedFile.bytes!);

    final fullPath = storageRef.child('uploads/$fileName').fullPath;
    print('uploadFile() fullPath => $fullPath');

    final _downloadURL =
        await storageRef.child('uploads/$fileName').getDownloadURL();

    print('uploadFile() - downloadURL => $_downloadURL');
    return _downloadURL;
  } catch (e) {
    print('uploadFile() - Error uploading data: $e');
    return ''; // Return an empty string in case of error
  }
}
