import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_tracker/data/models/user.dart';

class UserRepository extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository()
      : _firebaseAuth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn();

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signUp(
      {required String name,
      required String email,
      required String password}) async {
    User? user;
    try {
      UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = result.user;
      await user!.updateDisplayName(name);
      await user.reload();
      user = _firebaseAuth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        //print('The account already exists for that email.');
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    //return Future.wait([
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    //]);
  }

  MyAppUser _userFromFirebase(User user) {
    return MyAppUser(
      id: user.uid,
      email: user.email,
      name: user.displayName,
      photo: user.photoURL,
    );
  }

  Future<MyAppUser> fetchCurrentUser() async {
    MyAppUser userFromFirebase = _userFromFirebase(_firebaseAuth.currentUser!);
    return userFromFirebase;
  }

  Future<User?> refreshUser(User user) async {
    await user.reload();
    User? refreshedUser = _firebaseAuth.currentUser;
    return refreshedUser;
  }

  Future<void> updateUserPhoto(String url) async {
    User _user = _firebaseAuth.currentUser!;
    await _user.updatePhotoURL(url);
    await _user.reload();
    //MyAppUser updateUser = _userFromFirebase(_firebaseAuth.currentUser!);
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser!;
    return currentUser.email != null;
  }
}
