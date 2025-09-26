// import 'package:get/get.dart';
// import '../service/queue_services.dart';
// import '../util/snack_baar.dart';
//
// class AddQueueController extends GetxController {
//   var queues = <QueueItem>[].obs;
//
//   void addQueue({
//     required String name,
//     required String type,
//     required String currentToken,
//     int waitingTime = 0,
//     DateTime? nextAvailable,
//   }) {
//     final newQueue = QueueItem(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       name: name,
//       type: type,
//       currentToken: currentToken,
//       waitingTime: waitingTime,
//       nextAvailable: nextAvailable,
//     );
//     queues.add(newQueue);
//     Utils.showSnackBar("Queue Added", SnackType.success);
//   }
//
//   void deleteQueue(String id) {
//     queues.removeWhere((q) => q.id == id);
//     Utils.showSnackBar("Queue Deleted", SnackType.success);
//   }
//
//   void editQueue(String id, QueueItem updated) {
//     int index = queues.indexWhere((q) => q.id == id);
//     if (index != -1) {
//       queues[index] = updated;
//       Utils.showSnackBar("Queue Updated", SnackType.success);
//     }
//   }
// }



// add_queue_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/queue_services.dart';

class AddQueueController extends GetxController {
  final queues = <QueueItem>[].obs;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _listenToQueues();
  }

  void _listenToQueues() {
    _db.collection('queues').snapshots().listen((snapshot) {
      queues.assignAll(snapshot.docs.map((doc) {
        final data = doc.data();
        return QueueItem(
          id: doc.id,
          name: data['name'] ?? '',
          type: data['type'] ?? '',
          currentToken: data['currentToken'] ?? '',
          waitingTime: data['waitingTime'] ?? 0,
          nextAvailable: (data['nextAvailable'] as Timestamp?)?.toDate(),
        );
      }).toList());
    });
  }

  Future<void> addQueue({
    required String name,
    required String type,
    required String currentToken,
    int waitingTime = 0,
    DateTime? nextAvailable,
  }) async {
    await _db.collection('queues').add({
      'name': name,
      'type': type,
      'currentToken': currentToken,
      'waitingTime': waitingTime,
      'nextAvailable': nextAvailable,
    });
    Get.snackbar('Success', 'Queue added successfully');
  }

  Future<void> editQueue(String id, QueueItem updatedQueue) async {
    await _db.collection('queues').doc(id).update({
      'name': updatedQueue.name,
      'type': updatedQueue.type,
      'currentToken': updatedQueue.currentToken,
      'waitingTime': updatedQueue.waitingTime,
      'nextAvailable': updatedQueue.nextAvailable,
    });
    Get.snackbar('Updated', 'Queue updated successfully');
  }

  Future<void> deleteQueue(String id) async {
    await _db.collection('queues').doc(id).delete();
    Get.snackbar('Deleted', 'Queue deleted successfully');
  }
}
