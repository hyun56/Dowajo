// ignore_for_file: camel_case_types, prefer_const_constructors

import 'dart:io';

import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';

class medicine_add extends StatefulWidget {
  const medicine_add({Key? key}) : super(key: key);

  @override
  State<medicine_add> createState() => _medicine_addState();
}

class _medicine_addState extends State<medicine_add> {
  get name => null;
  XFile? _pickedFile;
  @override
  Widget build(BuildContext context) {
    final _imageSize = MediaQuery.of(context).size.width / 4;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
//상단Appbar
          AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),

// 상단 안내문
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Icon(
                  Icons.medication,
                  color: Colors.red,
                  size: 35.0,
                ),
              ),
              Text(
                "어떤 약을 드시나요?",
                style: TextStyle(
                  fontSize: 20.0, // 글자크기
                  //fontStyle: FontStyle.italic, // 이텔릭체
                  fontWeight: FontWeight.bold, // 볼드체
                  color: Colors.black, // 색상
                  letterSpacing: 3.0, // 자간
                ),
              ),
            ],
          ),

//사진등록
          Row(
            children: const [
              Text(
                "\n\t\t복용하는 약의 사진을 등록하세요",
                style: TextStyle(
                  fontSize: 15.0, // 글자크기

                  fontWeight: FontWeight.bold, // 볼드체
                  color: Colors.black, // 색상
                  letterSpacing: 3.0, // 자간
                ),
              ),
            ],
          ),

          // Row( //카메라 아이콘 좌로 정렬할지 
          // children: [

          const SizedBox(
            height: 20,
          ),
          if (_pickedFile == null)
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
          //   ],
          //  ),

//약 이름 입력창
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text(
                "\n\t\t약의 이름을 입력하세요",
                style: TextStyle(
                  fontSize: 15.0, // 글자크기
                  //fontStyle: FontStyle.italic, // 이텔릭체
                  fontWeight: FontWeight.bold, // 볼드체
                  color: Colors.black, // 색상
                  letterSpacing: 3.0, // 자간
                ),
              ),
            ],
          ),

          SizedBox(
            width: 40,
          ),
          Container(
            child: new Flexible(
              child: new TextField(
                //입력창
                controller: name,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            width: 350, //TextField 크기
          ),

         
          
//요일설정
        Row(
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
                  letterSpacing: 3.0, // 자간
                ),
              ),
            ],
          ),

//알람 추가 버튼          
   Align(
            alignment: Alignment.topCenter,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => medicine_add())),
              child: Text("알람 추가하기+"),
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
}
