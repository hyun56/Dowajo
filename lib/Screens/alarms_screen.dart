import 'dart:async';
import 'package:dowajo/Patient/patient_controller.dart';
import 'package:dowajo/database/alarm_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AlarmsScreen extends StatefulWidget {
  const AlarmsScreen({Key? key}) : super(key: key);

  @override
  _AlarmsScreenState createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  late DatabaseReference ref;
  List<String> userRequires = [];

  StreamSubscription<DatabaseEvent>? _subscription;
  late PatientController controller;
  late String patientId;

  @override
  void initState() {
    super.initState();
    setupDataListener();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void setupDataListener() {
    controller = Get.find();
    patientId = controller.searchResult.value!.first.id;
    ref = database.ref().child(patientId).child('userRequire');
    _subscription?.cancel();

    _subscription = ref.onValue.listen((event) async {
      final data = event.snapshot.value;
      if (data != null) {
        await loadData(data);
      }
    });
  }

  Future<void> loadData(dynamic data) async {
    String timestamp = DateFormat('yy.MM.dd - HH:mm:ss').format(DateTime.now());

    // 중복 확인
    if (!userRequires.contains(data.toString())) {
      // 새로운 데이터를 리스트에 추가
      userRequires.add(data.toString());

      // Firebase에 새로운 데이터 추가
      DatabaseReference newRef = database.ref('userRequires/$patientId');
      await newRef.push().set({'data': data, 'timestamp': timestamp});

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    controller = Get.find();
    patientId = controller.searchResult.value!.first.id;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '개별 알림',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 235, 238, 240),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream:
            DatabaseHelper.instance.getUserRequiresStreamByPatientId(patientId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userRequires = snapshot.data!;
            userRequires.sort((a, b) => DateFormat('yy.MM.dd - HH:mm:ss')
                .parse(b['timestamp'])
                .compareTo(
                    DateFormat('yy.MM.dd - HH:mm:ss').parse(a['timestamp'])));

            String today = DateFormat('yy.MM.dd').format(DateTime.now());

            return ListView.builder(
              itemCount: userRequires.length,
              itemBuilder: (context, index) {
                final data = userRequires[index]['data'];
                final timestamp = userRequires[index]['timestamp'];

                int lastChar = data.codeUnitAt(data.length - 1);
                bool hasFinalConsonant = (lastChar - 44032) % 28 != 0;

                String date = timestamp.split(' - ')[0];
                String time = timestamp.split(' - ')[1];

                String displayDate =
                    (date == today) ? '오늘  $time' : '$date  |  $time';

                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: Text(controller.searchResult.value!.first.name,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                            fontWeight: FontWeight.w800)),
                    title: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: '환자가 ',
                            style: TextStyle(color: Colors.black, fontSize: 15),
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
                            text: hasFinalConsonant ? '을 요청했습니다.' : '를 요청했습니다.',
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
              },
            );
          } else if (snapshot.hasError) {
            return const Text('데이터를 불러올 수 없습니다.');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
