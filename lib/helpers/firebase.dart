import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dism/objects/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Firebasehelper {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AppUser _appUser;
  User _user;

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future loginWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
    GoogleSignInAccount account = await _googleSignIn.signIn();
    GoogleSignInAuthentication authentication = await account.authentication;
    _user = (await _auth.signInWithCredential(
      GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken,
      ),
    ))
        .user;

    await _firestore.collection('users').doc(_user.uid).update({
      "name": _user.displayName,
      "uid": _user.uid,
      "email": _user.email,
      "image_url": _user.photoURL,
      "lastSignedIn": _user.metadata.lastSignInTime,
      "createdAt": _user.metadata.creationTime,
    });

    return _user;
  }

  Future<void> logout() async {
    return await _auth.signOut();
  }
}

final firebase = Firebasehelper();
