import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dism/helpers/permission.dart';
import 'package:dism/objects/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart';

class Firebasehelper {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AppUser _appUser;
  User _user;
  AppUser get currentUser => _appUser;
  FirebaseAuth _auth = FirebaseAuth.instance;
  init() async {
    if (_auth != null) {
      _user = _auth.currentUser;
      if (_user != null) {
        _appUser = await getUser();
      }
      return _user;
    }
    return null;
  }

  Future<AppUser> getUser([String uid]) async {
    var data = await _firestore.collection('users').doc(_user.uid).get();
    if (data.data() != null)
      return AppUser.fromMap(data.data());
    else
      return null;
  }

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

    if (_user != null) {
      _appUser = AppUser(
          name: _user.displayName,
          uid: _user.uid,
          email: _user.email,
          img: _user.photoURL);
      await manageUser();
    }

    return _user;
  }

  Future<void> manageUser({bool local = true}) async {
    if (_appUser != null) {
      if (local) {
        await mPermission.checkPermission();
        await mPermission.requestPermission();
      }
      var location = await Location().getLocation();
      return await _firestore.collection('users').doc(_user.uid).set(
          (_appUser
                ..lat = location.latitude
                ..long = location.longitude)
              .toMap(),
          SetOptions(merge: true));
    }
    return null;
  }

  Future<void> logout() async {
    _user = null;
    _appUser = null;
    return await _auth.signOut();
  }
}

final firebase = Firebasehelper();
