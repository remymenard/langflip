const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const apiManager = require("./api_manager");
const { onRequest } = require("firebase-functions/v2/https");
const { setGlobalOptions } = require("firebase-functions/v2");
const { pipeline } = require("node:stream/promises");

setGlobalOptions({ region: "europe-west1" });

exports.ffPrivateApiCall = functions
  .region("europe-west1")
  .runWith({ minInstances: 1, timeoutSeconds: 120 })
  .https.onCall(async (data, context) => {
    try {
      console.log(`Making API call for ${data["callName"]}`);
      var response = await apiManager.makeApiCall(context, data);
      console.log(`Done making API Call! Status: ${response.statusCode}`);
      return response;
    } catch (err) {
      console.error(`Error performing API call: ${err}`);
      return {
        statusCode: 400,
        error: `${err}`,
      };
    }
  });

async function verifyAuthHeader(request) {
  const authorization = request.header("authorization");
  if (!authorization) {
    return null;
  }
  const idToken = authorization.includes("Bearer ")
    ? authorization.split("Bearer ")[1]
    : null;
  if (!idToken) {
    return null;
  }
  try {
    const authResult = await admin.auth().verifyIdToken(idToken);
    return authResult;
  } catch (err) {
    return null;
  }
}

exports.ffPrivateApiCallV2 = onRequest(
  { cors: true, minInstances: 1, timeoutSeconds: 120 },
  async (req, res) => {
    try {
      const context = {
        auth: await verifyAuthHeader(req),
      };
      const data = req.body.data;
      console.log(`Making API call for ${data["callName"]}`);
      var endpointResponse = await apiManager.makeApiCall(context, data);
      console.log(
        `Done making API Call! Status: ${endpointResponse.statusCode}`,
      );
      res.set(endpointResponse.headers);
      res.status(endpointResponse.statusCode);
      await pipeline(endpointResponse.body, res);
    } catch (err) {
      console.error(`Error performing API call: ${err}`);
      res.status(400).send(`${err}`);
    }
  },
);
exports.onUserDeleted = functions
  .region("europe-west1")
  .auth.user()
  .onDelete(async (user) => {
    let firestore = admin.firestore();
    let userRef = firestore.doc("users/" + user.uid);
    await firestore
      .collection("voices")
      .where("user_id", "==", userRef)
      .get()
      .then(async (querySnapshot) => {
        for (var doc of querySnapshot.docs) {
          await doc.ref
            .collection("voiceAudios")
            .get()
            .then(async (q) => {
              for (var d of q.docs) {
                console.log(
                  `Deleting document ${d.id} from collection voiceAudios`,
                );
                await d.ref.delete();
              }
            });
        }
      });
    await firestore
      .collection("voices")
      .where("user_id", "==", userRef)
      .get()
      .then(async (querySnapshot) => {
        for (var doc of querySnapshot.docs) {
          await doc.ref
            .collection("generations")
            .get()
            .then(async (q) => {
              for (var d of q.docs) {
                console.log(
                  `Deleting document ${d.id} from collection generations`,
                );
                await d.ref.delete();
              }
            });
        }
      });
    await firestore.collection("users").doc(user.uid).delete();
    await firestore
      .collection("voices")
      .where("user_id", "==", userRef)
      .get()
      .then(async (querySnapshot) => {
        for (var doc of querySnapshot.docs) {
          console.log(`Deleting document ${doc.id} from collection voices`);
          await doc.ref.delete();
        }
      });
    await firestore
      .collection("videos")
      .where("user_id", "==", userRef)
      .get()
      .then(async (querySnapshot) => {
        for (var doc of querySnapshot.docs) {
          console.log(`Deleting document ${doc.id} from collection videos`);
          await doc.ref.delete();
        }
      });
    await firestore
      .collection("courses")
      .where("user_id", "==", userRef)
      .get()
      .then(async (querySnapshot) => {
        for (var doc of querySnapshot.docs) {
          console.log(`Deleting document ${doc.id} from collection courses`);
          await doc.ref.delete();
        }
      });
  });
