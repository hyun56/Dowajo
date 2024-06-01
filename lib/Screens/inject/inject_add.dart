import 'dart:io';
import 'package:dowajo/Patient/patient_controller.dart';
import 'package:dowajo/components/models/injectModel.dart';
import 'package:dowajo/database/inject_database.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';

class inject_add extends StatefulWidget {
  const inject_add({Key? key}) : super(key: key);

  @override
  State<inject_add> createState() => _inject_addState();
}

enum type { normal, IV, nose }

class _inject_addState extends State<inject_add> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int selectedRepeat = 1;
  XFile? _pickedFile;
  String Type = "일반 주사";
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  late String endTimeString;
  final TextEditingController _injectNameController = TextEditingController();
  final TextEditingController _injectAmountController = TextEditingController();
  List<String> selectedDays = []; // 선택된 요일을 저장하는 리스트
  bool change = false; //추가 교체 여부
  type _type = type.normal;

  late PatientController controller;
  late String patientName;

  void _showTimePicker(TimeOfDay time, bool start) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: time,
    );

    if (newTime != null) {
      setState(() {
        if (start) {
          startTime = newTime;
        } else {
          endTime = newTime;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    tz.initializeTimeZones();

    controller = Get.find();
    patientName = controller.searchResult.value!.first.name;
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification(TimeOfDay time, patientName, String type,
      String injectName, bool change) async {
    final now = DateTime.now();
    var notificationTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    if (notificationTime.isBefore(now)) {
      notificationTime = notificationTime.add(const Duration(days: 1));
    }
    final tz.TZDateTime tzNotificationTime =
        tz.TZDateTime.from(notificationTime, tz.local);

    final replaceText = change ? '새 수액으로 교체가 필요합니다.' : '교체가 필요하지 않습니다.';

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      '$patientName 환자 $type 종료 알림: $injectName',
      replaceText,
      tzNotificationTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AppBar(
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.black),
              ),
              const SizedBox(height: 20),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                injectType(), // 상단 안내문
                addPhoto(), // 사진등록
              ]),
              const SizedBox(height: 25),
              injectName(), // 약 이름 입력창
              const SizedBox(height: 25),
              // 경계선 추가
              const Divider(
                color: Color.fromARGB(255, 236, 236, 236),
                thickness: 4.0,
              ),
              const SizedBox(height: 25),
              numOfTitle(), // 복용횟수- 타이틀
              //numOfTakeinject(), // 복용횟수 - 횟수 설정
              const SizedBox(height: 20),
              //복용시간 추가
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Column(children: [
                  addTime("투여 시간", endTime, false),
                ]),
                injectAmount(),
              ]),
              const SizedBox(height: 30),
              // 경계선 추가
              const Divider(
                color: Color.fromARGB(255, 236, 236, 236),
                thickness: 4.0,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                      value: change,
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            change = value ?? false;
                          }
                        });
                      }),
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      "추가 교체 여부",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60),
              addAlarm(), //알람 추가 버튼
              //SizedBox(height: 30),
            ],
          ),
        ));
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
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => _getCameraImage(),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                minimumSize: Size(MediaQuery.of(context).size.width, 60),
              ),
              child: const Text('사진 찍기'),
            ),
            const SizedBox(height: 5),
            const Divider(thickness: 2),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _getPhotoLibraryImage(),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                minimumSize: Size(MediaQuery.of(context).size.width, 60),
              ),
              child: const Text('라이브러리에서 불러오기'),
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
  }

  _getCameraImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
      Navigator.pop(context);
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
        _pickedFile = pickedFile;
      });
      Navigator.pop(context);
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  Widget injectType() {
    return Expanded(
        child: Column(children: [
      Row(children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 10.0),
          child: Image.asset(
            'repo/icons/pill.png',
            width: 25.0,
            height: 25.0,
          ),
        ),
        const Text(
          "투여 주사 종류",
          style: TextStyle(
            fontSize: 17.0, // 글자크기
            fontWeight: FontWeight.bold, // 볼드체
            color: Colors.black, // 색상
            //  letterSpacing: 2.0, // 자간
          ),
        ),
      ]),
      Padding(
        padding: const EdgeInsets.only(top: 10, left: 5),
        child: Column(
          children: [
            RadioListTile(
              title: const Text("일반 주사"),
              value: type.normal,
              groupValue: _type,
              onChanged: (value) {
                setState(() {
                  _type = value!;
                });
              },
            ),
            RadioListTile(
              title: const Text("수액"),
              value: type.IV,
              groupValue: _type,
              onChanged: (value) {
                setState(() {
                  _type = value!;
                });
              },
            ),
            RadioListTile(
              title: const Text("비위관 (콧줄)"),
              value: type.nose,
              groupValue: _type,
              onChanged: (value) {
                setState(() {
                  _type = value!;
                });
              },
            ),
          ],
        ),
      )
    ]));
  }

  void requestPermission() async {
    PermissionStatus status = await Permission.camera.status;

    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      _showBottomSheet(); // 카메라나 갤러리를 열어 이미지를 선택하는 함수
    } else {
      // 권한이 거부된 경우 로직 (ex: 사용자에게 알림 표시)
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('권한 거부'),
            content: const Text('카메라와 갤러리 접근 권한이 필요합니다.'),
            actions: <Widget>[
              TextButton(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget addPhoto() {
    // ignore: unused_local_variable
    final imageSize = MediaQuery.of(context).size.width / 4;

    return Padding(
      padding: const EdgeInsets.only(right: 60, top: 40),
      child: Column(
        children: [
          const Text(
            "투여 주사 사진",
            style: TextStyle(
              fontSize: 17.0, // 글자크기
              fontWeight: FontWeight.bold, // 볼드체
              color: Colors.black, // 색, // 자간
            ),
          ),
          const SizedBox(height: 10),
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
                  child: Image.asset(
                    'repo/icons/photo.png',
                    width: 75.0,
                    height: 75.0,
                  ),
                  // Icon(
                  //   Icons.photo_camera,
                  //   size: imageSize,
                  // ),
                ),
              ),
            )
          else
            Center(
              child: GestureDetector(
                onTap: requestPermission,
                child: _pickedFile == null
                    ? Container(
                        constraints: BoxConstraints(
                          minHeight: imageSize,
                          minWidth: imageSize,
                        ),
                        child: Center(
                          child: Image.asset(
                            'repo/icons/photo.png',
                            width: 75.0,
                            height: 75.0,
                          ),
                        ),
                      )
                    : Center(
                        child: Container(
                          width: imageSize,
                          height: imageSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 3,
                                color:
                                    const Color.fromARGB(255, 217, 217, 217)),
                            image: DecorationImage(
                                image: FileImage(File(_pickedFile!.path)),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }

  Widget injectName() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "주사 이름을 입력하세요",
                  style: TextStyle(
                    fontSize: 15.0, // 글자크기
                    color: Colors.black, // 색상

                    // letterSpacing: 2.0, // 자간
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 330, // TextField 가로 길이
              height: 45,
              child: TextField(
                controller: _injectNameController,
                decoration: InputDecoration(
                  hintText: '예) 일반 수액',
                  hintStyle: const TextStyle(
                    fontSize: 13.0,
                    color: Color.fromARGB(255, 171, 171, 171),
                  ),
                  contentPadding:
                      const EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 221, 221, 221),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFA6CBA5),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget numOfTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 10.0),
          child: Image.asset(
            'repo/icons/alarm.png',
            width: 26.0,
            height: 26.0,
          ),
        ),
        const Text(
          "투여 시간 설정",
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget addTime(String name, TimeOfDay time, bool start) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 15),
        ),
        TextButton(
          onPressed: () {
            _showTimePicker(time, start); // 버튼을 누를 때 텍스트 업데이트
          },
          child: Text(time.format(context)),
        ),
      ],
    );
  }

  Widget injectAmount() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "시간당 투여량",
          style: TextStyle(
            fontSize: 15.0, // 글자크기
            color: Colors.black, // 색상
            // letterSpacing: 2.0, // 자간
          ),
        ),
        //const SizedBox(height: 10),
        SizedBox(
          width: 70, // TextField 가로 길이
          height: 45,
          child: TextField(
            controller: _injectAmountController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            //decoration: const InputDecoration(),
          ),
        ),
      ],
    );
  }

  Widget addAlarm() {
    return SizedBox(
      width: 350,
      height: 55,
      child: GestureDetector(
        onTap: () async {
          if (_injectNameController.text.isNotEmpty && _pickedFile != null) {
            // 모든 정보가 입력되었다면 inject 저장

            //notification
            if (_injectNameController.text.isNotEmpty) {
              _scheduleNotification(endTime, patientName, Type,
                  _injectNameController.text, change);
              Get.snackbar('알림', '알림이 설정되었습니다.');
            } else {
              Get.snackbar('알림', '수액 이름과 시간을 입력해주세요.');
            }
            String Typename;
            if (_type == type.normal) {
              Typename = "기본 주사";
            } else if (_type == type.IV)
              Typename = "수액";
            else if (_type == type.nose) Typename = "비위관(콧줄)";
            InjectModel newInject = InjectModel(
              id: null,
              injectChange: change,
              injectEndTime: endTime.format(context),
              injectStartTime: startTime.format(context),
              injectDay:
                  '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
              injectName: _injectNameController.text,
              injectAmount: _injectAmountController.text,
              injectPicture: _pickedFile?.path ?? '',
              injectType: _type.name,
            );
            InjectDatabaseHelper.instance.insert(newInject);
            Navigator.of(context).pop();
          } else {
            // 정보가 입력되지 않았다면 경고창 띄우기
            Get.snackbar('알림', '수액 이름과 시간을 입력해주세요.');
          }
        },
        child: ElevatedButton(
          onPressed: null, // onPressed를 null로 설정하여 버튼을 비활성화
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color(0xFFA6CBA5),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            elevation: MaterialStateProperty.all<double>(0),
          ),
          child: const Text(
            "주사 추가하기 +",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.5,
            ),
          ),
        ),
      ),
    );
  }
}
