// import 'package:get/get.dart';
// import '../service/queue_services.dart';
//
// class QueueController extends GetxController {
//   final QueueService queueService = Get.find();
//   final queues = <QueueItem>[].obs;
//   final isLoading = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchQueues();
//   }
//   Future<void> fetchQueues() async {
//     isLoading.value = true;
//     try {
//       queues.assignAll([
//         QueueItem(
//           id: '1',
//           name: 'Hospital Queue',
//           type: 'Hospital',
//           currentToken: 'B101',
//         ),
//       ]);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
import 'package:get/get.dart';
import '../service/queue_services.dart';

class QueueController extends GetxController {
  final QueueService queueService = Get.find();
  late RxList<QueueItem> queues;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    queues = queueService.activeQueues;
  }
}
