import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import '../model/token_model.dart';
import '../model/queue_model.dart';
import '../routs/routs.dart';
import '../service/admin_services.dart';
import '../service/notification_services.dart';
import '../service/queue_services.dart';
import '../util/snack_baar.dart';

class AdminController extends GetxController {
  final AdminService adminService = Get.find();
  final NotificationService notificationService = Get.find();

  final isLoading = false.obs;
  final tokens = <AdminToken>[].obs;
  final totalTokens = 0.obs;
  final activeTokens = 0.obs;
  final waitingTokens = 0.obs;

  final queues = <QueueItem>[].obs;
  final currentTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTokens();
    setupRealtimeUpdates();
    loadQueues();
  }

  void switchToTokenTab() => currentTab.value = 0;
  void switchToQueueTab() => currentTab.value = 1;

  void loadQueues() {
    queues.assignAll([
      QueueItem(id: '1', name: 'Hospital Counter 1', type: 'Hospital', currentToken: 'B101', waitingTime: 10),
    ]);
  }

  void addQueue({
    required String name,
    required String type,
    required String currentToken,
    int waitingTime = 0,
    DateTime? nextAvailable,
  }) {
    final newQueue = QueueItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      type: type,
      currentToken: currentToken,
      waitingTime: waitingTime,
      nextAvailable: nextAvailable,
    );
    queues.add(newQueue);
    Utils.showSnackBar("Queue Added", SnackType.success);
  }

  void editQueue(
      String id, {
        required String name,
        required String type,
        required String currentToken,
        int waitingTime = 0,
        DateTime? nextAvailable,
      }) {
    final index = queues.indexWhere((q) => q.id == id);
    if (index != -1) {
      queues[index] = QueueItem(
        id: id,
        name: name,
        type: type,
        currentToken: currentToken,
        waitingTime: waitingTime,
        nextAvailable: nextAvailable,
      );
      queues.refresh();
      Utils.showSnackBar("Queue Updated", SnackType.success);
    }
  }

  void deleteQueue(String id) {
    queues.removeWhere((q) => q.id == id);
    Utils.showSnackBar("Queue Deleted", SnackType.info);
  }

  Future<void> fetchTokens() async {
    isLoading.value = true;
    try {
      final tokenList = await adminService.getTokens();
      tokens.assignAll(tokenList);
      _updateStats();
      print("Check token ---====----${jsonEncode(tokenList)}");
    } catch (e) {
      print("Check token error ---=====---$e");
     // Utils.showSnackBar("Failed fetch token:  ${e.toString()}", SnackType.error);
    } finally {
      isLoading.value = false;
    }
  }

  void _updateStats() {
    totalTokens.value = tokens.length;
    activeTokens.value = tokens.where((t) => t.status == 'progress').length;
    waitingTokens.value = tokens.where((t) => t.status.toLowerCase() == 'waiting').length;
  }

  Future<void> callToken(AdminToken token) async {
    try {
      await adminService.updateTokenStatus(token.id, 'progress');
      final index = tokens.indexWhere((t) => t.id == token.id);
      if (index != -1) {
        tokens[index] = token.copyWith(status: 'progress');
        tokens.refresh();
        _updateStats();
      }
      await sendNotificationToUser(
        token.userId,
        'Call Token',
        'Your token ${token.tokenNumber} is call.',
      );
      await notificationService.sendNotification(token.userId, 'Your token ${token.tokenNumber} is now being processed.');
    } catch (e) {
      //Utils.showSnackBar("Failed call token:  ${e.toString()}", SnackType.error);
    }
  }

  Future<void> completeToken(AdminToken token) async {
    try {
      await adminService.updateTokenStatus(token.id, 'Completed');
      final index = tokens.indexWhere((t) => t.id == token.id);
      if (index != -1) {
        tokens[index] = token.copyWith(status: 'Completed');
        tokens.refresh();
        _updateStats();
      }
      await sendNotificationToUser(
        token.userId,
        'Token Completed',
        'Your token ${token.tokenNumber} is completed.',
      );
      await notificationService.sendNotification(token.userId, 'Your token ${token.tokenNumber} has been completed.');
    } catch (e) {
      //Utils.showSnackBar("Failed complete token:  ${e.toString()}", SnackType.error);
    }
  }

  Future<void> skipToken(AdminToken token) async {
    try {
      await adminService.updateTokenStatus(token.id, 'Skipped');
      final index = tokens.indexWhere((t) => t.id == token.id);
      if (index != -1) {
        tokens[index] = token.copyWith(status: 'Skipped');
        tokens.refresh();
        _updateStats();
      }

      await notificationService.sendNotification(token.userId, 'Your token ${token.tokenNumber} has been skipped.');
    } catch (e) {
     // Utils.showSnackBar("Failed skip token:  ${e.toString()}", SnackType.error);
    }
  }

  Future<void> refreshData() async => fetchTokens();

  void setupRealtimeUpdates() {
    adminService.tokenStream.listen((updatedToken) {
      final index = tokens.indexWhere((t) => t.id == updatedToken.id);
      if (index != -1) {
        tokens[index] = updatedToken;
      } else {
        tokens.add(updatedToken);
      }
      tokens.refresh();
      _updateStats();
    });
  }

  Future<void> logout() async {
    await adminService.logout();
    Get.offAllNamed(Routes.LOGIN);
  }



  Future<void> sendNotificationToUser(String userId, String title, String body) async {
    try {
      final HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('sendNotificationToUser');

      await callable.call(<String, dynamic>{
        'userId': userId,
        'title': title,
        'body': body,
      });
    } catch (e) {
      print("Failed to send user notification: $e");
    }
  }

}
