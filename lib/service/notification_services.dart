// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// //
// // class NotificationService {
// //   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
// //   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
// //   FlutterLocalNotificationsPlugin();
// //
// //   Future<void> initialize() async {
// //     // Request permission
// //     NotificationSettings settings = await _firebaseMessaging.requestPermission(
// //       alert: true,
// //       badge: true,
// //       sound: true,
// //     );
// //
// //     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
// //       print('User granted permission');
// //     }
// //
// //     // Initialize local notifications
// //     const AndroidInitializationSettings initializationSettingsAndroid =
// //     AndroidInitializationSettings('@mipmap/ic_launcher');
// //     final InitializationSettings initializationSettings =
// //     InitializationSettings(android: initializationSettingsAndroid);
// //     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
// //
// //     // Handle foreground messages
// //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
// //       _showNotification(message);
// //     });
// //   }
// //
// //   Future<void> _showNotification(RemoteMessage message) async {
// //     const AndroidNotificationDetails androidPlatformChannelSpecifics =
// //     AndroidNotificationDetails(
// //       'queue_channel',
// //       'Queue Notifications',
// //       importance: Importance.max,
// //       priority: Priority.high,
// //       showWhen: false,
// //     );
// //     const NotificationDetails platformChannelSpecifics =
// //     NotificationDetails(android: androidPlatformChannelSpecifics);
// //     await _flutterLocalNotificationsPlugin.show(
// //       0,
// //       message.notification?.title,
// //       message.notification?.body,
// //       platformChannelSpecifics,
// //       payload: message.data['type'],
// //     );
// //   }
// //
// //   Future<String?> getDeviceToken() async {
// //     return await _firebaseMessaging.getToken();
// //   }
// //
// //   Future<void> subscribeToBranch(String branchId) async {
// //     await _firebaseMessaging.subscribeToTopic('branch_$branchId');
// //   }
// //
// //   Future<void> unsubscribeFromBranch(String branchId) async {
// //     await _firebaseMessaging.unsubscribeFromTopic('branch_$branchId');
// //   }
// //   Future<void> showNotification({
// //     required String title,
// //     required String body,
// //     int id = 0,
// //   }) async {
// //     const AndroidNotificationDetails androidNotificationDetails =
// //     AndroidNotificationDetails(
// //       'queue_channel',
// //       'Queue Notifications',
// //       importance: Importance.max,
// //       priority: Priority.high,
// //       showWhen: false,
// //     );
// //
// //     const NotificationDetails notificationDetails = NotificationDetails(
// //       android: androidNotificationDetails,
// //     );
// //   }
// // }
//
//
// // lib/app/service/notification_service.dart
// import 'package:get/get.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class NotificationService extends GetxService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//
//   Future<void> initialize() async {
//     await _firebaseMessaging.requestPermission();
//     FirebaseMessaging.onMessage.listen(_handleMessage);
//   }
//
//   void _handleMessage(RemoteMessage message) {
//     Get.snackbar(
//       message.notification?.title ?? 'Notification',
//       message.notification?.body ?? '',
//       duration: const Duration(seconds: 5),
//     );
//   }
//
//   Future<void> sendNotification(String userId, String message) async {
//     // In a real app, you would send this via FCM to specific user devices
//     Get.snackbar(
//       'Token Update',
//       message,
//       duration: const Duration(seconds: 3),
//     );
//   }
// }


// lib/app/services/notification_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../routs/routs.dart';

class NotificationService extends GetxService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Initialize service
  Future<NotificationService> init() async {
    await _firebaseMessaging.requestPermission();
    _setupFirebaseListeners();
    print('NotificationService initialized');
    return this;
  }

  void _setupFirebaseListeners() {
    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpened);
  }

  void _handleMessage(RemoteMessage message) {
    Get.snackbar(
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? '',
      duration: const Duration(seconds: 5),
    );
  }

  void _handleMessageOpened(RemoteMessage message) {
    // Handle when app is opened from notification
    Get.toNamed(Routes.NOTIFICATIONS);
  }

  Future<void> sendNotification(String userId, String message) async {
    // Implementation for sending notifications
  }
}