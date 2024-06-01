// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dowajo/components/models/injectModel.dart';
import 'package:dowajo/database/inject_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home_screen.dart';
import 'inject/inject_add.dart';
import 'inject/inject_update.dart';

List<String> weekDays = ['일', '월', '화', '수', '목', '금', '토'];
Map<String, int> weekDayToNumber = {
  '일': 1,
  '월': 2,
  '화': 3,
  '수': 4,
  '목': 5,
  '금': 6,
  '토': 7,
};

class InjectScreen extends StatefulWidget {
  const InjectScreen({super.key});

  @override
  State<InjectScreen> createState() => _InjectScreenState();
}

class _InjectScreenState extends State<InjectScreen> {
  var dbHelper = InjectDatabaseHelper.instance;
  late Future<List<InjectModel>> futureInjects;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    futureInjects = dbHelper.getAllInjects();
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
          SizedBox(height: 8),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder<List<InjectModel>>(
                    future: futureInjects,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<InjectModel>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Column(
                            children: [
                              Spacer(flex: 1),
                              Text(
                                "등록된 주사가 없어요",
                                style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      const Color.fromARGB(255, 123, 123, 123),
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                "새로운 주사를 추가할까요?",
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
                                          builder: (_) => inject_add()),
                                    );
                                    setState(() {
                                      futureInjects = dbHelper.getAllInjects();
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
                                    "주사 추가하기 +",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(flex: 1),
                            ],
                          );
                        }

                        List<InjectModel>? injects = snapshot.data;

                        injects!.sort((a, b) {
                          final aTime =
                              DateFormat.jm().parse(a.injectStartTime);
                          final bTime =
                              DateFormat.jm().parse(b.injectStartTime);
                          return aTime.compareTo(bTime);
                        });

                        return SingleChildScrollView(
                          child: _buildInjectList(injects),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FutureBuilder<List<InjectModel>>(
        future: futureInjects,
        builder:
            (BuildContext context, AsyncSnapshot<List<InjectModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: FloatingActionButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => inject_add()),
                    );
                    setState(() {
                      futureInjects = dbHelper.getAllInjects();
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  child: Image.asset(
                    'repo/icons/plus.png',
                  ),
                ),
              );
            } else {
              return Container();
            }
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildInjectList(List<InjectModel> injects) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(injects.length, (index) {
          return Column(
            children: [
              _buildInjectItem(injects[index]),
              if (index < injects.length - 1)
                Column(
                  children: const [
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        color: Color.fromARGB(255, 236, 236, 236),
                        thickness: 2.0,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildInjectItem(InjectModel inject) {
    final dt = DateFormat.jm().parse(inject.injectEndTime);
    final newFormat = DateFormat('a h:mm', 'ko_KR');
    final koreanTime = newFormat.format(dt);

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
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
                        builder: (context) => injectUpdate(inject: inject),
                      ),
                    ).then((_) {
                      Navigator.of(context).pop();
                      setState(() {
                        futureInjects = dbHelper.getAllInjects();
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    minimumSize: Size(MediaQuery.of(context).size.width, 60),
                  ),
                  child: const Text('수정하기'),
                ),
                const SizedBox(height: 5),
                const Divider(thickness: 2),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (inject.id != null) {
                      await InjectDatabaseHelper.instance.delete(inject.id!);

                      setState(() {
                        futureInjects = dbHelper.getAllInjects();
                      });
                    }
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    minimumSize: Size(MediaQuery.of(context).size.width, 60),
                  ),
                  child: const Text('삭제하기'),
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 2),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    minimumSize: Size(MediaQuery.of(context).size.width, 60),
                  ),
                  child: const Text('닫기'),
                ),
                const SizedBox(height: 18),
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Container(
          decoration: BoxDecoration(
            //color: const Color(0xFFEFF4ED),
            borderRadius: BorderRadius.circular(15.0),

            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.5),
            //     spreadRadius: 1,
            //     blurRadius: 5,
            //     offset: const Offset(0, 3),
            //   ),
            // ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 5),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2.5, color: Color(0xFFA6CBA5)),
                ),
                child: ClipOval(
                  child: Image.file(
                    File(inject.injectPicture),
                    width: 65,
                    height: 65,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
                children: [
                  Text(
                    "${inject.injectType} : ${inject.injectName}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 136, 171, 134),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    koreanTime,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(221, 53, 53, 53)),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text("시간당 투여량 : ${inject.injectAmount}  |  "),
                      Text(
                        inject.injectChange ? '교체 : 필요' : '교체 : 불필요',
                      ),
                    ],
                  ),

                  //SizedBox(height: 2),
                ],
              ),
            ],
          ),
        ),
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
      title: Text('주사', style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          // 메인 화면으로 돌아가기
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        },
      ),
    );
  }
}
