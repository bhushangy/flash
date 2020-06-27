import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendToDevice = functions.firestore.document('messages/{messageId}').onCreate(async snapshot => {

  const sender = snapshot.data().sender;
  const msg = snapshot.data().text;

  const querysnapshot = await db.collection('UserInfo').get();
  if (querysnapshot.empty) {
   console.log('no devices!!');
  }
  const tokens = querysnapshot.docs.map(snap => snap.id);

  const payload: admin.messaging.MessagingPayload = {
    notification: {
      title: `New Message from ${sender}`,
      body: `${msg}`,
      clickAction: 'FLUTTER_NOTIFICATION_CLICK'
    },
  };
return fcm.sendToDevice(tokens,payload);
});