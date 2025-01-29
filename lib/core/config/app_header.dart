import 'dart:io';
import 'package:flutter/material.dart';

class AppHeaders {

  static String? applicationVersion;

  // Future<Map<String, String>> getHeaders(
  //     {String acceptType = 'application/json'}) async {
  //   String basicAuth = await Utils.authHeader();
  //   String acceptedLanguages = AppConfig.acceptedLanguage;
  //   String platform = Platform.operatingSystem;
  //   applicationVersion = await Utils.getAppVersion();
  //   String? accessToken = await sharedPrefsService.getToken();
  //   dynamic deviceId = await Utils().getDeviceId();
  //   debugPrint("deviceId:$deviceId");


  //   return {
  //     'authorization': basicAuth,
  //     'Accept-Language': acceptedLanguages,
  //     'Bearer': accessToken ?? '',
         
  //     'platform': platform,
  //     'uuid': deviceId ?? '1234',
  //     'version': applicationVersion!,
  //     'Accept': acceptType,
  //   };
  // }

}
