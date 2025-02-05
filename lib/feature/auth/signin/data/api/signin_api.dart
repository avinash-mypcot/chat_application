import 'package:firebase_auth/firebase_auth.dart';
import '../model/signin_model.dart';

class SigninApi {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<SigninModel> signinReq(Map<String, dynamic> body) async {
    try {
      // Check if a user is already signed in
      User? currentUser = auth.currentUser;
      if (currentUser != null && currentUser.email == body["email"]) {
        return SigninModel(message: "User already signed in");
      }

      // If not signed in, proceed with sign-in
      final credential = await auth.signInWithEmailAndPassword(
        email: body["email"],
        password: body["password"],
      );

      return SigninModel(message: "User Login Successful");
    } on FirebaseAuthException catch (e) {
      return SigninModel(message: "Error: ${e.message}");
    }
  }
}
