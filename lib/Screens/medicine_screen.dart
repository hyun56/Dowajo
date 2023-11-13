// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dowajo/Screens/medicine/medicine_record.dart';
import 'package:dowajo/Screens/medicine/medicine_update.dart';
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
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    futureMedicines = dbHelper.getAllMedicines();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      "알람",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
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
                              Spacer(flex: 1),
                              Text(
                                "등록된 알람이 없어요",
                                style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      const Color.fromARGB(255, 123, 123, 123),
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                "새로운 알람을 추가할까요?",
                                style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      const Color.fromARGB(255, 123, 123, 123),
                                ),
                              ),
                              SizedBox(height: 12),
                              SizedBox(
                                width: 210,
                                child: ElevatedButton(
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
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xFFA6CBA5)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    elevation:
                                        MaterialStateProperty.all<double>(0),
                                  ),
                                  child: Text(
                                    "알람 추가하기 +",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(flex: 2),
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
                                  '복용 일자: ${medicines[index].medicineDay}, 복용 시간: ${medicines[index].medicineTime}'),
                              leading: Image.file(
                                  File(medicines[index].medicinePicture)),
                              onTap: () {
                                showModalBottomSheet(
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
                                        const SizedBox(height: 15),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    medicineUpdate(
                                                        medicine:
                                                            medicines[index]),
                                              ),
                                            ).then((_) {
                                              // 수정 페이지에서 돌아온 후
                                              setState(() {
                                                // 화면을 갱신
                                                futureMedicines =
                                                    dbHelper.getAllMedicines();
                                              });
                                            });
                                            /*Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MedicineUpdatePage()),
                                            );*/
                                            // 수정하기 기능 구현
                                            // Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor: Colors.transparent,
                                            minimumSize: Size(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                60),
                                          ),
                                          child: const Text('수정하기'),
                                        ),
                                        const SizedBox(height: 5),
                                        const Divider(thickness: 4),
                                        const SizedBox(height: 10),
                                        ElevatedButton(
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
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor: Colors.transparent,
                                            minimumSize: Size(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                60),
                                          ),
                                          child: const Text('삭제하기'),
                                        ),
                                        const SizedBox(height: 10),
                                        const Divider(thickness: 4),
                                        const SizedBox(height: 5),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor: Colors.transparent,
                                            minimumSize: Size(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                60),
                                          ),
                                          child: const Text('닫기'),
                                        ),
                                        const SizedBox(height: 18),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                child: Image.asset(
                  'repo/icons/plus.png', // Image asset 사용
                  //width: 24.0, // 원하는 너비로 조절
                  //height: 24.0, // 원하는 높이로 조절
                ),
              );
            } else {
              return Container(); // 데이터가 없으면 빈 컨테이너를 반환하여 버튼을 표시하지 않음
            }
          }
          return Container(); // Future가 아직 완료되지 않았을 때도 빈 컨테이너를 반환하여 버튼을 표시하지 않음
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm, size: 25),
            label: '알람',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: '기록',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          _onItemTapped(index);
          if (_currentIndex == 0 && index == 0) {
            return; // 이미 알람 화면이므로 아무것도 하지 않음
          } else {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MedicineScreen()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => medicineRecord()),
                );
                break;
            }
          }
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
