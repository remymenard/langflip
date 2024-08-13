const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { setGlobalOptions } = require("firebase-functions/v2");
const axios = require('axios');

setGlobalOptions({ region: "europe-west4", maxInstances: 5 });

const headers = {
  Authorization: process.env.RUNPOD_API_KEY
};

exports.startAudioExtract = onDocumentCreated("videos/{videoId}", (event) => {

  const snapshot = event.data;
  if (!snapshot) {
    console.log("No data associated with the event");
    return;
  }

  const originalVideoUrl = snapshot.data().originalVideoUrl.trim();
  const recordId = snapshot.id;
  console.log(`Video document: ${originalVideoUrl}`);

  if (originalVideoUrl) {
    try {
      axios.post(process.env.RUNPOD_ENDPOINT_URL, {
        input: {
          file_url: originalVideoUrl,
          record_id: recordId
        }
      }, { headers });

      // Additional logic to handle the response
      console.log("Request sent");
    } catch (error) {
      console.error('Error sending request:', error);
    }
  } else {
    console.log('No originalVideoUrl found in the document');
  }
});
