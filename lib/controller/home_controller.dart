// app/modules/home/home_controller.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routs/routs.dart';
import '../service/auth_services.dart';
import '../service/queue_services.dart';
import '../util/app_color.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find();
  final QueueService _queueService = Get.find();

  var currentIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
    _initializeFCM();
  }
  void changePage(int index) {
    currentIndex.value = index;
  }

  void logout() async {
    await _authService.logout();
    Get.offAllNamed(Routes.LOGIN);
  }
  void _initializeFCM() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        Get.snackbar(
          message.notification!.title ?? 'Update',
          message.notification!.body ?? '',
          backgroundColor: appBlueColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    });
  }
}