import 'package:dowajo/Patient/patient_controller.dart';
import 'package:dowajo/Screens/macro_screen.dart';
import 'package:dowajo/Screens/patient_search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/menu_item.dart';
import 'medicine_screen.dart';
import 'alarms_screen.dart';
import 'inject_screen.dart';

class HomeScreen extends StatelessWidget {
  final PatientController controller = Get.put(PatientController());

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PatientController controller = Get.find();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 235, 238, 240),
        //backgroundColor: Color.fromARGB(255, 219, 225, 228),
        appBar: AppBar(
          automaticallyImplyLeading: false, //자동으로 생성되는 뒤로가기 제거
          backgroundColor: Colors.transparent,
          title: const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              "도와조",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                controller.searchResult.value = null;
                Get.offAll(() => const PatientSearchScreen());
                // 메인 화면으로 돌아가기
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const PatientSearchScreen()));
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //SizedBox(height: 15),
                // buildLogo(),
                buildHeading(),
                buildMenu1(context),
                buildMenu2(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildHeading() {
    final patient = controller.searchResult.value!.first;
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 25, left: 5, right: 5),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 214, 212, 212), // 그림자 색상
              spreadRadius: 0, // 그림자 확산 정도
              blurRadius: 3, // 그림자 흐림 정도
              offset: Offset(0, 0), // 그림자 위치 (가로, 세로)
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 14.0, right: 14.0, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '환자 정보',
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10), // 모서리를 둥글게 하는 정도
                    child: Image.network(
                      patient.picture,
                      fit: BoxFit.cover,
                      height: 150,
                      width: 110,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${patient.name}(${patient.gender})',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 98, 98, 98),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '생년월일: ',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          patient.birth,
                          style:
                              const TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '병명: ',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          patient.disease,
                          style:
                              const TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '병실: ',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${patient.room}',
                          style:
                              const TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  SizedBox buildMenu1(BuildContext context) {
    return SizedBox(
      height: 168,
      width: 323,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MenuItem(
            text: "주사",
            icon: CupertinoIcons.heart_circle_fill,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const InjectScreen()));
            },
            iconColor: const Color.fromARGB(255, 241, 161, 161),
          ),
          const SizedBox(width: 23),
          MenuItem(
            text: "투여약",
            icon: Icons.medication,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MedicineScreen()));
            },
            iconColor: const Color.fromARGB(255, 137, 182, 112),
          ),
        ],
      ),
    );
  }

  SizedBox buildMenu2(BuildContext context) {
    return SizedBox(
      height: 168,
      width: 323,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MenuItem(
            text: "전체 알림",
            icon: CupertinoIcons.bell_circle_fill,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MacroScreen()));
            },
            iconColor: const Color.fromARGB(255, 113, 161, 183),
          ),
          const SizedBox(width: 23),
          MenuItem(
            text: "개별 알림",
            icon: CupertinoIcons.bell_circle_fill,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AlarmsScreen()));
            },
            iconColor: const Color.fromARGB(255, 249, 196, 150),
          ),
        ],
      ),
    );
  }
}
