import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/auth/firebase_auth/auth_util.dart';

String? capitalize(String word) {
  List<String> words = word.split(' ');
  for (int i = 0; i < words.length; i++) {
    String word = words[i];
    if (word.isNotEmpty) {
      words[i] = word[0].toUpperCase() + word.substring(1);
    }
  }
  return words.join(' ');
}

bool verifyUploadedVideoIsMp4(FFUploadedFile uploadedVideo) {
  // verify uploaded file is an mp4 file
  return uploadedVideo.name?.endsWith(".mp4") ?? false;
}

String convertIntToMinutes(int duration) {
  int minutes = duration ~/ 60;
  int seconds = duration % 60;

  return "${minutes}m${seconds.toString().padLeft(2, '0')}";
}

DocumentReference convertCourseReferenceString(String courseReference) {
  return FirebaseFirestore.instance.collection('courses').doc(courseReference);
}

String videoUrlToVideoPath(String videoUrl) {
  return videoUrl;
}

DocumentReference convertVoiceReferenceString(String voiceReference) {
  return FirebaseFirestore.instance.collection('voices').doc(voiceReference);
}

String passStringThroughRegex(
  String originalString,
  String regex,
) {
  var idPattern = RegExp(regex);
  var match = idPattern.firstMatch(originalString);
  return match?.group(1) ?? '';
}

String audioToString(String audioPath) {
  return audioPath;
}
