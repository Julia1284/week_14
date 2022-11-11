import 'package:flutter/material.dart';
import 'package:week_14/local_notification.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))))),
      debugShowCheckedModeBanner: false,
      home: const NotificationsPage(),
    );
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
// экземпляр класса LocalNotificationService
  late final LocalNotificationService service;

  //инициализация
  @override
  void initState() {
    super.initState();
    service = LocalNotificationService();
    service.initialize();
    // планирование уведомления при запуске приложения
    service.repeatNotification(
        id: 0, title: 'Julia', body: 'Не забудь про Flutter');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Уведомления'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    service.showNotification(
                        id: 0,
                        title: 'Julia',
                        body: 'Добро пожаловать в приложение!');
                  },
                  child: const Text('Уведомление по нажатию')),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    service.showScheduleNotification(
                        id: 0,
                        title: 'Julia',
                        body: ' Прошло пять секунд после нажатия!',
                        seconds: 5);
                  },
                  child: const Text('Вы получите уведомление через 5 секунд')),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await service.showScheduleTimeNotification(
                        id: 0,
                        title: 'Julia',
                        body: 'Не забудь сделать зарядку!');
                  },
                  child: const Text('Запланируйте уведомление на 8 утра')),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    service.repeatNotification(
                        id: 0,
                        title: 'Julia',
                        body: 'Удели программированию полчаса!!');
                  },
                  child: const Text('Повторяющееся уведомление')),
            ]),
      ),
    );
  }
}
