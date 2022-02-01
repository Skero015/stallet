const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const firebase = require('firebase');
const functions = require("firebase-functions");
const admin = require('firebase-admin');
const cors = require('cors')({origin: true});

var config = {
    apiKey: "AIzaSyA4siybsWr28dT0fyhbC-4KCBz061GqmEs",
    authDomain: "noreply@stallet-fb242.firebaseapp.com",
    databaseURL: "https://<DATABASE_NAME>.firebaseio.com",
    projectId: 'stallet-fb242',
    appId: '1:409237204265:android:1ef4893927ec0d16a9db38',
    storageBucket: "gs://stallet-fb242.appspot.com",
    messagingSenderId: "409237204265",
};

firebase.initializeApp(config);
admin.initializeApp(config);

const db = admin.firestore();
const fcm = admin.messaging();

//firebase messaging
exports.sendToTopic = functions.firestore.document('Wallet/{uid}')
.onUpdate( async (change, context) => {

    const updatedWallet = change.after.data();

    const tokensSnapshot = await db.collection('Wallet')
        .doc(updatedWallet.uid)
        .collection('Tokens')
        .get();

    const tokens = tokensSnapshot.docs.map(snap => snap.id);
    console.log('got token from: ' + updatedWallet.uid);
    console.log('token: ' + tokens);

    const payload = admin.messaging.MessagingPayload = {
        notification: {
            title: updatedWallet.title,
            body: "Details about " + updatedWallet.title + " event have been updated. Click to view updated information about the event.",
            image: updatedWallet.image,
            sound: 'default',
            logo: updatedWallet.image,
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
        },
    };

    return fcm.sendToTopic('Wallet', payload);
});