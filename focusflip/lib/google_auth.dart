import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

Future<UserCredential?> signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? '933796135635-h78ct5652e784u5md4124pu6oe97slvm.apps.googleusercontent.com' : null,
    serverClientId: kIsWeb ? null : '933796135635-h78ct5652e784u5md4124pu6oe97slvm.apps.googleusercontent.com',
  );

  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  if (googleUser == null) return null;

  final googleAuth = await googleUser.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return FirebaseAuth.instance.signInWithCredential(credential);
}