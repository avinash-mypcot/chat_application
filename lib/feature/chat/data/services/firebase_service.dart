
import '../api/firebase_chat_api.dart';
import '../model/chat_model.dart';

class FirebaseServices {
  final FirebaseChatApi _api;
  const FirebaseServices({required FirebaseChatApi api})
      : _api = api,
        super();
  Future<ChatModel> getTodayChat(context) async {
    try {
      var res = await _api.getTodayChat(context);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> appendPartsToFirestore(
      ChatModel updatedModel, String date, bool isNewChat,int index) async {
    try {
      var res = await _api.appendPartsToFirestore(updatedModel, date,index,isNewChat:isNewChat);
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
