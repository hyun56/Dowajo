import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

//Notification 플로그인 객체 생성
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class NotificationService {
  // 싱글톤 패턴을 사용하기 위한 private static 변수
  static final NotificationService _instance = NotificationService._();

  // NotificationService 인스턴스 반환
  factory NotificationService() {
    return _instance;
  }

  // private 생성자
  NotificationService._();

//local Notification 함수, 앱로드시 실행할 기본설정
  Future<void> initNotification() async {
    //안드로이드 초기 설정 (아이콘도 같이 등록)
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

  // 푸시 알림 권한 요청
  Future<PermissionStatus> requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    return status;
  }

// 푸시 알림 생성, 이 함수 원하는 곳에서 실행하면 알림 뜸
  Future<void> showNotification(int targetNumber) async {
    // 푸시 알림의 ID
    const int notificationId = 0;
    final result; //권한 확인을 위한 변수

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

    // 알림 채널 설정값 구성
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'counter_channel', // 알림 채널 ID
      'Counter Channel', // 알림 채널 이름
      channelDescription: 'description', // 알람 내용

      priority: Priority.high, // 알림 채널 설명
      importance: Importance.high, // 알림 중요도
      color: Color.fromARGB(255, 255, 0, 0),
      // Notification Icon 배경색
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // 알림 상세 정보 설정
    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

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

    //알림 보이기, 권한이 있으면 실행.
    if (result == true) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.deleteNotificationChannelGroup('id');

      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId, // 스케줄 ID(고유)
        'title', //알람 제목
        'description', //알람 내용
        _setNotiTime(), //알람 시간
        notificationDetails,
        payload: '부가정보', // 부가정보
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        //옵션 값에따라 시간만 맞춰서 작동할지, 월,일,시간 모두 맞춰서 작동할지 옵션 설정
        matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
      );

      makeDate(hour, min, sec) {
        var now = tz.TZDateTime.now(tz.local);
        var when = tz.TZDateTime(
            tz.local, now.year, now.month, now.day, hour, min, sec);
        if (when.isBefore(now)) {
          return when.add(Duration(days: 1));
        } else {
          return when;
        }
      }
    }
  }
}
