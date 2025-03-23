import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository(this._auth);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      UserCredential userCredential =
          await _auth.signInWithProvider(googleProvider);

      if (userCredential.user != null) {
        await _saveUserToFirestore(userCredential.user!);
        await _saveUserToLocal(userCredential.user!.uid);
      }

      return userCredential.user;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut() async {
     await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userUID');
  }

  Future<void> _saveUserToFirestore(User user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'name': user.displayName,
      'email': user.email,
    });
  }

  Future<void> _saveUserToLocal(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userUID', uid);
  }

  Future<String?> getStoredUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userUID');
  }

  User? getUser() {
    return _auth.currentUser;
  }
}
