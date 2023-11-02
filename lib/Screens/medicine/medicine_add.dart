// ignore_for_file: camel_case_types, prefer_const_constructors

import 'dart:io';

import 'package:dowajo/components/weekday_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';

class medicine_add extends StatefulWidget {
  const medicine_add({Key? key}) : super(key: key);

  @override
  State<medicine_add> createState() => _medicine_addState();
}

class _medicine_addState extends State<medicine_add> {
  final valueList = ['1', '2', '3','4','5','6','7','8','9','10'];
  var selectedValue = '1';
  get name => null;
  XFile? _pickedFile;
  var isOn = false;

  @override
  Widget build(BuildContext context) {
    
   
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        
      children: <Widget>[
          
//상단Appbar
          AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),

// 상단 안내문
topMessage(),

//사진등록
addPhoto(),

//약 이름 //입력창
medicine_name(),      


//요일설정
textWeekday(),         

///요일설정 - 스위치,  월 ~ 일 선택버튼
 WeekdayButtons(), 
               

//복용횟수- 타이틀
  numOf_title(),    


//복용횟수 - 횟수 설정
  numOfTakeMedicine(), 


///복용횟수 - 시간 설정






//알람 추가 버튼
          SizedBox(
            width: 1000,
            height: 40,
            child: Align(
              alignment: Alignment.topCenter,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => medicine_add())),
                child: Text("알람 추가하기+"),
              ),
            ),
          ),
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

Widget topMessage(){
 return Row(

              children : [
                Icon(   Icons.medication,
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

Widget addPhoto(){
  // ignore: unused_local_variable
  final _imageSize = MediaQuery.of(context).size.width / 4;

  return Column(children: [
     Align(
      alignment : Alignment.topLeft,
              child : Text(  "\n\t\t복용하는 약의 사진을 등록하세요",
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
          if(_pickedFile == null)
             Container(
              constraints: BoxConstraints(
                minHeight: _imageSize,
                minWidth: _imageSize,
              ),
              child: GestureDetector(
                onTap: () {
                  _showBottomSheet();
                },
                child: Center(
                  child: Icon(
                    Icons.photo_camera,
                    size: _imageSize,
                  ),
                ),
              ),
            )
          else
            Center(
              child: Container(
                width: _imageSize,
                height: _imageSize,
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

Widget medicine_name(){
  return
      Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:[
            Align(
              alignment : Alignment.centerLeft,
              child: Text(  "\n\t\t약의 이름을 입력하세요",
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
          Container(
            child: new Flexible(
              child: new TextField(
                controller: name,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            width: 350, //TextField 크기
          ),
            ],
          
     
          );
}

Widget textWeekday(){
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

Widget buildWeekdayButtons() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final buttonSize = constraints.maxWidth / 8; // 버튼의 크기를 조절
        final buttonGap = buttonSize / 8; // 버튼 간의 여백을 설정
        return Container(
          width: constraints.maxWidth,
          height: 136,
          child: Stack(
            children:
                ['일', '월', '화', '수', '목', '금', '토'].asMap().entries.map((e) {
              return Positioned(
                left: buttonGap +
                    (buttonSize + buttonGap) *
                        e.key, // 버튼 간의 여백과 왼쪽, 오른쪽 여백을 추가
                top: 20,
                child: SizedBox(
                  width: buttonSize,
                  height: buttonSize,
                  child: ElevatedButton(
                    onPressed: () {
                      print("${e.value} 버튼이 클릭되었습니다."); // 임시
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFFA6CBA5)),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Text(
                      e.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

Widget numOf_title(){
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

Widget numOfTakeMedicine(){
   return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
    
                value: selectedValue,
    
                items: valueList.map((value) {
    
                  return DropdownMenuItem(
    
                    value: value,
    
                    child: Text(value),
    
                  );
    
                },).toList(),
    
                onChanged: (value) {
    
                  setState(() {
    
                    if(value != null)
    
                      selectedValue = value as String;
    
                  });
    
                },
    
              ),
              Text("회"),
          ],
        );   
}

}
