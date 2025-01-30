
import '../model/signup_model.dart';
import '../services/signup_services.dart';

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
