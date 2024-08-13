import 'dart:convert';
import '../cloud_functions/cloud_functions.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start Cloud Functions Production Group Code

class CloudFunctionsProductionGroup {
  static String getBaseUrl() =>
      'https://europe-west4-langflip-e8589.cloudfunctions.net';
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  static CreateCaptionsCall createCaptionsCall = CreateCaptionsCall();
  static StartLipsyncCall startLipsyncCall = StartLipsyncCall();
}

class CreateCaptionsCall {
  Future<ApiCallResponse> call({
    String? videoId = '',
  }) async {
    final baseUrl = CloudFunctionsProductionGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "videoId": "$videoId"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CreateCaptions',
      apiUrl: '$baseUrl/createCaptions',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class StartLipsyncCall {
  Future<ApiCallResponse> call({
    String? videoId = '',
    String? translationId = '',
  }) async {
    final baseUrl = CloudFunctionsProductionGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "videoId": "$videoId",
  "translationId": "$translationId",
  "action": "start"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Start Lipsync',
      apiUrl: '$baseUrl/startLipSync',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End Cloud Functions Production Group Code

class RunPodSoVitsSvcCall {
  static Future<ApiCallResponse> call({
    String? videoRecordId = '',
    dynamic captionsJson,
    String? voiceRecordId = '',
    String? larkBaseId = '',
  }) async {
    final captions = _serializeJson(captionsJson, true);
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'RunPodSoVitsSvcCall',
        'variables': {
          'videoRecordId': videoRecordId,
          'captions': captions,
          'voiceRecordId': voiceRecordId,
          'larkBaseId': larkBaseId,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }
}

class CloudFunctionsMoveAudiosCall {
  static Future<ApiCallResponse> call({
    String? firestoreRecordId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "record_id": "$firestoreRecordId"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Cloud Functions MoveAudios',
      apiUrl:
          'https://europe-west4-langflip-e8589.cloudfunctions.net/moveAudios',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CloudFunctionsStartLipSyncingCall {
  static Future<ApiCallResponse> call({
    String? videoRecordId = '',
    String? userId = '',
    String? originalVideoUrl = '',
    dynamic faceLocationsJson,
  }) async {
    final faceLocations = _serializeJson(faceLocationsJson, true);
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'CloudFunctionsStartLipSyncingCall',
        'variables': {
          'videoRecordId': videoRecordId,
          'userId': userId,
          'originalVideoUrl': originalVideoUrl,
          'faceLocations': faceLocations,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }
}

class RunpodOpenVoiceCall {
  static Future<ApiCallResponse> call({
    String? text = '',
    String? lang = '',
    String? referenceFile = '',
    double? speed,
    String? firestoreVoiceId = '',
    String? firestoreGenerationId = '',
  }) async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'RunpodOpenVoiceCall',
        'variables': {
          'text': text,
          'lang': lang,
          'referenceFile': referenceFile,
          'speed': speed,
          'firestoreVoiceId': firestoreVoiceId,
          'firestoreGenerationId': firestoreGenerationId,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
