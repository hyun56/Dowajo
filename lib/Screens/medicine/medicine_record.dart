import 'package:dowajo/Screens/home_screen.dart';
import 'package:dowajo/Screens/medicine_screen.dart';
import 'package:flutter/material.dart';
import 'package:dowajo/components/models/medicine.dart';
import 'package:dowajo/database/medicine_database.dart';
import 'package:dowajo/components/calendar/calendar.dart';
import 'package:dowajo/components/calendar/schedule.dart';
import 'package:dowajo/components/calendar/today_banner.dart';
import 'package:intl/intl.dart';

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
        title: const Text('투여약', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
          const SizedBox(height: 15.0),
          TodayBanner(selectedDay: selectedDay),
          const SizedBox(height: 18.0),
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
        selectedItemColor: const Color(0xFFA6CBA5),
        onTap: (int index) {
          _onItemTapped(index);
          if (_currentIndex == 1 && index == 1) {
            return; // 이미 알람 화면이므로 아무것도 하지 않음
          } else {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MedicineScreen()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const medicineRecord()),
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

  // @override
  // Widget build(BuildContext context) {
  //   return ListView.separated(
  //       itemCount: 10,
  //       separatorBuilder: (context, index) {
  //         return SizedBox(height: 8.0);
  //       },
  //       itemBuilder: (context, index) {
  //         return ScheduleCard(
  //           scheduleTime: TimeOfDay(hour: 14, minute: 30),
  //           medicineName: "감기약",
  //         );
  //       });
  // }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseHelper.instance.getAllMedicines(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return const Center(child: Text('An error occurred!'));
        } else {
          String dayOfWeek = DateFormat('E', 'ko_KR').format(selectedDay);
          final medicineList = (snapshot.data as List<Medicine>)
              .where((medicine) => medicine.medicineDay.contains(dayOfWeek))
              .toList();
          return ListView.separated(
              itemCount: medicineList.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8.0);
              },
              itemBuilder: (context, index) {
                final time =
                    DateFormat.jm().parse(medicineList[index].medicineTime);
                final scheduleTime =
                    TimeOfDay(hour: time.hour, minute: time.minute);
                return ScheduleCard(
                  scheduleTime: scheduleTime,
                  medicineName: medicineList[index].medicineName,
                  id: medicineList[index].id!, onTakenUpdated: () {  },
                );
              });
        }
      },
    );
  }
}