import 'package:firebase_auth/firebase_auth.dart';

class FireBaseController {
  static Future signIn(String email, String password) async {
    AuthResult auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return auth.user;
  }
}
