
import 'package:dio/dio.dart';

import '../model/chat_model.dart';
import '../model/upload_image_model.dart';
import '../services/chat_services.dart';

class HomeRepository {
  final ChatServices _services;
  HomeRepository({required ChatServices service})
      : _services = service,
        super();

  Future<ChatModel> getInformation(String key ,Map<String,dynamic> massage) async {
    try {
      return _services.getInformation( key,massage);
    } catch (e) {
      rethrow;
    }
  }
  Future<UploadImageModel> uploadImageToGemini(String key,FormData data)async{
    try{
      final res = _services.uploadImageToGemini(key, data);
      return res;
    }catch(e){
        rethrow;
    }
  }
}
