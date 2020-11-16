import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:term_project/model/userprofile.dart';

class FireBaseController {
  static Future signIn(String email, String password) async {
    AuthResult auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return auth.user;
  }

  // static Future<bool> signUpCheck(String email, String password) async {
  //   AuthResult auth = await FirebaseAuth.instance
  //       .createUserWithEmailAndPassword(email: email, password: password);
  //   if (auth.additionalUserInfo.isNewUser) {
  //     print('==============Creating new account');
  //     return true;
  //   } else {
  //     print('==============Email already used');
  //     return false;
  //   }
  // }

  static Future<void> signUp(String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<String> addUserProfile(User userProfile) async {
    DocumentReference ref = await Firestore.instance
        .collection(User.COLLECTION)
        .add(userProfile.serializeUser());
    return ref.documentID;
  }

  static Future<List<User>> getUserProfile(String email) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(User.COLLECTION)
        .where(User.EMAIL, isEqualTo: email)
        .getDocuments();

    var profile = <User>[];
    if (querySnapshot != null && querySnapshot.documents.length != 0) {
      for (var doc in querySnapshot.documents) {
        profile.add(User.deserializeUser(doc.data, doc.documentID));
      }
    }
    return profile;
  }

  static Future<Map<String, String>> uploadStorage({
    @required String uid,
    @required String email,
    @required String username,
    @required File image,
    @required Function listener,
  }) async {}
}
