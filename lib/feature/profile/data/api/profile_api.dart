import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/profile_model.dart';

class ProfileApi {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<ProfileModel> getProfileData() async {
    final uId = await auth.currentUser!.uid;
    try {
      // Fetch the document by its ID (assuming the document ID is passed)
      DocumentSnapshot docSnapshot =
          await firestore.collection('chatModels').doc(uId).get();
      log("$docSnapshot");
      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        data = data['profile'];
        // Convert the Firestore document to a ProfileModel
        ProfileModel profileModel = ProfileModel.fromMap(data);

        return profileModel;
      } else {
        return ProfileModel(name: '', email: '', mobile: '');
      }
    } catch (e) {
      log("Exception :$e");
      throw Exception('Failed to fetch profile data');
    }
  }

  Future<ProfileModel> updateProfileData(Map<String, dynamic> body) async {
    final uId = auth.currentUser!.uid;
    try {
      await firestore.collection('chatModels').doc(uId).set({"profile": body});

      return await getProfileData();
    } catch (e) {
      throw Exception('Failed to store profile data');
    }
    // return ProfileModel();
  }
}
