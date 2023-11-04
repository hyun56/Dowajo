// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'medicine/medicine_add.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreen();
}

class _MedicineScreen extends State<MedicineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          _AppBar(),
          _WeeklyScroll(),
          _MedicineData(),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black,
            ),
          ),
          Expanded(
            flex: 10,
            child: Center(
                child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "알람",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Text("등록된 알람이 없어요\n  새로 추가할까요?"),
                ElevatedButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => medicine_add())),
                  child: Text("알람 추가하기+"),
                )
              ],
            )),
          )
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      title: Text('투여약', style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          // 메인 화면으로 돌아가기
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        },
      ),
    );
  }
}

class _WeeklyScroll extends StatelessWidget {
  const _WeeklyScroll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  var date = SelectedDate();
    return Flexible(
      // 날짜 정보 (설정 날짜, 슬라이드 위클리)
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 12.0),
              //child: MonthDay(), < 월/일 출력 함수
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 25.0,
              // weight: 300,
            ),
            SizedBox(
              height: 100.0,
              width: double.infinity,
              //child: InfiniteScrollButton() < 날짜 무한 스크롤 버튼
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicineData extends StatelessWidget {
  const _MedicineData();

  @override
  Widget build(BuildContext context) {
    return Flexible(
      // 복용 약 정보
      flex: 5,
      child: Container(
        color: Colors.grey,
        //LoadScreen(),
        // 날짜에 따라 화면 setState
      ),
    );
  }
}
