import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/tasks_list.dart';
import '../screens/add_task_screen.dart';
import '../screens/phone_authentication_login.dart';
import '../models/task_data.dart';

class TasksScreen extends StatefulWidget {
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  var _isInit = true;
  var _isLoading = false;

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Get.put(TaskData(), permanent: true).getData(uid).then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      } catch (error) {
        showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'),
            content: Text(error.toString()),
            actions: [
              FlatButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('OK'))
            ],
          ),
        );
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Get.put(TaskData(), permanent: true).getData(uid);
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: AddTaskScreen(uid),
              ),
            ),
          );
        },
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            child: Icon(
                              Icons.list,
                              size: 30.0,
                              color: Colors.lightBlueAccent,
                            ),
                            backgroundColor: Colors.white,
                            radius: 30.0,
                          ),
                          IconButton(
                            icon: Icon(Icons.logout),
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Get.offAll(LoginScreen(),
                                  transition: Transition.fadeIn);
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Todo - app',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GetBuilder<TaskData>(
                        builder: (taskData) {
                          return Text(
                            '${taskData.taskCount} Tasks',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: TasksList(uid),
                  ),
                ),
              ],
            ),
    );
  }
}
