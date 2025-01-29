import 'package:cloud_firestore/cloud_firestore.dart';

class VBTUser{
  VBTUser({required this.uid});

  final String uid;

  Map<String, dynamic> toFirestore() {
    return {"uid": uid};
  }

  factory VBTUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return VBTUser(uid: data['name']);
  }
}
