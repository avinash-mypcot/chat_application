import '../api/profile_api.dart';
import '../model/profile_model.dart';

class ProfileServices {
  final ProfileApi _api;
  const ProfileServices(ProfileApi api):_api = api;
   Future<ProfileModel> getProfileData(){
    try{
      final response =  _api.getProfileData();
      return response;
    }catch(e){
      rethrow;
    }
   }

   Future<ProfileModel> updateProfileData(Map<String,dynamic> body) {
    try {
      final response = _api.updateProfileData(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}