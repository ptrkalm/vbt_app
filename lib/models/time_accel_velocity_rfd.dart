import 'package:cloud_firestore/cloud_firestore.dart';

class TimeAccelVelocityRfd {
  const TimeAccelVelocityRfd(this.time, this.accel, this.velocity, this.rfd);

  final double time;
  final double accel;
  final double velocity;
  final double rfd;

  Map<String, dynamic> toFirestore() {
    return {
      "time": time,
      "accel": accel,
      "velocity": velocity,
      "rfd": rfd,
    };
  }

  factory TimeAccelVelocityRfd.fromFirestore(Map<String, dynamic> data, SnapshotOptions? _) {
    return TimeAccelVelocityRfd(data["time"], data["accel"], data["velocity"], data["rfd"]);
  }
}
