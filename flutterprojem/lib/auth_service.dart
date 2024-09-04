import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register function
  Future<User?> registerWithEmailAndPassword(String name, String surname, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // Save user info to Firestore
      await _firestore.collection('users').doc(user!.uid).set({
        'name': name,
        'surname': surname,
        'email': email,
      });

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in function
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
