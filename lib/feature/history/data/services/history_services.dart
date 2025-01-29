import 'package:dio/dio.dart';

import '../api/history_api.dart';
import '../model/history_model.dart';

class HistoryServices {
  final HistoryApi _api;
  const HistoryServices({required HistoryApi api,required Dio dio}):_api =api,super();
  Future<HistoryModel> getHistory(isVerified) async{
    try{
      var res = await _api.getHistory(isVerified);
      return res;
    }catch(e){
      rethrow;
    }
  }
}