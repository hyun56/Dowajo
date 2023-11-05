// ignore_for_file: camel_case_types, prefer_const_constructors

import 'dart:io';

import 'package:dowajo/Screens/medicine_screen.dart';
import 'package:dowajo/components/weekday_buttons.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import '../../components/models/medicine.dart';
import 'package:dowajo/database/medicine_database.dart';

class medicine_add extends StatefulWidget {
  const medicine_add({Key? key}) : super(key: key);
  
  @override
  State<medicine_add> createState() => _medicine_addState();
}

class _medicine_addState extends State<medicine_add> {
  final valueList = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  var selectedRepeat = '1';
  // get name => null;
  XFile? _pickedFile;
  // var isOn = false;
  DateTime dateTime = DateTime.now();    
  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController _medicineNameController = TextEditingController();
  List<String> selectedDays = []; // 선택된 요일을 저장하는 리스트
  
  void _showTimePicker() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (newTime != null) {
      setState(() {
        selectedTime = newTime;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          topMessage(), // 상단 안내문
          addPhoto(), //사진등록
          medicineName(), //약 이름 입력창
          textWeekday(), //요일설정
          WeekdayButtons(
            onSelectedDaysChanged: (days) {
              // 선택된 요일을 medicineDay에 저장
              setState(() {
                selectedDays = days;
              });
            },
          ), // 요일설정 - 스위치, 월 ~ 일 선택버튼
          numOfTitle(), // 복용횟수- 타이틀
          numOfTakeMedicine(), // 복용횟수 - 횟수 설정
        //복용시간 추가
        addTime(),

          //알람 추가 버튼
         addAlram(),

        ],
      ),
    );
  }

  //카메라 설정
  _showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => _getCameraImage(),
              child: const Text('사진찍기'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 3,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => _getPhotoLibraryImage(),
              child: const Text('라이브러리에서 불러오기'),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }

  _getCameraImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  _getPhotoLibraryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = _pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  Widget topMessage() {
    return Row(
      children: const [
        Icon(
          Icons.medication,
          color: Colors.red,
          size: 35.0,
        ),
        Text(
          "어떤 약을 드시나요?",
          style: TextStyle(
            fontSize: 20.0, // 글자크기
            fontWeight: FontWeight.bold, // 볼드체
            color: Colors.black, // 색상
            //  letterSpacing: 2.0, // 자간
          ),
        ),
      ],
    );
  }

  Widget addPhoto() {
    // ignore: unused_local_variable
    final imageSize = MediaQuery.of(context).size.width / 4;

    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "\n\t\t복용하는 약의 사진을 등록하세요",
            style: TextStyle(
              fontSize: 15.0, // 글자크기
              color: Colors.black, // 색상
              //letterSpacing: 2.0, // 자간
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        if (_pickedFile == null)
          Container(
            constraints: BoxConstraints(
              minHeight: imageSize,
              minWidth: imageSize,
            ),
            child: GestureDetector(
              onTap: () {
                _showBottomSheet();
              },
              child: Center(
                child: Icon(
                  Icons.photo_camera,
                  size: imageSize,
                ),
              ),
            ),
          )
        else
          Center(
            child: Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 2, color: Theme.of(context).colorScheme.primary),
                image: DecorationImage(
                    image: FileImage(File(_pickedFile!.path)),
                    fit: BoxFit.cover),
              ),
            ),
          ),
      ],
    );
  }

  Widget medicineName() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "\n\t\t약의 이름을 입력하세요",
            style: TextStyle(
              fontSize: 15.0, // 글자크기
              color: Colors.black, // 색상
              // letterSpacing: 2.0, // 자간
            ),
          ),
        ),
        SizedBox(
          width: 40,
        ),
        SizedBox(
          width: 350, // TextField 크기
          child: Flexible(
            child: TextField(
              controller: _medicineNameController,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }

  Widget textWeekday() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Icon(
            Icons.calendar_month,
            color: const Color.fromARGB(255, 82, 77, 77),
            size: 35.0,
          ),
        ),
        Text(
          "\t요일을 선택하세요",
          style: TextStyle(
            fontSize: 20.0, // 글자크기
            //fontStyle: FontStyle.italic, // 이텔릭체
            fontWeight: FontWeight.bold, // 볼드체
            color: Colors.black, // 색상
            // letterSpacing: 2.0, // 자간
          ),
        ),
      ],
    );
  }

  Widget numOfTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Icon(
            Icons.schedule,
            color: const Color.fromARGB(255, 82, 77, 77),
            size: 35.0,
          ),
        ),
        Text(
          "\t하루에 몇 번 복용하세요?",
          style: TextStyle(
            fontSize: 20.0, // 글자크기
            //fontStyle: FontStyle.italic, // 이텔릭체
            fontWeight: FontWeight.bold, // 볼드체
            color: Colors.black, // 색상
            // letterSpacing: 2.0, // 자간
          ),
        ),
      ],
    );
  }

  Widget numOfTakeMedicine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton(
          value: selectedRepeat,
          items: valueList.map(
            (value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
          onChanged: (value) {
            setState(() {
              if (value != null) selectedRepeat = value;
            });
          },
        ),
        Text("회"),
      ],
    );
  }

  Widget addTime(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
            Text('복용시간'),
            TextButton(
              onPressed: () {
                _showTimePicker(); // 버튼을 누를 때 텍스트 업데이트
              },
              child: Text('${selectedTime.format(context)}'),
            ),
      ],
    );
  }

  Widget addAlram(){
     return SizedBox(
            width: 1000,
            height: 40,
            child: Align(
              alignment: Alignment.topCenter,
              child: ElevatedButton(
                // onPressed: () => Navigator.push(
                //     context, MaterialPageRoute(builder: (_) => medicine_add())),
                onPressed: () {
                  Medicine newMedicine = Medicine(
                    medicineName: _medicineNameController.text,
                    medicinePicture: _pickedFile?.path ?? '',
                    medicineDay: selectedDays
                        .join(','), // selectedDays 리스트를 문자열로 변환하여 저장
                    medicineRepeat: int.parse(selectedRepeat), // 복용 횟수에 해당하는 값
                    //medicineTime: selectedTime, // 시간에 해당하는 값
                  );
                  Navigator.of(context).pop(newMedicine); // 현재 화면 닫고, 이전 화면으로
                },
                child: Text("알람 추가하기"),
              ),
            ),
          );
  }
}
 

