const axios = require("axios").default;
const qs = require("qs");

async function _runPodSoVitsSvcCall(context, ffVariables) {
  var videoRecordId = ffVariables["videoRecordId"];
  var captions = ffVariables["captions"];
  var voiceRecordId = ffVariables["voiceRecordId"];
  var larkBaseId = ffVariables["larkBaseId"];

  var url = `https://api.runpod.ai/v2/lmccaag5j31n9u/run`;
  var headers = {
    Authorization: `Bearer YOUR_API_KEY`,
  };
  var params = {};
  var ffApiRequestBody = `
{
  "input": {
    "action": "infer",
    "video_record_id": "${videoRecordId}",
    "voice_record_id": "${voiceRecordId}",
    "lark_base_id": "${larkBaseId}",
    "captions": ${captions}
  }
}`;

  return makeApiRequest({
    method: "post",
    url,
    headers,
    params,
    body: createBody({
      headers,
      params,
      body: ffApiRequestBody,
      bodyType: "JSON",
    }),
    returnBody: true,
    isStreamingApi: false,
  });
}
async function _cloudFunctionsStartLipSyncingCall(context, ffVariables) {
  var videoRecordId = ffVariables["videoRecordId"];
  var userId = ffVariables["userId"];
  var originalVideoUrl = ffVariables["originalVideoUrl"];
  var faceLocations = ffVariables["faceLocations"];

  var url = `https://europe-west4-langflip-e8589.cloudfunctions.net/lipsyncing_preprocess`;
  var headers = {};
  var params = {};
  var ffApiRequestBody = `
{
  "original_video_url": "${originalVideoUrl}",
  "user_id": "${userId}",
  "firestore_id": "${videoRecordId}",
  "data": ${faceLocations}
}`;

  return makeApiRequest({
    method: "post",
    url,
    headers,
    params,
    body: createBody({
      headers,
      params,
      body: ffApiRequestBody,
      bodyType: "JSON",
    }),
    returnBody: true,
    isStreamingApi: false,
  });
}
async function _runpodOpenVoiceCall(context, ffVariables) {
  if (!context.auth) {
    return _unauthenticatedResponse;
  }
  var text = ffVariables["text"];
  var lang = ffVariables["lang"];
  var referenceFile = ffVariables["referenceFile"];
  var speed = ffVariables["speed"];
  var firestoreVoiceId = ffVariables["firestoreVoiceId"];
  var firestoreGenerationId = ffVariables["firestoreGenerationId"];

  var url = `https://api.runpod.ai/v2/a5y9b11ycnau4f/run`;
  var headers = {
    Authorization: `Bearer YOUR_API_KEY`,
  };
  var params = {};
  var ffApiRequestBody = `
{
  "input": {
    "text": "${text}",
    "reference": "${referenceFile}",
    "lang": "${lang}",
    "speed": ${speed},
    "firestore_generation_id": "${firestoreGenerationId}",
    "firestore_voice_id": "${firestoreVoiceId}"
  }
}`;

  return makeApiRequest({
    method: "post",
    url,
    headers,
    params,
    body: createBody({
      headers,
      params,
      body: ffApiRequestBody,
      bodyType: "JSON",
    }),
    returnBody: true,
    isStreamingApi: false,
  });
}

/// Helper functions to route to the appropriate API Call.

async function makeApiCall(context, data) {
  var callName = data["callName"] || "";
  var variables = data["variables"] || {};

  const callMap = {
    RunPodSoVitsSvcCall: _runPodSoVitsSvcCall,
    CloudFunctionsStartLipSyncingCall: _cloudFunctionsStartLipSyncingCall,
    RunpodOpenVoiceCall: _runpodOpenVoiceCall,
  };

  if (!(callName in callMap)) {
    return {
      statusCode: 400,
      error: `API Call "${callName}" not defined as private API.`,
    };
  }

  var apiCall = callMap[callName];
  var response = await apiCall(context, variables);
  return response;
}

async function makeApiRequest({
  method,
  url,
  headers,
  params,
  body,
  returnBody,
  isStreamingApi,
}) {
  return axios
    .request({
      method: method,
      url: url,
      headers: headers,
      params: params,
      responseType: isStreamingApi ? "stream" : "json",
      ...(body && { data: body }),
    })
    .then((response) => {
      return {
        statusCode: response.status,
        headers: response.headers,
        ...(returnBody && { body: response.data }),
        isStreamingApi: isStreamingApi,
      };
    })
    .catch(function (error) {
      return {
        statusCode: error.response.status,
        headers: error.response.headers,
        ...(returnBody && { body: error.response.data }),
        error: error.message,
      };
    });
}

const _unauthenticatedResponse = {
  statusCode: 401,
  headers: {},
  error: "API call requires authentication",
};

function createBody({ headers, params, body, bodyType }) {
  switch (bodyType) {
    case "JSON":
      headers["Content-Type"] = "application/json";
      return body;
    case "TEXT":
      headers["Content-Type"] = "text/plain";
      return body;
    case "X_WWW_FORM_URL_ENCODED":
      headers["Content-Type"] = "application/x-www-form-urlencoded";
      return qs.stringify(params);
  }
}

module.exports = { makeApiCall };
