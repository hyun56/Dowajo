import 'package:dowajo/Screens/home_screen.dart';
import 'package:dowajo/Screens/medicine_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dowajo/components/models/medicine.dart';
import 'package:dowajo/database/medicine_database.dart';
import 'package:dowajo/components/calendar/calendar.dart';
import 'package:dowajo/components/calendar/schedule.dart';
import 'package:dowajo/components/calendar/today_banner.dart';
import 'package:sqflite/sqflite.dart';

class medicineRecord extends StatefulWidget {
  const medicineRecord({super.key});

  @override
  State<medicineRecord> createState() => _medicineRecordState();
}

class _medicineRecordState extends State<medicineRecord> {
  int _currentIndex = 1;

  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  onDaySelected(DateTime focusedDay, DateTime selectedDay) {
    setState(() {
      this.focusedDay = selectedDay;
      this.selectedDay = selectedDay;
    });
  }

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Calendar(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              onDaySelected: onDaySelected),
          SizedBox(height: 5.0),
          TodayBanner(selectedDay: selectedDay),
          SizedBox(height: 5.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ScheduleCardListViewer(selectedDay: selectedDay),
            ),
          )
        ],
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

class ScheduleCardListViewer extends StatelessWidget {
  final DateTime selectedDay;
  const ScheduleCardListViewer({super.key, required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: 10,
        separatorBuilder: (context, index) {
          return SizedBox(height: 8.0);
        },
        itemBuilder: (context, index) {
          return ScheduleCard(
            scheduleTime: TimeOfDay(hour: 14, minute: 30),
            medicineName: "감기약",
          );
        });
  }
}
