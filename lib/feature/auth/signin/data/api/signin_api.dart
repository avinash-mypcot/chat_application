import 'package:firebase_auth/firebase_auth.dart';

import '../model/signin_model.dart';

class SigninApi {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<SigninModel> signinReq(Map<String, dynamic> body) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: body["email"], password: body["password"]);
      return SigninModel(message: "User Login");
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
