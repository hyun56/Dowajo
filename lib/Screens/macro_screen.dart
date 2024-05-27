import 'dart:async';

import 'package:dowajo/Patient/patient_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MacroScreen extends StatefulWidget {
  const MacroScreen({super.key});

  @override
  State<MacroScreen> createState() => _MacroScreen();
}

class _MacroScreen extends State<MacroScreen> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  late DatabaseReference ref;
  List<Map<String, dynamic>> userRequires = [];

  StreamSubscription<DatabaseEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    ref = database.ref().child('userRequires'); // 모든 환자의 데이터를 가져오기 위해 경로 수정

    _subscription = ref.onValue.listen((event) {
      final data =
          event.snapshot.value as Map<dynamic, dynamic>?; // 데이터를 맵으로 캐스팅
      final List<Map<String, dynamic>> allUserRequires = [];

      if (data != null) {
        data.forEach((patientId, patientData) {
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
        allUserRequires
            .sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

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
        title: const Text(
          '전체 알림',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 235, 238, 240),
      body: userRequires.isNotEmpty
          ? ListView.builder(
              itemCount: userRequires.length,
              itemBuilder: (context, index) {
                final patientId = userRequires[index]['patientId'];

                String today = DateFormat('yy.MM.dd').format(DateTime.now());

                return FutureBuilder<String?>(
                  future: Get.find<PatientController>()
                      .getPatientNameById(patientId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // 데이터가 준비되면 환자의 이름을 표시
                      final patientName = snapshot.data ?? '이름 없음';
                      final data = userRequires[index]['data'];
                      final timestamp = userRequires[index]['timestamp'];

                      int lastChar = data.codeUnitAt(data.length - 1);
                      bool hasFinalConsonant = (lastChar - 44032) % 28 != 0;

                      String date = timestamp.split(' - ')[0];
                      String time = timestamp.split(' - ')[1];

                      String displayDate =
                          (date == today) ? '오늘 | $time' : '$date  |  $time';

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 15),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          leading: Text(patientName,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800)),
                          title: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: '환자가 ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                                TextSpan(
                                  text: data,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                TextSpan(
                                  text: hasFinalConsonant
                                      ? '을 요청했습니다.'
                                      : '를 요청했습니다.',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              displayDate,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      // 데이터를 기다리는 동안 로딩 인디케이터를 표시
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
