import 'package:flutter/foundation.dart';
import 'dart:collection';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task.dart';

class TaskData extends GetxController {
  List<Task> _tasks = [
    // Task(name: 'Buy milk'),
    // Task(name: 'Buy eggs'),
    // Task(name: 'Buy bread'),
  ];

  List<Task> get tasks {
    return [..._tasks];
    update();
  }

  Future<void> getData(String uid) async {
    _tasks = [];
    try {
      final _loadedTasks = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .get();
      for (int i = 0; i < _loadedTasks.docs.length; i++) {
        var a = _loadedTasks.docs[i];
        final task = Task(
            name: a['name'], isDone: a['isdone'], createdAt: a['createdAt']);
        _tasks.add(task);
        update();
      }
    } catch (error) {
      print(error);
    }
  }

  int get taskCount {
    return _tasks.length;
  }

  Future<void> addTask(String uid, String newTaskTitle) async {
    final newTask = Task(name: newTaskTitle, isDone: false, createdAt:Timestamp.now());
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .add({
        'name': newTask.name,
        'isdone': newTask.isDone,
        'createdAt': newTask.createdAt,
      });
      _tasks.add(newTask);
      update();
    } catch (error) {
      print(error);
    }
  }

  Future<void> updateTask(
    String uid,
    Task task,
  ) async {
    try {
      task.toggleDone();
      QuerySnapshot querysnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .get();
      final id = querysnapshot.docs
          .firstWhere((element) => element['createdAt'] == task.createdAt)
          .id;
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(id)
          .update({'isdone': task.isDone});
      update();
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteTask(String uid, Task task) async {
    _tasks.remove(task);
    try {
      QuerySnapshot querysnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .get();
      final id = querysnapshot.docs
          .firstWhere((element) => element['createdAt'] == task.createdAt)
          .id;
      print(id);
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(id)
          .delete();
      update();
    } catch (error) {
      print(error);
    }
  }
}
