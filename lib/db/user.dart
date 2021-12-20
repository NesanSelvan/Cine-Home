import 'dart:math';

import 'package:basics/models/user.dart';
import 'package:basics/services/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Userfirestore {
  static final firebaseAuth = FirebaseAuth.instance;
  static final firestore = FirebaseFirestore.instance;
  static final usersCollection = FirebaseFirestore.instance.collection("users");

  Future<void> createUserData(String id, String name, String email,
      List favourites, String photo) async {
    await FirebaseFirestore.instance.collection("users").doc(id).set({
      "name": name,
      "email": email,
      "favourites": favourites,
      "userPhoto": photo
    });
    print(favourites);
    addIfCustomUserIdNotExists();
  }

  static User? getCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    return user;
  }

  static Future<String?> getCurrentCustomUserID() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    final data = (await usersCollection.doc(user.uid).get()).data();

    return data!['customUserId'];
  }

  static Future<List<String>> getMyFavourites() async {
    final user = getCurrentUser();
    if (user != null) {
      debugPrint("User : ${user.uid}");
      final doc = await usersCollection.doc(user.uid).get();
      try {
        return UserModel.fromJson(doc.data() ?? {}).favourites;
      } catch (e) {
        return ["Action"];
      }
    } else {
      return ["Action"];
    }
  }

  static Future<void> addIfCustomUserIdNotExists() async {
    debugPrint("Checking Custom User ID");
    final user = firebaseAuth.currentUser;
    if (user == null) {
      return;
    }
    final doc = await usersCollection.doc(user.uid).get();
    final userModel = UserModel.fromJson(doc.data() ?? {});
    debugPrint("cUSTOM uSER id : ${userModel.customUserId}");
    if (userModel.customUserId == "" ||
        userModel.customUserId == null ||
        userModel.customUserId == "null") {
      debugPrint("Adding Custom User ID");
      API().getUserId().then((value) async {
        debugPrint("Custom User ID : $value");
        await usersCollection.doc(user.uid).update({"customUserId": "$value"});
      });
    }
  }
}
