import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vbt_app/models/vbt_set.dart';
import 'package:uuid/uuid.dart';

class VBTWorkout {
  VBTWorkout({required this.name, String? id, List<VBTSet>? sets, DateTime? dateTime})
      : id = id ?? const Uuid().v4().toString(),
        sets = sets ?? [],
        dateTime = dateTime ?? DateTime.now();

  final String id;
  final String name;
  final DateTime dateTime;
  List<VBTSet> sets;

  VBTWorkout withSet(VBTSet set) {
    return VBTWorkout(name: name, id: id, sets: List.from(sets)..add(set), dateTime: dateTime);
  }

  VBTWorkout withName(String name) {
    return VBTWorkout(name: name, id: id, sets: sets, dateTime: dateTime);
  }

  List<double> getBestVelocityMaxes() {
    return sets.map((set) => set.getBestVelocityMax()).toList();
  }

  List<double> getBestRfdMaxes() {
    return sets.map((set) => set.getBestRfdMax()).toList();
  }

  List<double> getBestTimeToRfdMaxes() {
    return sets.map((set) => set.getBestRfdMax()).toList();
  }

  List<double> getAverageVelocityMaxes() {
    return sets.map((set) => set.getAverageVelocityMax()).toList();
  }

  List<double> getAverageRfdMaxes() {
    return sets.map((set) => set.getAverageRfdMax()).toList();
  }

  List<double> getAverageTimeToRfdMaxes() {
    return sets.map((set) => set.getAverageTimeToRfdMax()).toList();
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "name": name,
      "sets": sets.map((set) => set.toFirestore()).toList(),
      "dateTime": dateTime
    };
  }

  factory VBTWorkout.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? _) {
    final data = snapshot.data()!;
    return VBTWorkout(
        id: data["id"],
        name: data["name"],
        sets: List.from(data["sets"].map((set) => VBTSet.fromFirestore(set, null))),
        dateTime: (data["dateTime"] as Timestamp).toDate());
  }
}
