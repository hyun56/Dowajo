import 'package:dowajo/Screens/home_screen.dart';
import 'package:dowajo/Screens/medicine_screen.dart';
import 'package:flutter/material.dart';

class medicineRecord extends StatefulWidget {
  const medicineRecord({super.key});

  @override
  State<medicineRecord> createState() => _medicineRecordState();
}

class _medicineRecordState extends State<medicineRecord> {
  int _currentIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text(
            'test',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blue, fontSize: 56),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm, size: 25),
            label: '알람',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: '기록',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          _onItemTapped(index);
          if (_currentIndex == 1 && index == 1) {
            return; // 이미 알람 화면이므로 아무것도 하지 않음
          } else {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MedicineScreen()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => medicineRecord()),
                );
                break;
            }
          }
        },
      ),
    );
  }
}
