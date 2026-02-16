import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plan_pay_application/firebase_options.dart';
import 'package:plan_pay_application/hive/transaction_adapter.dart';
import 'package:plan_pay_application/hive/wallet_adapter.dart';
import 'package:plan_pay_application/models/monthly_plan.dart';
import 'package:plan_pay_application/models/weekly_plan.dart';
import 'package:plan_pay_application/view_models/auth_controller.dart';
import 'package:plan_pay_application/view_models/monthly_view_model.dart';
import 'package:plan_pay_application/view_models/wallet_view_model.dart';
import 'package:plan_pay_application/view_models/weekly_view_model.dart';
import 'package:plan_pay_application/views/home.dart';
import 'package:plan_pay_application/views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();

  Hive.registerAdapter(WalletHiveAdapter());
  Hive.registerAdapter(TransactionHiveAdapter());
  Hive.registerAdapter(MonthlyPlanAdapter());
  Hive.registerAdapter(WeeklyPlanAdapter());

  await Hive.openBox<MonthlyPlan>('monthly_plans');
  await Hive.openBox<WeeklyPlan>('weekly_plans');

  await Hive.openBox<WalletHive>('walletBox');
  await Hive.openBox<TransactionHive>('transactionBox');
  Get.put(MonthlyViewModel());
  Get.put(WeeklyViewModel());
  Get.put(WalletViewModel());
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authService = Get.find();
    return GetMaterialApp(
      title: 'Plan Pay Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Obx(
        () => authService.user.value != null
            ? const Home()
            : const LoginView(),
      ),
    );
  }
}
