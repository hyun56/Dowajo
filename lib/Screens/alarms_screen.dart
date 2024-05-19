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
  controller = Get.find();
  patientId = controller.searchResult.value!.first.id;
  ref = database.ref().child(patientId).child('userRequire');
  _subscription?.cancel();

  _subscription = ref.onValue.listen((event) async {
    final data = event.snapshot.value;
    if (data != null) {
      String timestamp = DateFormat('yy.MM.dd - HH:mm:ss').format(DateTime.now());

      // 새로운 데이터를 리스트에 추가
      userRequires.add(data.toString());

      // Firebase에 새로운 데이터 추가
      DatabaseReference newRef = database.ref('userRequires/$patientId');
      await newRef.push().set({'data': data, 'timestamp': timestamp});

      setState(() {});
    }
  });
}

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller = Get.find();
    patientId = controller.searchResult.value!.first.id;
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 모아보기'),
      ),
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

            return ListView.builder(
              itemCount: userRequires.length,
              itemBuilder: (context, index) {
                final data = userRequires[index]['data'];
                final timestamp = userRequires[index]['timestamp'];
                return ListTile(
                  leading: Text(controller.searchResult.value!.first.name,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  title: Text(data),
                  subtitle: Text(timestamp),
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
