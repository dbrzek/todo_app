import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/task_tile.dart';
import '../models/task_data.dart';

class TasksList extends StatelessWidget {
  String uID;
  TasksList(this.uID);
  // Get.find<TaskData>().getData();
  @override
  Widget build(BuildContext context) {
    //  var widget;
    //  Get.put(TaskData(), permanent: false).getData(widget.uID);
    //  final data = Get.put(TaskData());
    //  data.getData();
    return GetBuilder<TaskData>(
      builder: (taskData) {
        //  taskData.getData(uID);

        // zmienić miejsce, aby raz pobierało dane
        return taskData.tasks.isEmpty
            ? Center(child: Text('No task yet'))
            : ListView.builder(
                itemBuilder: (context, index) {
                  final task = taskData.tasks[index];
                  return TaskTile(
                    taskTitle: task.name,
                    isChecked: task.isDone,
                    checkboxCallback: (checkboxState) {
                      if (checkboxState != null) {
                        taskData.updateTask(uID, task);
                      }
                    },
                    longPressCallback: () {
                      taskData.deleteTask(uID, task);
                    },
                  );
                },
                itemCount: taskData.taskCount,
              );
      },
    );
  }
}



// return StreamBuilder(
//       stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
//       builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         final tasks = snapshot.data?.docs;
//         return ListView.builder(
//           itemBuilder: (context, index) {
//             final task = Task(name: tasks![index]['task'] as String, isDone: false);
//             return TaskTile(
//               taskTitle: task.name,
//               isChecked: task.isDone,
//             //   checkboxCallback: (checkboxState) {
//             //     if (checkboxState != null) {
//             //       tasks.updateTask(task);
//             //     }
//             //   },
//             //   longPressCallback: () {
//             //     taskData.deleteTask(task);
//             //   },
//             );
//           },
//           itemCount: tasks?.length,
//         );
//       },