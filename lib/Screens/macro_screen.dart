import 'dart:async';

import 'package:dowajo/Patient/patient_controller.dart';
// import 'package:dowajo/database/alarm_database.dart'; // '.dart' 중복 제거
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MacroScreen extends StatefulWidget {
  const MacroScreen({super.key});

  @override
  State<MacroScreen> createState() => _MacroScreen();
}

class _MacroScreen extends State<MacroScreen> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  late DatabaseReference ref;
  List<Map<String, dynamic>> userRequires =
      []; // userRequires를 문자열 리스트에서 맵 리스트로 변경

  StreamSubscription<DatabaseEvent>? _subscription;

 @override
void initState() {
  super.initState();
  ref = database.ref().child('userRequires'); // 모든 환자의 데이터를 가져오기 위해 경로 수정

  _subscription = ref.onValue.listen((event) {
    final data = event.snapshot.value as Map<dynamic, dynamic>?; // 데이터를 맵으로 캐스팅
    final List<Map<String, dynamic>> allUserRequires = []; // 모든 사용자 요청을 저장할 리스트

    if (data != null) {
      data.forEach((patientId, patientData) {
        // 각 환자 ID와 그에 해당하는 데이터에 대해 반복
        final patientDataMap = patientData as Map<dynamic, dynamic>;
        patientDataMap.forEach((key, value) {
          allUserRequires.add({
            'patientId': patientId, // 환자 ID 추가
            'data': value['data'], // 데이터 필드
            'timestamp': value['timestamp'], // 타임스탬프 필드
          });
        });
      });

      // timestamp 기준으로 allUserRequires 정렬
      allUserRequires.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

      setState(() {
        userRequires = allUserRequires; // 전체 리스트를 업데이트
      });
    }
  });
}


  @override
  void dispose() {
    _subscription?.cancel(); // 구독 취소
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PatientController controller = Get.find();
    final patient = controller.searchResult.value!.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('전체 알림 모아보기'),
      ),
      body: userRequires.isNotEmpty
          ? ListView.builder(
              itemCount: userRequires.length,
              itemBuilder: (context, index) {
                final patientId = userRequires[index]['patientId'];

// FutureBuilder를 사용하여 환자 이름을 비동기적으로 가져옵니다.
                return FutureBuilder<String?>(
                  future: Get.find<PatientController>()
                      .getPatientNameById(patientId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // 데이터가 준비되면 환자의 이름을 표시합니다.
                      final patientName = snapshot.data ?? '이름 없음';
                      final data = userRequires[index]['data'];
                      final timestamp = userRequires[index]['timestamp'];

                      return ListTile(
                        leading: Text(patientName, // 환자 이름 표시
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20,
                                fontWeight: FontWeight.w800)),
                        title: Text(data),
                        subtitle: Text(timestamp),
                      );
                    } else {
                      // 데이터를 기다리는 동안 로딩 인디케이터를 표시합니다.
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
// 데이터가 로드되는 동안 표시
    );
  }
}
