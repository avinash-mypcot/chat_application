
import 'package:dio/dio.dart';

import 'package:retrofit/retrofit.dart';

import '../../../../core/config/app_config.dart';
import '../model/chat_model.dart';
import '../model/upload_image_model.dart';
part 'chat_api.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class ChatApi {
  factory ChatApi(Dio dio, {String? baseUrl}) = _ChatApi;

  @POST(AppConfig.chatApi)
  Future<ChatModel> getInformation({@Query('key') required  String key,@Body() required Map<String, dynamic> body});

  @POST(AppConfig.uploadImageApi)
  Future<UploadImageModel> uploadImage({@Query('key') required String key,@Body() required FormData data});

}

