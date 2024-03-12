import 'package:workmanager/workmanager.dart';
import 'notification_manager.dart'; // 이전에 분리했던 notification_manager.dart를 import합니다.

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    sendNotification();
    return Future.value(true);
  });
}

void setupWorkManager() {
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  Workmanager().registerPeriodicTask(
    "1",
    "simplePeriodicTask",
    frequency: const Duration(minutes: 15),
  );
}
