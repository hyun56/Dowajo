import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dowajo/Patient/patient_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class NotificationManager {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    print('NotificationManager initialized'); // 디버깅 로그
  }

  static void setupDatabaseListener() {
    try {
      final DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref();

      // 모든 환자의 userRequire 노드를 리스닝
      databaseReference.onChildAdded.listen((event) {
        String patientId = event.snapshot.key!;
        // print('Listening to Patient ID: $patientId'); // 디버깅 로그
        databaseReference.child(patientId).child('userRequire').onValue.listen(
            (event) async {
          // print('데이터 인식'); // 디버깅 로그
          final updatedData = event.snapshot.value;
          // final patientName = await getPatientNameFromFirestore(patientId);
          showNotification(updatedData.toString(), patientId);
        }, onError: (error) {
          print('데이터베이스 리스닝 중 오류 발생: $error');
        });
      });
    } catch (e) {
      print('데이터베이스 리스너 설정 중 오류: $e'); // 에러 로그
    }
  }

  static Future<void> showNotification(String message, String patientid) async {
    final patientName = await getPatientNameFromFirestore(patientid);
    final patientRoom = await getPatientRoomFromFirestore(patientid);
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      '$patientName($patientRoom호)',
      message,
      platformChannelSpecifics,
      payload: 'item x',
    );
    print('Notification shown with message: $message'); // 디버깅 로그
  }

  static Future<String> getPatientNameFromFirestore(String patientId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Patient')
          .where('id', isEqualTo: patientId) // id를 문자열로 직접 비교
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var documentSnapshot = querySnapshot.docs.first;
        // print('Firestore에서 문서 데이터: ${documentSnapshot.data()}'); // 디버깅 로그 추가
        return documentSnapshot['name'] ?? 'Unknown';
      } else {
        // print('문서가 존재하지 않습니다: $patientId'); // 디버깅 로그 추가
        return 'Unknown';
      }
    } catch (e) {
      print('Firestore에서 환자 이름 가져오기 오류: $e'); // 에러 로그
      return 'Unknown';
    }
  }
 static Future<String> getPatientRoomFromFirestore(String patientId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Patient') // 컬렉션 이름 확인
          .where('id', isEqualTo: patientId) // id를 문자열로 직접 비교
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var documentSnapshot = querySnapshot.docs.first;
        // print('Firestore에서 문서 데이터: ${documentSnapshot.data()}'); // 디버깅 로그 추가
        return documentSnapshot['room'].toString(); // 문자열로 변환하여 반환
      } else {
        // print('문서가 존재하지 않습니다: $patientId'); // 디버깅 로그 추가
        return 'Unknown';
      }
    } catch (e) {
      print('Firestore에서 환자 번호 가져오기 오류: $e'); // 에러 로그
      return 'Unknown';
    }
  }
}
