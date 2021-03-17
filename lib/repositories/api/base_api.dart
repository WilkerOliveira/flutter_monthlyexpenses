
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseApi {

  final Firestore firestoreReference = Firestore.instance;

  Future<FirebaseUser> getCurrentFirebaseUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  Future<String> getCurrentFirebaseUserId() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

}