import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';

// 정보 저장할 전체 기간으로 DateTime 타입 List 생성
final DateTime startDate = DateTime(2023, 1, 1);
final DateTime endDate = DateTime(2023, 12, 31);
int difference = int.parse(
    endDate.difference(startDate).inDays.toString());
List<DateTime> dateList = generateDateList();
//List.generate(difference, (index) => startDate.add(Duration(days: 1)));

// 오늘 날짜를 기준으로 좌우에 15개씩 아이템 생성하기 위해 List 생성
List<DateTime> items = List.generate(30, (index)
=> DateTime.now().add(Duration(days: index-15)));
DateTime currentDate = startDate;
int currentIndex = 0;
int currentItemIndex = 0;
//DateTime.parse(selectedDate);
String DayofWeek = getDayOfWeek(currentDate);


class MonthDay extends StatelessWidget {
  MonthDay({super.key});

  // index -> 오류발생 (임시 0처리)
  int index = items.indexOf(currentDate);
  @override
  Widget build(BuildContext context) {
    print(dateList);
    return Text('${items[0].month}월 ${items[0].day}일',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

String getDayOfWeek(DateTime date) {
  var dayofWeek = DateFormat('E').format(date);
  return dayofWeek;
}

List<DateTime> generateDateList() {
  List<DateTime> initialDateList = [];
  while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
    initialDateList.add(currentDate);
    currentDate = currentDate.add(Duration(days: 1));
  }
  return initialDateList;
}



class GenerateButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    currentDate = DateTime.now();
    currentIndex = dateList.indexOf(currentDate);
    currentItemIndex = items.indexOf(currentDate);
 //   String dayOfWeek = getDayOfWeek(date);
    //print(dateList.length);
    return Column(
      children: [
        Text ( DayofWeek,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5.0),
        Container(
          width: 55.0,
          height: 55.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 137, 182, 112),
          ),
          child: Container(
            child: IconButton(
              icon: Icon(Icons.check, color: Colors.white),
              onPressed: () {
                // 버튼을 눌렀을 때도 페이지가 넘어갈 수 있도록
              },
            ),
          ),
        ),
      ],
    );
  }
}

class LoadScreen extends StatefulWidget {
  const LoadScreen({Key? key}) : super(key: key);

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}


class _LoadScreenState extends State<LoadScreen> {

  // 날짜에 따라 하단 화면 갱신
  void  _loadScreen(){
    if (currentDate.isBefore(DateTime.now())) {
      return ;
      // 이전 날짜 데이터 기반으로 생성
      // 데이터 X = 복용한 약X으로 여백 or 데이터 O = 데이터가 있다면복용 상황)
    }
    else if (currentDate == DateTime.now()) {
      return ;
      // 당일 데이터
    }
    else if (currentDate.isAfter(DateTime.now())) {
      return ;
      // 이후 데이터
    }
  }

  @override
  void initState() {
    setState(() {

    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
