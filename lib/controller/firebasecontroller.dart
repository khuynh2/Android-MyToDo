import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FireBaseController {
  static Future signIn(String email, String password) async {
    AuthResult auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return auth.user;
  }

  static Future<void> signUp(String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

    static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }


  static Future<Map<String, String>> uploadStorage({
    @required String uid,
    @required String email,
    @required String username,
    @required File image,
    @required Function listener,

  }) async {}
}
