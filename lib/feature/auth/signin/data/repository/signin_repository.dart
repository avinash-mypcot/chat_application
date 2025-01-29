
import '../model/signin_model.dart';
import '../services/signin_services.dart';

class SigninRepository {
  final SigninServices _service;
  const SigninRepository(this._service);

  Future<SigninModel> signinReq(Map<String, dynamic> body)async{
    try{
      final response = await  _service.signinReq(body);
      return response;
    }catch(e){
      rethrow;
    }
  }
}