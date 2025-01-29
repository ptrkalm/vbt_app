import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vbt_app/models/vbt_user.dart';
import 'package:vbt_app/services/workout/workout_service.dart';

class UserService {
  static final _firebaseAuth = FirebaseAuth.instance;
  static final _usersCollection = FirebaseFirestore.instance.collection("users").withConverter(
      fromFirestore: VBTUser.fromFirestore, toFirestore: (VBTUser user, _) => user.toFirestore());

  static FirebaseAuth get firebaseAuth => _firebaseAuth;
  static CollectionReference get usersCollection => _usersCollection;

  static Future<void> signUp(String email, String password) async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((credentials) {
        final uid = credentials.user!.uid;
        _usersCollection.doc(uid).set(VBTUser(uid: uid));
      });
    } on FirebaseAuthException catch (exception) {
      throw SignUpOrSignInException(exception.code);
    } catch (exception) {
      throw SignUpOrSignInException("Unknown exception.");
    }
  }

  static Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (exception) {
      throw SignUpOrSignInException(exception.code);
    } catch (exception) {
      throw SignUpOrSignInException("Unknown exception");
    }
  }

  static Future<void> signOut() async {
    _firebaseAuth.signOut();
  }

  static Future<void> deleteAccount() async {
    await WorkoutService.deleteWorkoutCollection(_firebaseAuth.currentUser!.uid);
    var snapshot = await usersCollection.doc(_firebaseAuth.currentUser!.uid).get();
    await snapshot.reference.delete();
    await _firebaseAuth.currentUser!.delete();
    signOut();
  }
}

class SignUpOrSignInException implements Exception {
  final String message;

  SignUpOrSignInException(this.message);
}
