// ignore_for_file: camel_case_types, prefer_const_constructors

import "package:flutter/material.dart";

class medicine_add extends StatefulWidget{
  const medicine_add({Key? key}) : super(key: key);

  @override
  State<medicine_add> createState() => _medicine_addState();
}

class _medicine_addState extends State<medicine_add> {
  get name => null;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
              color: Colors.black
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Icon(
              Icons.medication,
              color: Colors.red,
              size: 50.0,
            ),
          ),
          Text(
            "어떤 약을 드시나요?",
            style: TextStyle(
              fontSize: 20.0, // 글자크기
              //fontStyle: FontStyle.italic, // 이텔릭체
              fontWeight: FontWeight.bold, // 볼드체
              color: Colors.black, // 색상
              letterSpacing: 4.0, // 자간
            ),
          ),
          Text(
            "복용하는 약의 사진을 등록하세요",
            style: TextStyle(
              fontSize: 15.0, // 글자크기
              //fontStyle: FontStyle.italic, // 이텔릭체
              fontWeight: FontWeight.bold, // 볼드체
              color: Colors.black, // 색상
              letterSpacing: 4.0, // 자간
            ),
          ),

      




          Text(
            "약의 이름을 입력하세요",
            style: TextStyle(
              fontSize: 15.0, // 글자크기
              //fontStyle: FontStyle.italic, // 이텔릭체
              fontWeight: FontWeight.bold, // 볼드체
              color: Colors.black, // 색상
              letterSpacing: 4.0, // 자간
            ),
          ),
          Row(
             children: <Widget>[

                SizedBox(width: 40,),
                Container(
                  child: new Flexible(
                    child: new TextField(
                      controller: name,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  width: 300, //TextField 크기
                ),
              ],
          ),
          
         
         Align(
           alignment: Alignment.topCenter,
           child : ElevatedButton(onPressed: ()=>Navigator.push(context,MaterialPageRoute(builder: (_)=>medicine_add())),
             child: Text("알람 추가하기+"),

           ),
         )


        ],
      ),
      );

  }
}