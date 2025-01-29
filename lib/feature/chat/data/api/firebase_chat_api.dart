import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../code_verification/bloc/code_verification_bloc.dart';
import '../model/chat_model.dart';
import '../services/encription_helper.dart';

class FirebaseChatApi {
  Future<ChatModel> getTodayChat(bool isVerified) async {
    final encryptionHelper =
        EncryptionHelper('6gHdJ1kLmNoP8b2x', '3xTu9R4dWq8YtZkC');
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final uId = auth.currentUser?.uid;

      final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final snapshot = await FirebaseFirestore.instance
          .collection('chatModels')
          .doc(uId)
          .collection('chats')
          .doc(todayDate)
          .get();

      final data = snapshot.data();
      if (data == null) {
        // emit(ChatLoaded(
        //     data: ChatModel(
        //         date: todayDate,
        //         candidates: [Candidates(content: Content(parts: []))])));
        return ChatModel(
            date: todayDate,
            candidates: [Candidates(content: Content(parts: []))]);
      }
      final candidates;
      final contentJson;
      // Safely navigate the structure and deserialize the data
      final chats = data['chats'];
      if (chats!.runtimeType == List<dynamic>) {
        candidates = chats[0]['candidates'];

        contentJson = candidates[0]['content'] as Map<String, dynamic>?;
      } else {
        candidates = chats['0']['candidates'];

        contentJson = candidates['0']['content'] as Map<String, dynamic>?;
      }

      final content = Content.fromJson(contentJson!);

      // Parse parts and date
      List<Parts> parts = content.parts!;

      final timestamp = data['date'] as Timestamp?;
      final formattedDate = timestamp != null
          ? DateFormat('yyyy-MM-dd').format(timestamp.toDate())
          : "Unknown Date";

      final model = ChatModel(
        date: todayDate,
        candidates: [
          Candidates(content: content, date: formattedDate),
        ],
      );
      if(!isVerified){return model;}
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
      // emit(ChatLoaded(data: model));
    } catch (e) {
      rethrow;
      // emit(ChatError(message: "Failed to load chat data"));
    }
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
