// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/queue_controller.dart';
// import '../routs/routs.dart';
// import '../service/queue_services.dart';
// import '../util/app_color.dart';
//
// class QueueView extends GetView<QueueController> {
//   const QueueView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         final queues = Get.find<QueueService>().activeQueues;
//         if (queues.isEmpty) {
//           return const Center(child: Text("No queues available"));
//         }
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: queues.length,
//           itemBuilder: (_, i) => _buildQueueCard(context, queues[i]),
//         );
//       }),
//     );
//   }
//
//   Widget _buildQueueCard(BuildContext context, QueueItem queue) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       decoration: BoxDecoration(//DecorationImage
//         border: Border.all(
//           color: Colors.grey.shade300,
//           width:1.6,
//         ), //Border.all
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: const [//BoxShadow
//           BoxShadow(
//             color: Colors.white,
//             offset: Offset(0.0, 0.0),
//             blurRadius: 0.0,
//             spreadRadius: 0.0,
//           ), //BoxShadow
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeader(queue),
//             const SizedBox(height: 12),
//             _buildQueueDetails(queue),
//             const SizedBox(height: 20),
//             Align(
//               alignment: Alignment.centerRight,
//               child: ElevatedButton.icon(
//                 icon: const Icon(Icons.event_available, size: 18),
//                 label: const Text(
//                   'Book Token',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 onPressed: () => Get.toNamed(Routes.BOOKING, arguments: queue),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: blueTransparentColor,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader(QueueItem queue) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _getQueueIcon(queue.type),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 queue.name,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800]),
//               ),
//               const SizedBox(height: 4),
//               Chip(
//                 label: Text(queue.type,
//                     style: const TextStyle(color: Colors.white, fontSize: 12)),
//                 backgroundColor: _getQueueColor(queue.type),
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildQueueDetails(QueueItem queue) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildDetailRow('Current Token', queue.currentToken),
//         _buildDetailRow('Estimated Wait', '${queue.waitingTime} min'),
//         if (queue.nextAvailable != null)
//           _buildDetailRow('Next Available', queue.nextAvailable!.toString().substring(0, 16)),
//       ],
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Text('$label: ',
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey[700],
//               )),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(color: Colors.black87),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _getQueueIcon(String type) {
//     IconData icon;
//     switch (type) {
//       case 'Bank':
//         icon = Icons.account_balance;
//         break;
//       case 'Hospital':
//         icon = Icons.local_hospital;
//         break;
//       case 'University Office':
//         icon = Icons.school;
//         break;
//       case 'Passport/ID Office':
//         icon = Icons.perm_identity;
//         break;
//       case 'Service Center':
//         icon = Icons.settings;
//         break;
//       case 'Government Office':
//         icon = Icons.account_balance_rounded;
//         break;
//       case 'Retail Store':
//         icon = Icons.store;
//         break;
//       default:
//         icon = Icons.business;
//     }
//
//     return Container(
//       decoration: BoxDecoration(
//         color: _getQueueColor(type).withOpacity(0.2),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       padding: const EdgeInsets.all(8),
//       child: Icon(icon, color: _getQueueColor(type), size: 28),
//     );
//   }
//
//   Color _getQueueColor(String type) {
//     switch (type) {
//       case 'Bank':
//         return Colors.blueAccent;
//       case 'Hospital':
//         return Colors.redAccent;
//       case 'University Office':
//         return Colors.green;
//       case 'Passport/ID Office':
//         return Colors.purple;
//       case 'Service Center':
//         return Colors.orange;
//       case 'Government Office':
//         return Colors.teal;
//       case 'Retail Store':
//         return Colors.amber;
//       default:
//         return Colors.grey;
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/queue_controller.dart';
import '../routs/routs.dart';
import '../service/queue_services.dart';
import '../util/app_color.dart';

class QueueView extends GetView<QueueController> {
  const QueueView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<QueueController>()) {
      Get.put(QueueController());
    }

    return Scaffold(
      body: Obx(() {
        final queues = controller.queues;
        if (queues.isEmpty) {
          return const Center(child: Text("No queues available"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: queues.length,
          itemBuilder: (_, i) => _buildQueueCard(context, queues[i]),
        );
      }),
    );
  }

  Widget _buildQueueCard(BuildContext context, QueueItem queue) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.6,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(queue),
            const SizedBox(height: 12),
            _buildQueueDetails(queue),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.event_available, size: 18),
                label: const Text(
                  'Book Token',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () => Get.toNamed(Routes.BOOKING, arguments: queue),
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueTransparentColor,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(QueueItem queue) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getQueueIcon(queue.type),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                queue.name,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]),
              ),
              const SizedBox(height: 4),
              Chip(
                label: Text(queue.type,
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
                backgroundColor: _getQueueColor(queue.type),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQueueDetails(QueueItem queue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Current Token', queue.currentToken),
        _buildDetailRow('Estimated Wait', '${queue.waitingTime} min'),
        if (queue.nextAvailable != null)
          _buildDetailRow('Next Available',
              queue.nextAvailable!.toString().substring(0, 16)),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              )),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getQueueIcon(String type) {
    IconData icon;
    switch (type) {
      case 'Bank':
        icon = Icons.account_balance;
        break;
      case 'Hospital':
        icon = Icons.local_hospital;
        break;
      case 'University Office':
        icon = Icons.school;
        break;
      case 'Passport/ID Office':
        icon = Icons.perm_identity;
        break;
      case 'Service Center':
        icon = Icons.settings;
        break;
      case 'Government Office':
        icon = Icons.account_balance_rounded;
        break;
      case 'Retail Store':
        icon = Icons.store;
        break;
      default:
        icon = Icons.business;
    }

    return Container(
      decoration: BoxDecoration(
        color: _getQueueColor(type).withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      child: Icon(icon, color: _getQueueColor(type), size: 28),
    );
  }

  Color _getQueueColor(String type) {
    switch (type) {
      case 'Bank':
        return Colors.blueAccent;
      case 'Hospital':
        return Colors.redAccent;
      case 'University Office':
        return Colors.green;
      case 'Passport/ID Office':
        return Colors.purple;
      case 'Service Center':
        return Colors.orange;
      case 'Government Office':
        return Colors.teal;
      case 'Retail Store':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}
