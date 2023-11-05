// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dowajo/components/models/medicine.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'medicine/medicine_add.dart';

import 'package:dowajo/database/medicine_database.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreen();
}

class _MedicineScreen extends State<MedicineScreen> {
  var dbHelper = DatabaseHelper.instance;
  late Future<List<Medicine>> futureMedicines;

  @override
  void initState() {
    super.initState();
    futureMedicines = dbHelper.getAllMedicines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          _AppBar(),
          //_WeeklyScroll(),
          //_MedicineData(),r

          Expanded(
            flex: 10,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "알람",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Medicine>>(
                    future: futureMedicines, // 데이터베이스에서 모든 약 정보를 가져오는 Future
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Medicine>> snapshot) {
                      // Future가 완료되었을 때
                      if (snapshot.connectionState == ConnectionState.done) {
                        // 에러가 발생했을 때
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        // 데이터가 없을 때
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Column(
                            children: [
                              Text("등록된 알람이 없어요\n새로 추가할까요?"),
                              ElevatedButton(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => medicine_add()),
                                  );
                                  setState(() {
                                    futureMedicines =
                                        dbHelper.getAllMedicines();
                                  });
                                },
                                child: Text("알람 추가하기+"),
                              ),
                            ],
                          );
                        }

                        // 데이터가 있을 때
                        List<Medicine>? medicines = snapshot.data;
                        return ListView.builder(
                          itemCount: medicines!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(medicines[index].medicineName),
                              subtitle: Text(
                                  '복용 일자: ${medicines[index].medicineDay}, 반복: ${medicines[index].medicineRepeat}'),
                              leading: Image.file(
                                  File(medicines[index].medicinePicture)),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('선택해주세요'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('수정하기'),
                                          onPressed: () {
                                            // 수정하기 기능 구현
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('삭제하기'),
                                          onPressed: () async {
                                            // id가 null인지 확인
                                            if (medicines[index].id != null) {
                                              // id가 null이 아니라면 삭제
                                              await DatabaseHelper.instance
                                                  .delete(medicines[index].id!);

                                              // 삭제가 완료되면 FutureBuilder를 다시 빌드
                                              setState(() {
                                                futureMedicines =
                                                    dbHelper.getAllMedicines();
                                              });
                                            }
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('닫기'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      }

                      // Future가 아직 완료되지 않았을 때
                      return CircularProgressIndicator(); // 로딩 인디케이터 표시
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (_) => medicine_add()),
      //     );
      //     setState(() {
      //       futureMedicines = dbHelper.getAllMedicines();
      //     });
      //   },
      //   child: Icon(Icons.add),
      // ),
      floatingActionButton: FutureBuilder<List<Medicine>>(
        future: futureMedicines,
        builder:
            (BuildContext context, AsyncSnapshot<List<Medicine>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return FloatingActionButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => medicine_add()),
                  );
                  setState(() {
                    futureMedicines = dbHelper.getAllMedicines();
                  });
                },
                child: Icon(Icons.add),
              );
            } else {
              return Container(); // 데이터가 없으면 빈 컨테이너를 반환하여 버튼을 표시하지 않음
            }
          }
          return Container(); // Future가 아직 완료되지 않았을 때도 빈 컨테이너를 반환하여 버튼을 표시하지 않음
        },
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      title: Text('투여약', style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          // 메인 화면으로 돌아가기
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        },
      ),
    );
  }
}
