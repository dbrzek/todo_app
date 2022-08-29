import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String? name;
  bool isDone;
  Timestamp? createdAt;

  Task({this.name, this.isDone = false, this.createdAt});

  void toggleDone() {
    isDone = !isDone;
  }
}
