import 'package:dowajo/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();
  await _initNotiSetting(); //local Notifcation 초기 설정

  runApp(const MyApp());
}

//local Notification 함수
Future<void> _initNotiSetting() async {
  //Notification 플로그인 객체 생성
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //안드로이드 초기 설정 (위에서 만든 아이콘도 같이 등록)
  final AndroidInitializationSettings initSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  //IOS 초기 설정(권한 요청도 할 수 있음) request...값을 true로 설정 시 앱이 켜지자마자 권한 요청을 함
  final DarwinInitializationSettings initSettingsIOS =
      DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true);

  //Notification에 위에서 설정한 안드로이드, IOS 초기 설정 값 삽입
  final InitializationSettings initSettings = InitializationSettings(
    android: initSettingsAndroid,
    iOS: initSettingsIOS,
  );

  //Notification 초기 설정
  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        //primarySwatch: Colors.,
      ),
      home: const HomeScreen(),
    );
  }
}
