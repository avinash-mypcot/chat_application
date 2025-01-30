
import 'package:firebase_auth/firebase_auth.dart';

import '../model/signup_model.dart';

class SignUpApi {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<SignUpModel> signUpReq(Map<String, dynamic> body) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
          email: body["email"], password: body["password"]);
      return SignUpModel(message: "User created");
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
