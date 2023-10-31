// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'medicine/medicine_add.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreen();
}

class _MedicineScreen extends State<MedicineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.black,
          ),
      ),
        Expanded(
            flex: 3,
            child:Center(
              child: Column(
                children: [
                 Align(
                  alignment:Alignment.topLeft,
                  child:Text("알람",
                  style: TextStyle(fontSize: 20, 
                  fontWeight: FontWeight.bold,
                  color:Colors.black),
                  ),
                 ),
                  SizedBox(
                    height :100,
                  ),
                  Text("등록된 알람이 없어요\n  새로 추가할까요?"),
                  ElevatedButton(onPressed: ()=>Navigator.push(context,MaterialPageRoute(builder: (_)=>medicine_add())),
                    child: Text("알람 추가하기+"),
                  )
                ],
              )
            ),
          )
        ],
      ),
    );
  }
}
