import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vbt_app/models/time_accel_velocity_rfd.dart';

class VBTRep {
  VBTRep(
      {required this.data,
      required this.velocityMax,
      required this.rfdMax,
      required this.timeToRfdMax});

  final List<TimeAccelVelocityRfd> data;
  final double velocityMax;
  final double rfdMax;
  final double timeToRfdMax;

  Map<String, dynamic> toFirestore() {
    return {
      "data": data.map((sample) => sample.toFirestore()).toList(),
      "velocityMax": velocityMax,
      "rfdMax": rfdMax,
      "timeToRfdMax": timeToRfdMax
    };
  }

  factory VBTRep.fromFirestore(Map<String, dynamic> snapshot, SnapshotOptions? _) {
    return VBTRep(
        data: List.from(
            snapshot["data"].map((sample) => TimeAccelVelocityRfd.fromFirestore(sample, null))),
        velocityMax: snapshot["velocityMax"],
        rfdMax: snapshot["rfdMax"],
        timeToRfdMax: snapshot["timeToRfdMax"]);
  }
}
