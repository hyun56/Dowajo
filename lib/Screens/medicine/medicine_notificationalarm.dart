// import 'dart:io';
// import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  // 싱글톤 패턴을 사용하기 위한 private static 변수
  static final NotificationService _instance = NotificationService._();

  // NotificationService 인스턴스 반환
  factory NotificationService() {
    return _instance;
  }
  // private 생성자
  NotificationService._();

  // 로컬 푸시 알림을 사용하기 위한 플러그인 인스턴스 생성
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 초기화 작업을 위한 메서드 정의
  Future<void> init() async {
    // 알림을 표시할 때 사용할 로고를 지정
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // 안드로이드 플랫폼에서 사용할 초기화 설정
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // 로컬 푸시 알림을 초기화
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // 푸시 알림 생성
  Future<void> showNotification(int targetNumber) async {
    // 푸시 알림의 ID
    const int notificationId = 0;

    // 알림 채널 설정값 구성
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'counter_channel', // 알림 채널 ID
      'Counter Channel', // 알림 채널 이름
      channelDescription:
          'This channel is used for counter-related notifications',

      // 알림 채널 설명
      importance: Importance.high, // 알림 중요도
    );

    // 알림 상세 정보 설정
    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    // 알림 보이기
    await flutterLocalNotificationsPlugin.show(
      notificationId, // 알림 ID
      '목표 도달', // 알림 제목
      '$targetNumber 회 눌렀습니다!', // 알림 메시지
      notificationDetails, // 알림 상세 정보
    );
  }

  // 푸시 알림 권한 요청
  Future<PermissionStatus> requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    return status;
  }
}

/*
Future ClockTimeNotification() async {
  final notiTitle = 'title'; //알람 제목
  final notiDesc = 'description'; //알람 내용
  final result; //권한 확인을 위한 변수
  //----------------------------------------------------------------------------------
  //local notification 플러그인 객체 생성
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //플랫폼 확인해서 OS 종류에 따라 권한 확인
  //안드로이드 일때
  if (Platform.isAndroid) {
    result = true;
  }
  //IOS 일때
  else {
    result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
  //----------------------------------------------------------------------------------
  //안드로이드 Notification 옵션
  var android = AndroidNotificationDetails('id', notiTitle,
      channelDescription: notiDesc,
      importance: Importance.max,
      priority: Priority.max,
      color: const Color.fromARGB(
          255, 255, 0, 0)); //여기color는 Notification Icon 배경색

  //IOS Notification 옵션
  var ios = DarwinNotificationDetails();

  //Notificaiton 옵션 값 등록
  var detail = NotificationDetails(android: android, iOS: ios);
//----------------------------------------------------------------------------------
  //권한이 있으면 실행.
  if (result == true) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannelGroup('id');

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // 스케줄 ID(고유)
      notiTitle, //알람 제목
      notiDesc, //알람 내용
      _setNotiTime(), //알람 시간
      detail,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      //이 옵션은 중요함(옵션 값에따라 시간만 맞춰서 작동할지, 월,일,시간 모두 맞춰서 작동할지 옵션 설정
      //아래와 같이 time으로 설정되어있으면, setNotTime에서 날짜를 아무리 지정해줘도 시간만 동일하면 알림이 발생
      matchDateTimeComponents: DateTimeComponents.time, //또는dayOfMonthAndTime
    );
  }
}

//알람 시간 세팅
tz.TZDateTime _setNotiTime() {
  tz.initializeTimeZones(); //TimeZone Database 초기화
  tz.setLocalLocation(tz.getLocation('Asia/Seoul')); //TimeZone 설정(외국은 다르게!)
  final now = tz.TZDateTime.now(tz.local);
  var scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, 13, 06, 30); //알람 시간
  //var test = tz.TZDateTime.now(tz.local).add(const Duration (seconds: 5));
  print('-----------알람 시간 체크----${scheduledDate.toString()}');
  return scheduledDate;
}
*/