import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/task_data.dart';

class AddTaskScreen extends StatefulWidget {
  String uid;
  AddTaskScreen(this.uid);
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _controller = new TextEditingController();
  String? newTaskTitle;

  void _sendTask() async {
    Get.find<TaskData>().addTask(widget.uid, newTaskTitle!);
    FocusScope.of(context).unfocus();
    _controller.clear();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.lightBlueAccent,
              ),
            ),
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(labelText: 'Write a task'),
              textAlign: TextAlign.center,
              onChanged: (newText) {
                setState(() {
                  newTaskTitle = newText;
                });
              },
            ),
            FlatButton(
              child: Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.lightBlueAccent,
              onPressed: () {
                _sendTask();
              },
            ),
          ],
        ),
      ),
    );
  }
}
