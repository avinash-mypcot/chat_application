import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import '../theme/app_colors.dart';

class AppUtils{

  static InterceptorsWrapper getLoggingInterceptor() {
    int count = 0;
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        count++;

        debugPrint(
            '${AppColors.cyan}Request[${options.method}] => PATH: ${options.path}$reset');
        debugPrint(
            '${AppColors.white}Request HEADERS: ${options.headers}$reset');
        debugPrint('${AppColors.yellow}Request DATA: ${options.data}$reset');
        debugPrint('${AppColors.magenta}API call count: $count');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint(
            '${AppColors.green}Response[${response.statusCode}] => DATA: ${response.data}$reset');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        debugPrint("test error:}");
        debugPrint(
            '${AppColors.red}Error[${e.response?.statusCode}] => MESSAGE: ${e.message}$reset');
        debugPrint('${AppColors.red}Error DATA: ${e.response?.data}$reset');
        return handler.next(e);
      },
    );
  }
  static Future<String> convertImageToBase64(String imagePath) async {
    // Read the image file
    File imageFile = File(imagePath);

    // Convert to bytes
    List<int> imageBytes = await imageFile.readAsBytes();

    // Encode to Base64
    String base64String = base64Encode(imageBytes);

    return base64String;
  }
  static Widget decodeBase64ToImage(String base64String) {
    // Decode the Base64 string to bytes
    Uint8List decodedBytes = base64Decode(base64String);

    // Return as an Image widget
    return Image.memory(decodedBytes);
  }
  // pick image from gallary

  static Future<File?> pickImage(bool fromGallery) async {
    final image = await ImagePicker().pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera,
        requestFullMetadata: false);

    return image != null ? File(image.path) : null;
  }

}