
import '../api/signin_api.dart';
import '../model/signin_model.dart';

class SigninServices {
  final SigninApi _api;
  const SigninServices(this._api);


  Future<SigninModel> signinReq(Map<String, dynamic> body) async {
    try {
      final res = await _api.signinReq(body);
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
