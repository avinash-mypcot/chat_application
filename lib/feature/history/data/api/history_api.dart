import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../../chat/data/model/chat_model.dart';
import '../../../chat/data/services/encription_helper.dart';
import '../model/history_model.dart';

class HistoryApi {
  const HistoryApi();
  // Future<List<ChatModel>> getHistory() async {
  //   final uId = FirebaseAuth.instance.currentUser!.uid;
  //   try {
  //     // Fetch data from Firestore under the given uId
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection('chatModels') // Root Firestore collection
  //         .doc(uId) // Document for the specific user
  //         .collection('chats') // Sub-collection for chats
  //         .orderBy('date', descending: true) // Sort by date
  //         .get();

  //     // Map Firestore data to ChatModel
  //     final fetchedChats = snapshot.docs.map((doc) {
  //       var data = doc.data();
  //       log('DATA : $data');
  //       var content;
  //       if (data['chats'].runtimeType != List<dynamic>) {
  //         // Parse the content field from Firestore data
  //         dynamic content1 = data['chats']['0']['candidates']['0']['content'];
  //         content = Content.fromJson(content1);
  //       } else {
  //         // Parse the content field from Firestore data
  //         dynamic content1 = data['chats'][0]['candidates'][0]['content'];
  //         content = Content.fromJson(content1);
  //       }

  //       // Extract parts and date information
  //       List<Parts> parts = content.parts ?? [];
  //       final dateTime = (data['date'] as Timestamp).toDate();
  //       final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

  //       return ChatModel(
  //         date: formattedDate,
  //         candidates: [
  //           Candidates(content: Content(parts: parts), date: formattedDate)
  //         ],
  //       );
  //     }).toList();

  //     return fetchedChats;
  //   } catch (e) {
  //     print("Error fetching chat history for uId $uId: $e");
  //     rethrow;
  //   }
  // }

  Future<HistoryModel> getHistory(bool isVerified) async {
    final uId = FirebaseAuth.instance.currentUser!.uid;
    final encryptionHelper =
        EncryptionHelper('6gHdJ1kLmNoP8b2x', '3xTu9R4dWq8YtZkC');

    try {
      // Fetch data from Firestore under the given uId
      final snapshot = await FirebaseFirestore.instance
          .collection('chatModels') // Root Firestore collection
          .doc(uId) // Document for the specific user
          .collection('chats') // Sub-collection for chats
          .orderBy('date', descending: true) // Sort by date
          .get();

      // Map Firestore data to HistoryModel
      final List<Data> fetchedData = snapshot.docs.map((doc) {
        var data = doc.data();
        // log('DATA : $data');

        // Initialize chats as an empty list
        List<ChatModel> chats = [];

        if (data['chats'] is List<dynamic>) {
          // Handle case when data['chats'] is a list
          chats = (data['chats'] as List<dynamic>).map((chat) {
            final contentJson;
            if (chat['candidates'].runtimeType == List<dynamic>) {
              contentJson = chat['candidates'][0]['content'];
            } else {
              contentJson = chat['candidates']['0']['content'];
            }
            final content = Content.fromJson(contentJson);

            // Extract parts
            final List<Parts> parts = content.parts ?? [];

            final dateTime = (data['date'] as Timestamp).toDate();
            final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

            final model = ChatModel(
              date: formattedDate,
              candidates: [
                Candidates(content: Content(parts: parts), date: formattedDate),
              ],
            );
            if(!isVerified){
                return model;
            }
            ChatModel dencryptedModel = model.copyWith(candidates: [
              model.candidates![0].copyWith(
                  content: model.candidates![0].content!.copyWith(parts: [
                for (var part in model.candidates![0].content!.parts!)
                  Parts(
                    base64Image: part.base64Image,
                    isUser: part.isUser,
                    text: encryptionHelper.decryptText(part.text!),
                  )
              ]))
            ]);

            return dencryptedModel;
          }).toList();
        } else if (data['chats'] is Map<String, dynamic>) {
          // Handle case when data['chats'] is a map
          final mapChats = data['chats'] as Map<String, dynamic>;
          for (int i = 0; i < mapChats.length; i++) {}
          chats = mapChats.entries.map((entry) {
            final chat = entry.value;
            final contentJson;
            if (chat['candidates'].runtimeType == List<dynamic>) {
              contentJson = chat['candidates'][0]['content'];
            } else {
              contentJson = chat['candidates']['0']['content'];
            }

            // log("DATA 1: ${contentJson['parts']}");
            final content = Content.fromJson(contentJson);

            // Extract parts
            final List<Parts> parts = content.parts ?? [];
            final dateTime = (data['date'] as Timestamp).toDate();
            final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

            final model = ChatModel(
              date: formattedDate,
              candidates: [
                Candidates(content: Content(parts: parts), date: formattedDate),
              ],
            );
            log("DATA : ${model.date}");
            ChatModel dencryptedModel = model.copyWith(candidates: [
              model.candidates![0].copyWith(
                  content: model.candidates![0].content!.copyWith(parts: [
                for (var part in model.candidates![0].content!.parts!)
                  Parts(
                    time: part.time,
                    base64Image: part.base64Image,
                    isUser: part.isUser,
                    text: encryptionHelper.decryptText(part.text!),
                  )
              ]))
            ]);

            return dencryptedModel;
          }).toList();
        }

        // Create Date object
        final Date dateObject = Date(chats: chats);

        // Create Data object
        return Data(date: dateObject);
      }).toList();

      // Return the mapped HistoryModel
      return HistoryModel(data: fetchedData);
    } catch (e) {
      print("Error fetching chat history for uId $uId: $e");
      rethrow;
    }
  }
}
