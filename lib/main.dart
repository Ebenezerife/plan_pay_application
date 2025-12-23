import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_pay_application/views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Plan Pay Application',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}
