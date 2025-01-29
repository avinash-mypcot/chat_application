import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/utils/utils.dart';
import '../api/chat_api.dart';
import '../model/chat_model.dart';
import '../model/upload_image_model.dart';

class ChatServices {
  final ChatApi _api;
  final Dio _dio;
  ChatServices({required ChatApi api, required Dio dio})
      : _api = api,
        _dio = dio,
        super();
  Future<ChatModel> getInformation(
      String key, Map<String, dynamic> body) async {
    try {
      _dio.interceptors.add(AppUtils.getLoggingInterceptor());
      return _api.getInformation(
          key: 'AIzaSyDaKc-H4hWesxWJt6ARDVz7rYcBn0ILUQw', body: body);
    } catch (e) {
      rethrow;
    }
  }

  Future<UploadImageModel> uploadImageToGemini(
      String key, FormData data) async {
    try {
      _dio.interceptors.add(AppUtils.getLoggingInterceptor());
      final res = await _api.uploadImage(
          key: 'AIzaSyDaKc-H4hWesxWJt6ARDVz7rYcBn0ILUQw', data: data);
      return res;
    } catch (e) {
      log("ERROR $e");
      rethrow;
    }
  }
}
