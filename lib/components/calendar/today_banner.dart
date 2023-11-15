import 'package:dowajo/components/models/medicine.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dowajo/database/medicine_database.dart';
import 'package:provider/provider.dart';

class TodayBanner extends StatefulWidget {
  final DateTime selectedDay;

  const TodayBanner({
    required this.selectedDay,
    Key? key,
  }) : super(key: key);

  @override
  _TodayBannerState createState() => _TodayBannerState();
}

class _TodayBannerState extends State<TodayBanner> {
  int remainingMedicineCount = 0;

  @override
  void initState() {
    super.initState();
    loadRemainingCount();
  }

  void loadRemainingCount() async {
    // int? remainingCount =
    //     await DatabaseHelper.instance.getRemainingMedicineCount();
    // setState(() {
    //   remainingMedicineCount = remainingCount ?? 0;
    // });
    String dayOfWeek = DateFormat('E', 'ko_KR').format(widget.selectedDay);
    int? remainingCount =
        await DatabaseHelper.instance.getRemainingMedicineCount(dayOfWeek);
    setState(() {
      remainingMedicineCount = remainingCount ?? 0;
    });
  }

  // @override
  // void didUpdateWidget(TodayBanner oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.selectedDay != oldWidget.selectedDay) {
  //     Provider.of<MedicineModel>(context, listen: false).updateMedicineData();
  //   }
  // }
  @override
  void didUpdateWidget(TodayBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDay != oldWidget.selectedDay) {
      // 선택한 요일을 인자로 전달
      Provider.of<MedicineModel>(context, listen: false)
          .updateMedicineData(widget.selectedDay.weekday);
    }
  }

  @override
  Widget build(BuildContext context) {
    const textStyle =
        TextStyle(fontWeight: FontWeight.w600, color: Colors.white);

    // Provider를 통해 상태를 가져옴
    var medicineModel = Provider.of<MedicineModel>(context);
    String dayOfWeek = DateFormat('E', 'ko_KR').format(widget.selectedDay);

    final medicineCount = medicineModel.allMedicines
        .where((medicine) => medicine.medicineDay.contains(dayOfWeek))
        .length;

    return Container(
      height: 40,
      color: const Color(0xFFA6CBA5),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${widget.selectedDay.year}년 ${widget.selectedDay.month}월 '
            '${widget.selectedDay.day}일',
            style: textStyle,
          ),
          Text(
            '남은 복용 일정  |  ${medicineModel.remainingMedicineCount} / $medicineCount 건',
            style: textStyle,
          ),
        ],
      ),
    );
  }
}

class MedicineModel extends ChangeNotifier {
  List<Medicine> allMedicines = [];
  int remainingMedicineCount = 0;
  int dayOfWeek = DateTime.now().weekday;

  // 숫자로 된 요일을 문자열로 바꾸는 함수
  String convertDayOfWeek(int dayOfWeek) {
    List<String> weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    return weekdays[dayOfWeek - 1];
  }

  void updateMedicineData(int selectedDayOfWeek) async {
    // dayOfWeek = DateTime.now().weekday; // dayOfWeek를 업데이트
    // String dayOfWeekStr = convertDayOfWeek(dayOfWeek); // 숫자로 된 요일을 문자열로 바꿈
    String dayOfWeekStr = convertDayOfWeek(selectedDayOfWeek);

    allMedicines = await DatabaseHelper.instance.getAllMedicines();

    // // 선택한 요일에 해당하는 약의 목록만 필터링하여 그 개수를 계산
    // remainingMedicineCount = allMedicines
    //     .where((medicine) => medicine.medicineDay.contains(dayOfWeekStr))
    //     .length;
    remainingMedicineCount = (await DatabaseHelper.instance
        .getRemainingMedicineCount(dayOfWeekStr))!;

    notifyListeners(); // 상태가 변경되었음을 알림
  }
}
