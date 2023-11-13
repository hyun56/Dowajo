import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final TimeOfDay scheduleTime;
  final String medicineName;

  const ScheduleCard({
    required this.scheduleTime,
    required this.medicineName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Container(
              height: 50.0,
              width: 8.0,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            _Time(scheduleTime: scheduleTime),
            SizedBox(width: 8.0),
            _IsTakeMedicine(
                medicineName: medicineName, isChecked: false, isTaked: '복용전'),
          ],
        ));
  }
}

class _Time extends StatelessWidget {
  final TimeOfDay scheduleTime;
  _Time({
    required this.scheduleTime,
    Key? key,
  }) : super(key: key);

  final textStyle = TextStyle(
      fontWeight: FontWeight.w700, color: Colors.black, fontSize: 23.0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('복용 시각', style: textStyle.copyWith(fontSize: 10.0)),
          Text('${scheduleTime.hour}:${scheduleTime.minute}', style: textStyle),
        ],
      ),
    );
  }
}

class _IsTakeMedicine extends StatefulWidget {
  final String medicineName;
  bool isChecked;
  String isTaked;

  _IsTakeMedicine({
    required this.medicineName,
    required this.isChecked,
    required this.isTaked,
    Key? key,
  }) : super(key: key);

  @override
  State<_IsTakeMedicine> createState() => _IsTakeMedicineState();
}

class _IsTakeMedicineState extends State<_IsTakeMedicine> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.medicineName),
          Container(
            padding: EdgeInsets.only(left: 7.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(width: 1.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.isTaked),
                Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      value: widget.isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          widget.isChecked = value!;
                          if (widget.isChecked == true) {
                            widget.isTaked = '복용완료';
                          } else if (widget.isChecked = false) {
                            widget.isTaked = '복용전';
                          } else
                            widget.isTaked = '복용전';
                        });
                      },
                    ))
              ],
            ),
          )
        ],
      ),
    ));
  }
}
