// lib/app/controller/notifications_controller.dart
import 'package:get/get.dart';

class Notification {
  final String title;
  final String body;
  final String time;

  Notification({required this.title, required this.body, required this.time});
}

class NotificationsController extends GetxController {
  final notifications = <Notification>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    // Replace with actual notifications loading logic
    notifications.assignAll([
      Notification(
        title: 'Token Called',
        body: 'Token #123 has been called to Counter 1',
        time: '10:30 AM',
      ),
      Notification(
        title: 'New Booking',
        body: 'New token booked for Service A',
        time: 'Yesterday',
      ),
    ]);
  }
}