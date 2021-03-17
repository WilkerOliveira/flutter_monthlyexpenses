import 'package:firebase_auth/firebase_auth.dart';
import 'package:summarizeddebts/repositories/api/base_api.dart';

class ConfigApi extends BaseApi{

  static Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }

}