// // lib/app/modules/notifications/notifications_view.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:samrt_queue/service/notification_services.dart';
// import '../controller/notification_controller.dart';
// class NotificationsView extends GetView<NotificationsController> {
//   const NotificationsView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final adminService = Get.find<NotificationService>();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//         centerTitle: true,
//       ),
//       body: Obx(() => ListView.builder(
//         itemCount: controller.notifications.length,
//         itemBuilder: (context, index) {
//           final notification = controller.notifications[index];
//           return ListTile(
//             title: Text(notification.title),
//             subtitle: Text(notification.body),
//             trailing: Text(notification.time),
//           );
//         },
//       )),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../controller/notification_controller.dart';
import '../service/notification_services.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final adminService = Get.find<NotificationService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.blueAccent,
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return const Center(
            child: Text(
              "No notifications yet.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];

            return Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(9),
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.notifications_active, color: Colors.blue),
                ),
                title: Text(
                  notification.title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    notification.body,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
                trailing: Text(
                  _formatTime(notification.time),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  /// Format time string to display like "10:45 AM" or "Jun 17"
  String _formatTime(String timeString) {
    try {
      final dateTime = DateTime.parse(timeString);
      final now = DateTime.now();
      final isToday = now.year == dateTime.year &&
          now.month == dateTime.month &&
          now.day == dateTime.day;

      return isToday
          ? DateFormat('h:mm a').format(dateTime)      // e.g., 10:42 AM
          : DateFormat('MMM d').format(dateTime);      // e.g., Jun 17
    } catch (_) {
      return timeString; // fallback if parsing fails
    }
  }
}
