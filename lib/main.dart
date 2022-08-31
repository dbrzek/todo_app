import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/phone_authentication_login.dart';
import './models/task_data.dart';


void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => TaskData());
    return GetMaterialApp(
        home: LoginScreen(),
      );
  }
}
