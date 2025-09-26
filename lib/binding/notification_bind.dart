// lib/app/modules/notifications/notifications_binding.dart
import 'package:get/get.dart';

import '../controller/notification_controller.dart';
import '../service/notification_services.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(() => NotificationsController());
    Get.lazyPut<NotificationService>(
          () => NotificationService(),
      fenix: true,
    );
  }
}