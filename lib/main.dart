//import 'dart:isolate';

import 'package:dowajo/Alarm/alarm_schedule.dart';
import 'package:dowajo/Alarm/local_alarm_manager.dart';
import 'package:dowajo/Alarm/work_manager.dart';
import 'package:dowajo/Screens/login/login.dart';
//import 'package:dowajo/Screens/home_screen.dart';
import 'package:dowajo/components/calendar/today_banner.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'notification_manager.dart'; // notification_manager.dart를 import합니다.
// import 'work_manager_setup.dart'; // work_manager_setup.dart를 import합니다.
// import 'utils.dart'; // utils.dart를 import합니다.
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  initializeDateFormatting();
  await AndroidAlarmManager.initialize();
  setupWorkManager(); // work_manager_setup.dart에서 정의한 함수를 호출합니다.

  NotificationManager.initialize();
  print('NotificationManager initialized');
  NotificationManager.setupDatabaseListener();
  print('Database listener setup complete');

  const String channelId = 'your channel id';
  const String channelName = 'your channel name';
  const String channelDescription = 'your channel description'; // Optional

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    channelId,
    channelName,
    description: channelDescription,
    importance: Importance.max,
  );

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  scheduleAlarm(); // 알람 스케줄링 추가

  runApp(
    ChangeNotifierProvider(
      create: (context) => MedicineModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        unselectedWidgetColor: const Color.fromARGB(255, 203, 202, 202),
      ),
      home: const LoginScreen(),
    );
  }
}
