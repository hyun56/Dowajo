import 'package:flutter/material.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDay;

  TodayBanner({
    required this.selectedDay,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle =
        TextStyle(fontWeight: FontWeight.w600, color: Colors.white);
    return Container(
      height: 40,
      color: Colors.lightGreen,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${selectedDay.year}년 ${selectedDay.month}월 '
            '${selectedDay.day}일',
            style: textStyle,
          ),
          Text(
            '남은 복용 일정 | 5건',
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
