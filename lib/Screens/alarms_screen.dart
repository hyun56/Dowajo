import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AlarmsScreen extends StatefulWidget {
  const AlarmsScreen({Key? key}) : super(key: key);

  @override
  _AlarmsScreenState createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  String patientId = "11"; // 예시 환자 ID, 필요에 따라 조정
  late DatabaseReference ref;
  List<String> userRequires = []; // 데이터 변경을 기록할 리스트

  @override
  void initState() {
    super.initState();
    ref = database.ref().child(patientId).child('userRequire');

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 모아보기'),
      ),
      body: ListView.builder(
        itemCount: userRequires.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(userRequires[index]), // 리스트의 각 항목을 표시
          );
        },
      ),
    );
  }
}
