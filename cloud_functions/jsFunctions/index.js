const functions = require("firebase-functions");
const admin = require("firebase-admin");
const ffmpeg = require("fluent-ffmpeg");
const path = require("path");
const https = require("https");


const ffmpegBinary = path.join(__dirname, "ffmpeg");
const ffprobeBinary = path.join(__dirname, "ffprobe");

ffmpeg.setFfmpegPath(ffmpegBinary);
ffmpeg.setFfprobePath(ffprobeBinary);


admin.initializeApp();

exports.calculateAudioDuration = functions.region("europe-west1").firestore
  .document("voices/{voiceId}/voiceAudios/{voiceAudioId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();
    if (!data || typeof data.url !== "string") {
      console.error("Invalid data:", data);
      return null; // Exit the function
    }
    const audioUrl = data.url;

    return new Promise((resolve, reject) => {
      https.get(audioUrl, (stream) => {
        ffmpeg.ffprobe(stream, async (err, metadata) => {
          if (err) {
            console.error("FFprobe error:", err);
            reject(err);
            return;
          }

          const fileSize = parseInt(stream.headers["content-length"], 10);
          const bitRate = metadata.format.bit_rate;

          const fileSizeInBits = fileSize * 8;
          const duration = parseInt(fileSizeInBits / bitRate, 10);
          console.log(`duration found in seconds: ${duration}`);

          if (duration) {
            try {
              await snap.ref.update({ duration: duration });

              // Retrieve the parent voice document
              const voiceRef = admin.firestore().doc(`voices/${context.params.voiceId}`);
              // Increment the total_training_time
              await voiceRef.update({
                totalTrainingTime: admin.firestore.FieldValue.increment(duration)
              });

              resolve();
            } catch (updateErr) {
              console.error("Error updating Firestore:", updateErr);
              reject(updateErr);
            }
          } else {
            console.error("Duration not found");
            reject(new Error("Duration not found"));
          }
        });
      });
    });
  });


exports.decrementAudioDurationAndDeleteFile = functions.region("europe-west1").firestore
  .document("voices/{voiceId}/voiceAudios/{voiceAudioId}")
  .onDelete(async (snap, context) => {
    const data = snap.data();
    if (!data) {
      console.error("Invalid data:", data);
      return null; // Exit the function if data is invalid
    }

    // Handle the duration decrement
    if (typeof data.duration === "number") {
      try {
        const voiceRef = admin.firestore().doc(`voices/${context.params.voiceId}`);
        await voiceRef.update({
          totalTrainingTime: admin.firestore.FieldValue.increment(-data.duration)
        });
      } catch (error) {
        console.error("Error updating Firestore:", error);
        throw new Error("Firestore update failed");
      }
    }

    // Delete the file from Cloud Storage
    if (typeof data.url === "string") {
      const fileUrl = data.url;
      const bucketName = 'langflip-e8589.appspot.com';
      const bucket = admin.storage().bucket(bucketName);

      try {
        // Extract the file path from the URL
        const decodedUrl = decodeURIComponent(fileUrl);
        const pathRegex = /\/o\/(.+?)\?/;
        const match = pathRegex.exec(decodedUrl);
        if (!match || match.length < 2) {
          throw new Error("Unable to extract file path from URL");
        }
        const filePath = match[1].replace(/%2F/g, '/');

        const file = bucket.file(filePath);
        await file.delete();
        console.log(`File ${filePath} deleted successfully.`);
      } catch (error) {
        console.error("Error deleting file from Cloud Storage:", error);
        throw new Error("Cloud Storage deletion failed");
      }
    }
  });