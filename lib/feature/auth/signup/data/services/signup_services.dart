

import '../api/signup_api.dart';
import '../model/signup_model.dart';

class SignUpServices {
  final SignUpApi _api;
  const SignUpServices(this._api);
 

  Future<SignUpModel> signUpReq(Map<String, dynamic> body) async {
    try {
      final res = _api.signUpReq(body);
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
