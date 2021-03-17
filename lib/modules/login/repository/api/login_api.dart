import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:summarizeddebts/model/user_model.dart';
import 'package:summarizeddebts/repositories/api/base_api.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class LoginApi extends BaseApi {
  Future<String> signIn(String email, String password) async {
    AuthResult authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return authResult.user.uid;
  }

  Future<FirebaseUser> signInWithFacebook(FacebookAccessToken myToken) async {
    AuthCredential credential =
        FacebookAuthProvider.getCredential(accessToken: myToken.token);

    // this line do auth in firebase with your facebook credential.
    AuthResult authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return authResult.user;
  }

  Future<FirebaseUser> signInWithGoogle(
      GoogleSignInAuthentication googleSignInAuthentication) async {
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    // this line do auth in firebase with your facebook credential.
    AuthResult authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return authResult.user;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult authResult = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    if (authResult != null) {
      return authResult.user.uid;
    }

    return null;
  }

  Future<void> sendEmailVerification() async {
    var currentUser = await getCurrentFirebaseUser();

    await currentUser.sendEmailVerification();

    await signOut();
  }

  Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  void addUser(UserModel user) async {
    Firestore.instance.document("users/${user.userID}").setData(user.toJson());
  }

  Future<bool> checkEmailExist(String email) async {
    QuerySnapshot query =
        await Firestore.instance.collection("users").getDocuments();

    for (DocumentSnapshot document in query.documents) {
      if (document.data.containsKey("email") &&
          document.data.containsValue(email)) {
        return true;
      }
    }

    return false;
  }

  Future<bool> checkNickNameExist(String nickName) async {
    QuerySnapshot query =
        await Firestore.instance.collection("users").getDocuments();

    for (DocumentSnapshot document in query.documents) {
      if (document.data.containsKey("nickName") &&
          document.data.containsValue(nickName)) {
        return true;
      }
    }

    return false;
  }

  Future<bool> checkUserExist(String userID) async {
    bool exists = false;
    try {
      await Firestore.instance.document("users/$userID").get().then((doc) {
        exists = (doc.exists);
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel> getUser(String userID) async {
    return await Firestore.instance
        .collection("users")
        .where("userID", isEqualTo: userID)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      if (snapshot.documents != null && snapshot.documents.isNotEmpty)
        return snapshot.documents.map((doc) {
          return UserModel().fromJson(doc.data);
        }).first;
      return null;
    }).first;
  }
}
