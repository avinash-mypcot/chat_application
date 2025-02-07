import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/chat_model.dart';
import '../services/encription_helper.dart';

class FirebaseChatApi {
  final encryptionHelper =
      EncryptionHelper('6gHdJ1kLmNoP8b2x', '3xTu9R4dWq8YtZkC');
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<ChatModel> getTodayChat(bool isVerified) {
    final uId = auth.currentUser?.uid;
    if (uId == null) {
      return Stream.value(ChatModel(
        date: "No Data",
        candidates: [Candidates(content: Content(parts: []))],
      ));
    }

    return FirebaseFirestore.instance
        .collection('chatModels')
        .doc(uId)
        .collection('chats')
        .orderBy('timestamp', descending: true) // Get the latest chat
        .limit(1) // Only fetch the most recent chat
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return ChatModel(
          date: "No Data",
          candidates: [Candidates(content: Content(parts: []))],
        );
      }

      final data = snapshot.docs.first.data();
      final chats = data['chats'];

      if (chats == null || chats.isEmpty) {
        return ChatModel(
          date: "No Data",
          candidates: [Candidates(content: Content(parts: []))],
        );
      }

      final candidatesData = chats[0]['candidates'];
      if (candidatesData == null || candidatesData.isEmpty) {
        return ChatModel(
          date: "No Data",
          candidates: [Candidates(content: Content(parts: []))],
        );
      }

      final contentJson = candidatesData[0]['content'] as Map<String, dynamic>?;
      final content = contentJson != null ? Content.fromJson(contentJson) : Content(parts: []);

      final model = ChatModel(
        date: "Latest Chat",
        candidates: [
          Candidates(content: content),
        ],
      );

      if (isVerified) {
        return model.copyWith(candidates: [
          model.candidates![0].copyWith(
            content: model.candidates![0].content!.copyWith(parts: [
              for (var part in model.candidates![0].content!.parts!)
                Parts(
                  time: part.time,
                  base64Image: part.base64Image,
                  isUser: part.isUser,
                  text: encryptionHelper.decryptText(part.text!),
                )
            ]),
          )
        ]);
      }
      return model;
    });
  }

  
  Future<void> appendPartsToFirestore(ChatModel chatModel, String chatId, int index, {bool isNewChat = false}) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;
      final uId = auth.currentUser!.uid;

      List<dynamic> newParts = chatModel.candidates!
          .expand((candidate) => candidate.content?.parts ?? [])
          .map((part) => part.toJson())
          .toList();

      final docRef = firestore
          .collection('chatModels')
          .doc(uId)
          .collection('chats')
          .doc(chatId);

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        if (isNewChat) {
          List<dynamic> oldData = docSnapshot.data()!['chats'];
          oldData.add({
            'candidates': [
              {
                'content': {'parts': newParts},
              }
            ]
          });
          await docRef.update({
            'chats': oldData,
          });
        } else {
          await docRef.update({
            'chats.$index.candidates.0.content.parts': FieldValue.arrayUnion(newParts),
          });
        }
      } else {
        await docRef.set({
          'chats': [chatModel.toJson()],
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      log("Parts successfully appended to Firestore!");
    } catch (e) {
      log("Error appending parts to Firestore: $e");
    }
  }
}
