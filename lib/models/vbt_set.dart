import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vbt_app/models/vbt_rep.dart';

class VBTSet {
  VBTSet({required this.name, List<VBTRep>? reps, this.bodyWeight, this.loadWeight})
      : reps = reps ?? [];

  final String name;
  final List<VBTRep> reps;
  double? bodyWeight;
  double? loadWeight;

  void add(VBTRep rep) {
    reps.add(rep);
  }

  void clear() {
    reps.clear();
  }

  double getFullWeight() {
    return bodyWeight! + loadWeight!;
  }

  List<double> getVelocityMaxes() {
    return reps.map((rep) => rep.velocityMax).toList();
  }

  List<double> getRfdMaxes() {
    return reps.map((rep) => rep.rfdMax).toList();
  }

  List<double> getTimeToRfdMaxes() {
    return reps.map((rep) => rep.timeToRfdMax).toList();
  }

  double getBestVelocityMax() {
    return double.parse(getVelocityMaxes().reduce((a, b) => a > b ? a : b).toStringAsFixed(2));
  }

  double getBestRfdMax() {
    return double.parse(getRfdMaxes().reduce((a, b) => a > b ? a : b).toStringAsFixed(2));
  }

  double getBestTimeToRfdMax() {
    return double.parse(getTimeToRfdMaxes().reduce((a, b) => a < b ? a : b).toStringAsFixed(2));
  }

  double getAverageVelocityMax() {
    return double.parse(
        (getVelocityMaxes().fold(0.0, (initial, value) => initial + value) / reps.length)
            .toStringAsFixed(2));
  }

  double getAverageRfdMax() {
    return double.parse((getRfdMaxes().fold(0.0, (initial, value) => initial + value) / reps.length)
        .toStringAsFixed(2));
  }

  double getAverageTimeToRfdMax() {
    return double.parse(
        (getTimeToRfdMaxes().fold(0.0, (initial, value) => initial + value) / reps.length)
            .toStringAsFixed(2));
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "reps": reps.map((rep) => rep.toFirestore()).toList(),
      "bodyWeight": bodyWeight,
      "loadWeight": loadWeight
    };
  }

  factory VBTSet.fromFirestore(Map<String, dynamic> data, SnapshotOptions? _) {
    return VBTSet(
        name: data["name"],
        reps: List.from(data["reps"].map((rep) => VBTRep.fromFirestore(rep, null))),
        bodyWeight: data["bodyWeight"],
        loadWeight: data["loadWeight"]);
  }
}
