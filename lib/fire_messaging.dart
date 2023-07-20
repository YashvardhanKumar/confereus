import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FirebaseMessaging _fcm = FirebaseMessaging.instance;
late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

initializeMessaging() async {
  await Firebase.initializeApp();
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await _flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: selectionNotification);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print("onMessage: $message");
    await handleMessage(message);
  });
}

void selectionNotification(NotificationResponse notificationResponse) async {
  print('payload: ${notificationResponse.payload}');
}

handleMessage(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails('CHAT', "CHAT", channelDescription: 'CHAT', importance: Importance.max, priority: Priority.high, showWhen: true);
  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await _flutterLocalNotificationsPlugin.show(0, "New Messages", message.data['sender'] + ": " + message.data['message'], platformChannelSpecifics,
      payload: 'CHAT');
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await initializeMessaging();
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails('CHAT', "CHAT", importance: Importance.max, priority: Priority.high, showWhen: true);
  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await _flutterLocalNotificationsPlugin.show(0, "New Messages", message.data['sender'] + ": " + message.data['message'], platformChannelSpecifics,
      payload: 'CHAT');
}
Future<String?> getFCMToken() async {
  return await _fcm.getToken();
}



class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('flutter_logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future scheduleNotification(
      {int id = 0,
        String? title,
        String? body,
        String? payLoad,
        required DateTime scheduledNotificationDateTime}) async {
    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(),
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }
}