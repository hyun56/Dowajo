import 'package:flutter/cupertino.dart';
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
        title: const Text(
          '환자 검색',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 50),
          const Text(
            '환자 고유번호를 입력해 주세요',
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                // labelText: '환자 고유번호 입력',
                contentPadding:
                    const EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 194, 193, 193),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFA6CBA5),
                    width: 1.5,
                  ),
                ),
              ),
              onSubmitted: (String value) {
                int? id = int.tryParse(value);
                if (id != null) {
                  controller.searchPatient(id);
                  // 검색 직후 결과를 확인하여 스낵바 표시
                  if (controller.searchResult.value == null ||
                      controller.searchResult.value!.isEmpty) {
                    Get.snackbar('알림', '환자 정보를 찾을 수 없습니다. 다시 확인해 주세요');
                  }
                } else {
                  Get.snackbar('오류', '올바른 고유번호를 입력해 주세요.');
                }
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.searchResult.value == null) {
                return const Center(
                    //child: Text('환자 정보를 입력해 주세요.'),
                    );
              } else if (controller.searchResult.value!.isEmpty) {
                // 검색 결과가 없을 때 알림 표시 로직을 제거
                return const SizedBox(); // 검색 결과가 없을 때 비어있는 화면을 보여줍니다.
              } else {
                final patient = controller.searchResult.value!.first;
                return Column(
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Color.fromARGB(255, 194, 193, 193),
                              thickness: 1.5,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '조회된 환자 정보입니다',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color.fromARGB(255, 186, 186, 186),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Color.fromARGB(255, 194, 193, 193),
                              thickness: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          Text(
                            patient.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '고유번호 : ${patient.id}',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 40, horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(() =>
                                        const HomeScreen()); // 환자 정보와 함께 HomeScreen으로 이동합니다.
                                  },
                                  child: Container(
                                    width: 190,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFA6CBA5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '해당 환자로 이동하기',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          CupertinoIcons.arrow_right_circle,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
                // ListTile(
                //   title: Text(patient.name),
                //   subtitle: Text('고유번호: ${patient.id}'),
                //   onTap: () {
                //     Get.to(() =>
                //         const HomeScreen()); // 환자 정보와 함께 HomeScreen으로 이동합니다.
                //   },
                // );
              }
            }),
          ),
        ],
      ),
    );
  }
}
