import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:dowajo/components/models/medicine.dart';
import 'package:dowajo/database/medicine_database.dart';
import 'notification_manager.dart';
import 'utils.dart';

void scheduleAlarm() async {
  DatabaseHelper db = DatabaseHelper.instance;
  List<Medicine> medicines = await db.getAllMedicines();

  for (Medicine medicine in medicines) {
    try {
      List<String> days = medicine.medicineDay.split(',');
      List<String> times = medicine.medicineTime.split(',');

      int len = (days.length < times.length) ? days.length : times.length;
      for (int i = 0; i < len; i++) {
        String day = days[i];
        String time = times[i];

        DateTime now = DateTime.now();
        DateTime scheduledDate = DateTime(
          now.year,
          now.month,
          now.day,
          parseHour(time),
          parseMinute(time),
        );
        
        if (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
        }
        
        int alarmId = ('$day$time${medicine.id}$i').hashCode;

        if (medicine.id != null) {
          await AndroidAlarmManager.periodic(
            const Duration(days: 7),
            alarmId,
            sendNotification,
            startAt: scheduledDate,
            exact: true,
            wakeup: true,
          );

          print('Alarm scheduled for medicine ID $alarmId at $scheduledDate');
        }
      }
    } catch (e) {
      print('Error while parsing day and time: $e');
    }
  }
}
