import 'package:ai_chatbot/feature/auth/signup/data/services/signup_services.dart';

import '../model/signup_model.dart';

class SignUpRepository {
  final SignUpServices _service;
  const SignUpRepository(this._service);

  Future<SignUpModel> signUpReq(Map<String, dynamic> body) async {
    try {
      final response = await _service.signUpReq(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
