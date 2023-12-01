import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationApi {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings(
        "app/src/main/res/mipmap-hdpi/ic_launcher.png");


    var initializationSettingsIos = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body,
            String? payload) async {});

    var initializaitonSettings = InitializationSettings(
        android: initializationSettingsAndroid,
            iOS: initializationSettingsIos
    );
    await flutterLocalNotificationsPlugin.initialize(initializaitonSettings, onDidReceiveNotificationResponse: (NotificationResponse notificationResponse)async{});
  }

  notificationDetails(){
  return const NotificationDetails(
    android: AndroidNotificationDetails("channelId", "channelName", importance: Importance.max),
    iOS: DarwinNotificationDetails());
  }

  Future showNotification(
  {int id = 0, String? title, String? body, String? payload }) async {
  return flutterLocalNotificationsPlugin.show(id, title, body, await notificationDetails());
  }

}
