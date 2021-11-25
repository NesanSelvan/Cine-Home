import 'package:basics/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Userfirestore {
  static final firestore = FirebaseFirestore.instance;

  Future<void> createUserData(String id, String name, String email,
      List favourites, String photo) async {
    await FirebaseFirestore.instance.collection("users").doc(id).set({
      "name": name,
      "email": email,
      "favourites": favourites,
      "userPhoto": photo
    });
    print(favourites);
  }

  static User? getCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    return user;
  }

  static Future<List<String>> getMyFavourites() async {
    final user = getCurrentUser();
    if (user != null) {
      debugPrint("User : ${user.uid}");
      final doc = await firestore.collection("users").doc(user.uid).get();
      try {
        return UserModel.fromJson(doc.data() ?? {}).favourites;
      } catch (e) {
        return ["Action"];
      }
    } else {
      return ["Action"];
    }
  }
}
