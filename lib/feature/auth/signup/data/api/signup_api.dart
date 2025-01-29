
import 'package:ai_chatbot/feature/auth/signup/data/model/signup_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
