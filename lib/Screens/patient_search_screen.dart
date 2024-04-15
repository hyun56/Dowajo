import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dowajo/Patient/patient_controller.dart';
import 'home_screen.dart'; 

class PatientSearchScreen extends StatelessWidget {
  final PatientController controller = Get.put(PatientController());

  PatientSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('환자 검색'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '환자 고유번호 입력',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (String value) {
                int? id = int.tryParse(value);
                if (id != null) {
                  controller.searchPatient(id);
                  // 검색 직후 결과를 확인하여 스낵바 표시
                  if (controller.searchResult.value == null ||
                      controller.searchResult.value!.isEmpty) {
                    Get.snackbar('알림', '환자정보를 찾을 수 없습니다. 다시 확인해주세요');
                  }
                } else {
                  Get.snackbar('오류', '올바른 고유번호를 입력해주세요.');
                }
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.searchResult.value == null) {
                return const Center(child: Text('환자 정보를 입력해 주세요.'));
              } else if (controller.searchResult.value!.isEmpty) {
                // 검색 결과가 없을 때 알림 표시 로직을 제거
                return const SizedBox(); // 검색 결과가 없을 때 비어있는 화면을 보여줍니다.
              } else {
                final patient = controller.searchResult.value!.first;
                return ListTile(
                  title: Text(patient.name),
                  subtitle: Text('고유번호: ${patient.id}'),
                  onTap: () {
                    Get.to(() => const HomeScreen()); // 환자 정보와 함께 HomeScreen으로 이동합니다.
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
