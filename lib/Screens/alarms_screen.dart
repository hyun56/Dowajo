import 'package:dowajo/Patient/patient_controller.dart';
import 'package:dowajo/database/alarm_database.dart.dart';
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
  List<String> userRequires = []; // 데이터 변경을 기록할 리스트

  @override
  void initState() {
    super.initState();
    final PatientController controller =
        Get.find(); // PatientController 인스턴스를 찾습니다.
    final patient = controller.searchResult.value!.first;
// 환자 ID를 가져옵니다.

    ref = database.ref().child(patient.id).child('userRequire');

// 데이터 스트림을 듣고, 데이터가 업데이트 될 때마다 리스트에 추가
    ref.onValue.listen((event) {
      final String newData = event.snapshot.value.toString();
      setState(() {
        userRequires.add(newData); // 리스트에 데이터 추가
// 환자 ID를 포함하여 데이터베이스에 데이터 추가
        DatabaseHelper.instance.insertUserRequire(newData, patient.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final PatientController controller = Get.find();
    final patient = controller.searchResult.value!.first;
// final now = new DateTime.now();
    String formattedDate =
        DateFormat('yy.MM.dd - HH:mm').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 모아보기'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.getUserRequiresByPatientId(patient.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userRequires = snapshot.data!;
            return ListView.builder(
              itemCount: userRequires.length,
              itemBuilder: (context, index) {
                final data = userRequires[index]['data'];
                final timestamp = userRequires[index]['timestamp'];
                return ListTile(
                  leading: Text(patient.name,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  title: Text(data),
                  subtitle: Text(timestamp), // 데이터베이스에서 불러온 시간을 표시
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('데이터를 불러올 수 없습니다.');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
