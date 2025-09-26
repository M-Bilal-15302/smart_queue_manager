import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:smart_queue_awkum/routs/app_page.dart';
import 'package:smart_queue_awkum/routs/routs.dart';
import 'package:smart_queue_awkum/service/admin_services.dart';
import 'package:smart_queue_awkum/service/auth_services.dart';
import 'package:smart_queue_awkum/service/notification_services.dart';
import 'package:smart_queue_awkum/service/queue_services.dart';

import 'controller/history_controller.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message received: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(NotificationService());
  debugPrint('[main] Initializing services...');

  try {
    await Get.putAsync<AuthService>(() => AuthService().init());
    await Get.putAsync<QueueService>(() => QueueService().init());
    await Get.putAsync(() => AdminService().init());
    await Get.putAsync(() => HistoryController().init());
    await Get.putAsync(() => NotificationService().init());

    debugPrint('[main] Services initialized successfully');
  } catch (e) {
    debugPrint('[main] Service initialization error: $e');
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen for background messages from Firebase
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    return GetMaterialApp(
      title: 'Smart Queue Manager',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.SPLASH,
      getPages: AppPages.pages,
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver((_) => debugPrint("Route changed"))],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}