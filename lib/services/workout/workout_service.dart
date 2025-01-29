import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vbt_app/models/vbt_workout.dart';
import 'package:vbt_app/services/user/user_service.dart';

class WorkoutService {
  static Future<void> addWorkout(VBTWorkout workout) async {
    try {
      final uid = UserService.firebaseAuth.currentUser!.uid;
      await _getWorkoutsCollection(uid).doc(workout.id).set(workout);
    } catch (exception) {
      throw Exception("Failed to add workout: $exception");
    }
  }

  static Future<List<VBTWorkout>> loadWorkouts() async {
    try {
      final uid = UserService.firebaseAuth.currentUser!.uid;
      final snapshot = await _getWorkoutsCollection(uid).get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (exception) {
      throw Exception("Failed to load workouts: $exception");
    }
  }

  static CollectionReference<VBTWorkout> _getWorkoutsCollection(String uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("workouts")
        .withConverter(
            fromFirestore: VBTWorkout.fromFirestore,
            toFirestore: (VBTWorkout workout, _) => workout.toFirestore());
  }

  static Future<void> deleteWorkoutCollection(String uid) async {
    var snapshot = await FirebaseFirestore.instance.collection("users").doc(uid).collection("workouts").get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
