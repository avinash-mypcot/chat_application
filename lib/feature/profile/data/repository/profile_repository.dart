import '../model/profile_model.dart';
import '../services/profile_services.dart';

class ProfileRepository {
  final ProfileServices _service;
  const ProfileRepository(ProfileServices service):_service = service;
  
  Future<ProfileModel> getProfileData(){
    try{
      final response =_service.getProfileData();
      return response;
    }catch(e){
      rethrow;
    }
  }

  Future<ProfileModel> updateProfileData(Map<String ,dynamic> body) {
    try {
      final response = _service.updateProfileData(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
