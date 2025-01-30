import 'dart:developer';

import '../../../chat/data/model/chat_model.dart';
import '../services/firebase_service.dart';

class FirebaseRepository {
  final FirebaseServices _services;
  const FirebaseRepository({required FirebaseServices service})
      : _services = service,
        super();

  Stream<ChatModel> getTodayChatStream(context)  {
    try {
      final response =  _services.getTodayChat(context);
      log("type${response.runtimeType}");
      return response;
    } catch (e) {
      rethrow;
    }
  }

   Future<void> appendPartsToFirestore(ChatModel updatedModel,String date,bool isNewChat,int index) async {
    try {
      final response = await _services.appendPartsToFirestore(updatedModel, date,isNewChat,index);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
