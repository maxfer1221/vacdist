import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class GoogleSignInProvider extends ChangeNotifier {
  GoogleSignInProvider();

  final googleSignIn = GoogleSignIn();

  Future<String> login() async {
    final user = await googleSignIn.signIn();

    if (user == null) {
      return '';
    } else {
      final googleAuth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      return googleAuth.accessToken!;
    }
  }

  void logout() async {
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }
}
