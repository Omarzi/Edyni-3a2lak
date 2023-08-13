import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static Dio? dio;

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final IOSFlutterLocalNotificationsPlugin _iosFlutterLocalNotificationsPlugin = IOSFlutterLocalNotificationsPlugin();

  static Future initialize() async {
    dio = Dio(BaseOptions(
      baseUrl: 'https://fcm.googleapis.com/fcm/',
      receiveDataWhenStatusError: true,
    ));

    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/launcher_icon');

    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().second ~/ 100;
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "1",
        "channel name",
        importance: Importance.max,
        priority: Priority.high,
      ));

      await _flutterLocalNotificationsPlugin.show(
          id,
          message.notification!.title,
          message.notification!.body,
          notificationDetails);
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future<Response> pushNotification({
    required Map<String, dynamic> data,
  }) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAeVUh7eY:APA91bE9_XjZ0F4dY5bPCgqmDLXxCMtHs6oj3keszM0tkBXxlkHSndrD2CA1MJ_bNrvWFOdPjd39SQtQfPPA3DoFDBfkBpO8o_N7G0RrgPagiEB3wLlA2bqqL-BQXbc9x3gbkr1q8HzT'
    };

    return await dio!.post(
      'send',
      data: data,
    );
  }
}
