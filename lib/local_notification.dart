import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class LocalNotificationService {
  final _localNotificationService = FlutterLocalNotificationsPlugin();
// функция для локального времени
  static Future configurationTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(
      timeZoneName,
    ));
  }

  Future<void> initialize() async {
    await configurationTimeZone();
    const AndroidInitializationSettings androidInitialize =
        AndroidInitializationSettings('ic_launcher');
    DarwinInitializationSettings iOSInitialize = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification);

    final InitializationSettings setting =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    await _localNotificationService.initialize(setting);
  }

  Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'channel name',
          color: Colors.black,
          // icon: '@drawable/ic_launcher',
          largeIcon: DrawableResourceAndroidBitmap('@drawable/ic_launcherbig'),
          importance: Importance.max,
          channelDescription: 'content',
          priority: Priority.max,
          playSound: true),
      iOS: DarwinNotificationDetails(),
    );
  }

// уведомление при нажатии на кнопку, если положить в инит, то при запуске приложения
  Future showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    await _localNotificationService.show(
      id,
      title,
      body,
      await _notificationDetails(),
    );
  }

// уведомление с запланированной задержкой
  Future showScheduleNotification(
      {int id = 0, String? title, String? body, required int seconds}) async {
    await _localNotificationService.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
          DateTime.now().add(Duration(seconds: seconds)), tz.local),
      await _notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

//  уведомление на запланированное время
  Future showScheduleTimeNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(
      timeZoneName,
    ));
    await _localNotificationService.zonedSchedule(
      id,
      title,
      body,
      scheduleDaily(const Time(08, 00)),
      await _notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

// ежедневные повторяющие уведомления, запускается или по нажатию на кнопку или при запуске приложения(если функцию положить в инит)
  Future repeatNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    await _localNotificationService.periodicallyShow(
        id++, title, body, RepeatInterval.daily, await _notificationDetails(),
        androidAllowWhileIdle: true);
  }

// ежедневные повторяющие уведомления, запускается или по нажатию на кнопку или при запуске приложения(если функцию положить в инит)
//функция zonedSchedule. можно запланировать на определенное время
  Future showScheduleTimeNotificationZonedSchedule({
    int id = 0,
    String? title,
    String? body,
  }) async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(
      timeZoneName,
    ));
    await _localNotificationService.zonedSchedule(
      id,
      title,
      body,
      scheduleDaily(const Time(08, 00)),
      await _notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  tz.TZDateTime scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);

    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }

  void _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }
}
