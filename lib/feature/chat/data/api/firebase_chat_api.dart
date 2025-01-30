import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../model/chat_model.dart';
import '../services/encription_helper.dart';

class FirebaseChatApi {
  Stream<ChatModel> getTodayChat(bool isVerified) {
  final encryptionHelper =
      EncryptionHelper('6gHdJ1kLmNoP8b2x', '3xTu9R4dWq8YtZkC');
  final FirebaseAuth auth = FirebaseAuth.instance;
  final uId = auth.currentUser?.uid;
  if (uId == null) {
    // Handle case where UID is null (user might not be authenticated)
    return Stream.value(ChatModel(
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      candidates: [Candidates(content: Content(parts: []))],
    ));
  }

  final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  return FirebaseFirestore.instance
      .collection('chatModels')
      .doc(uId)
      .collection('chats')
      .doc(todayDate)
      .snapshots()
      .map((snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          // No data found, return a default ChatModel
          return ChatModel(
            date: todayDate,
            candidates: [Candidates(content: Content(parts: []))],
          );
        }

        final data = snapshot.data();
        final chats = data?['chats'];

        if (chats == null) {
          // No chats field found, return a default ChatModel
          return ChatModel(
            date: todayDate,
            candidates: [Candidates(content: Content(parts: []))],
          );
        }

        // Safe extraction of candidate data
        final candidatesData = chats is List<dynamic> 
            ? chats[0]['candidates'] 
            : chats['0']?['candidates'];

        if (candidatesData == null || candidatesData.isEmpty) {
          // If no candidates data is found, return a default ChatModel
          return ChatModel(
            date: todayDate,
            candidates: [Candidates(content: Content(parts: []))],
          );
        }

        final contentJson = candidatesData[0]['content'] as Map<String, dynamic>?;
        if (contentJson == null) {
          // If no content is found, return a default ChatModel
          return ChatModel(
            date: todayDate,
            candidates: [Candidates(content: Content(parts: []))],
          );
        }

        final content = Content.fromJson(contentJson);

        final timestamp = data?['date'] as Timestamp?;
        final formattedDate = timestamp != null
            ? DateFormat('yyyy-MM-dd').format(timestamp.toDate())
            : "Unknown Date";

        final model = ChatModel(
          date: todayDate,
          candidates: [
            Candidates(content: content, date: formattedDate),
          ],
        );

        // If the chat is verified, decrypt the parts
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
              ])
            )
          ]);
        }
        // Return the model as is if not verified
        return model;
      });
}


  Future<void> appendPartsToFirestore(ChatModel chatModel, String documentId,int index,{bool isNewChat = false}) async {
    try {
      // Initialize Firestore instance
      final firestore = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;
      final uId = auth.currentUser!.uid;
      // Get today's date in 'yyyy-MM-dd' format for document ID
      // String documentId = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Extract the parts to be appended
      List<dynamic> newParts = chatModel.candidates!
          .expand((candidate) => candidate.content?.parts ?? [])
          .map((part) => part.toJson())
          .toList();

      // Reference the document
      final docRef = firestore
          .collection('chatModels')
          .doc(uId)
          .collection('chats')
          .doc(documentId);
      // final docRef = firestore.collection('chatModels').doc('2024-12-26');

      // Check if the document exists
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Append new parts to the existing parts in Firestore
        if (isNewChat) {
          final leng = docSnapshot.data()!['chats'].length;
          if (docSnapshot.data()!['chats'].runtimeType == List<dynamic>) {
            List<dynamic> oldData = docSnapshot.data()!['chats'];
            log("OLDDSTA ${oldData.runtimeType}");
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
            Map<String, dynamic> oldData = docSnapshot.data()!['chats'];
            log("OLDDSTA ${oldData.runtimeType}");
            oldData.addAll({
              'candidates': [
                {
                  'content': {'parts': newParts},
                }
              ]
            });
            await docRef.update({
              'chats.$leng': oldData,
            });
          }
        } else {
          final leng = docSnapshot.data()!['chats'].length;
          await docRef.update({
            'chats.$index.candidates.0.content.parts':
                FieldValue.arrayUnion(newParts),
          });
        }
      } else {
        // If document does not exist, create it
        await docRef.set({
          'chats': [chatModel.toJson()],
          'date': DateTime.now(),
        });
      }

      print("Parts successfully appended to Firestore!");
    } catch (e) {
      print("Error appending parts to Firestore: $e");
    }
  }
}
