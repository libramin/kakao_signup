const functions = require("firebase-functions");
const admin = require("firebase-admin");

var serviceAccount = require("./kakaologin-firebase-adminsdk-iojdp-343fe8cb84.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
 exports.createCustomToken = functions.https.onRequest(async (request, response) => {
    const user = request.body;

    const uid = 'kakao:${user.uid}';
//    const uid = 'kakao'+user.uid;
    const updateParams = {
        email: user.email,
        photoURL: user.photoURL,
        displayName: user.displayName,
    };

    try{
        //기존계정이 있는 경우, 바뀐부분 업데이트
        await admin.auth().updateUser(uid,updateParams);
    }catch (e){
        updateParams["uid"] = uid;
        await admin.auth().createUser(updateParams);
    }

    const token = await admin.auth().createCustomToken(uid);

    response.send(token);
 });
