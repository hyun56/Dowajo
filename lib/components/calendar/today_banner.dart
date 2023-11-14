import 'package:dowajo/components/models/medicine.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dowajo/database/medicine_database.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDay;

  const TodayBanner({
    required this.selectedDay,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle =
        TextStyle(fontWeight: FontWeight.w600, color: Colors.white);

    return FutureBuilder(
      future: Future.wait([
        DatabaseHelper.instance.getAllMedicines(),
        DatabaseHelper.instance.getRemainingMedicineCount()
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return const Center(child: Text('An error occurred!'));
        } else if (snapshot.data != null) {
          String dayOfWeek = DateFormat('E', 'ko_KR').format(selectedDay);
          List<Medicine> allMedicines = snapshot.data![0] as List<Medicine>;
          int remainingMedicineCount = snapshot.data![1] as int;

          final medicineCount = allMedicines
              .where((medicine) => medicine.medicineDay.contains(dayOfWeek))
              .length;

          return Container(
            height: 40,
            color: const Color(0xFFA6CBA5),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedDay.year}년 ${selectedDay.month}월 '
                  '${selectedDay.day}일',
                  style: textStyle,
                ),
                Text(
                  '남은 복용 일정  |  $remainingMedicineCount / $medicineCount 건',
                  style: textStyle,
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
