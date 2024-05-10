import 'package:dowajo/Patient/patient_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final PatientController controller = Get.find();
    final patient = controller.searchResult.value!.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 모아보기'),
      ),
      body: ListView.builder(
        itemCount: userRequires.length,
        itemBuilder: (context, index) {

          return ListTile(
            leading: Text(patient.name,style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                        fontWeight: FontWeight.w800),),
            title: Text(userRequires[index]),
            // subtitle: Text(DateTime as String), // 리스트의 각 항목을 표시
          );
        },
      ),
    );
  }
}
