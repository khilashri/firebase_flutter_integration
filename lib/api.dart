import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart';

class ApiService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static signinwithgoogle() async {
    GoogleSignInAccount? user = await _googleSignIn.signIn();
    GoogleSignInAuthentication signIn = await user!.authentication;
    final credential = GoogleAuthProvider.credential(
        idToken: signIn.idToken, accessToken: signIn.accessToken);
    FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) => print('signIn'));
  }

  static Future<String> uploadFile(String destination, File file) async {
    print(file.path);
    String fileName = file.path.split("/").last.split(".").last;

    final ref = FirebaseStorage.instance.ref().child(destination + fileName);
    UploadTask task = ref.putFile(file);
    final profileImagename = basename(file.path);

    final snapshot = await task.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }
}
