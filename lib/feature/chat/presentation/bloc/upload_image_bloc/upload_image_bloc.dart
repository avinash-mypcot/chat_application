import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/upload_image_model.dart';
import '../../../data/repository/chat_repository.dart';

part 'upload_image_event.dart';
part 'upload_image_state.dart';

class UploadImageBloc extends Bloc<UploadImageEvent, UploadImageState> {
  HomeRepository repository;
  MultipartFile? file;
  UploadImageBloc({required this.repository}) : super(UploadImageInitial()) {
    on<UploadImageToGemini>(_onUploadImage);
  }
  _onUploadImage(
      UploadImageToGemini event, Emitter<UploadImageState> emit) async {
    String checkImageFormat(String filePath) {
      // Extract the file extension
      String extension = filePath.split('.').last.toLowerCase();

      // Check the format
      if (extension == "png") {
        return "png";
      } else if (extension == "jpg" || extension == "jpeg") {
        return "jpeg";
      } else {
        return "";
      }
    }

    if (event.image != null && event.image!.isNotEmpty) {
      final image = File(event.image!);
      final type = checkImageFormat(image.path);
      if (await image.exists()) {
        log("IMAGE PATH : ${image.path}");
        file = await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last,
            contentType: DioMediaType.parse("image/$type"));
      } else {
        print("File does not exist at path: ${image.path}");
      }
    }
    log("IMAGE PATH : ${file!.filename}");
    Map<String, dynamic> data = {};
    if (file != null) {
      data['image'] = file;
    }

    FormData formData = FormData.fromMap(data);
    try {
      final data = await repository.uploadImageToGemini(
          "AIzaSyDaKc-H4hWesxWJt6ARDVz7rYcBn0ILUQw", formData);

      emit(UploadImageSuccess(model: data));
      log(data.file1!.uri!);
      log(data.file1!.mimeType!);
    } catch (e) {
      log("ERROR :$e");
      emit(UploadImageExceptionState(
          error: 'image upload failed: ${e.toString()}'));
    }
  }
}
