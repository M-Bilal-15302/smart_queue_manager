// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import '../controller/booking_controller.dart';
// import '../service/queue_services.dart';
// import '../util/app_color.dart';
// import 'package:qr_flutter/qr_flutter.dart';
//
//
// class BookingView extends GetView<BookingController> {
//   const BookingView({super.key});
//   @override
//   Widget build(BuildContext context) {
//     if (!Get.isRegistered<BookingController>()) {
//       Get.put(BookingController());
//     }
//
//     final queue = Get.arguments as QueueItem?;
//     if (queue == null) return _buildErrorScreen();
//
//     controller.initializeWithQueue(queue);
//     _initializeFCM();
//
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: appBlueColor,
//         elevation: 0,
//         title: const Text('Book Virtual Token', style: TextStyle(color: Colors.white)),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: ListView(
//           children: [
//             _buildSectionTitle('Queue Information'),
//             const SizedBox(height: 12),
//             _buildQueueCard(queue),
//             const SizedBox(height: 30),
//             _buildSectionTitle('Select Schedule'),
//             const SizedBox(height: 12),
//             _buildDateTimePickers(context),
//             const SizedBox(height: 30),
//             Obx(() => controller.isLoading.value
//                 ? const Center(child: CircularProgressIndicator())
//                 : _buildBookButton()),
//             const SizedBox(height: 24),
//             Obx(() => _buildBookingFeedback()),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorScreen() {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(title: const Text('Error')),
//       body: Center(
//         child: Container(
//           margin: const EdgeInsets.symmetric(vertical: 4),
//           decoration: BoxDecoration(//DecorationImage
//             border: Border.all(
//               color: Colors.grey.shade300,
//               width:1.6,
//             ), //Border.all
//             borderRadius: BorderRadius.circular(8),
//             boxShadow: const [//BoxShadow
//               BoxShadow(
//                 color: Colors.white,
//                 offset: Offset(0.0, 0.0),
//                 blurRadius: 0.0,
//                 spreadRadius: 0.0,
//               ), //BoxShadow
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(Icons.error_outline, color: Colors.red, size: 60),
//                 const SizedBox(height: 20),
//                 const Text('Invalid Queue Data',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 10),
//                 const Text('Please select a valid queue from the list.'),
//                 const SizedBox(height: 20),
//                 ElevatedButton.icon(
//                   onPressed: () => Get.back(),
//                   icon: const Icon(Icons.arrow_back),
//                   label: const Text('Go Back'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: appBlueColor,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 22,
//         fontWeight: FontWeight.bold,
//         color: appBlueColor,
//       ),
//     );
//   }
//
//   Widget _buildQueueCard(QueueItem queue) {
//     final dateFormat = DateFormat('EEE, MMM d • hh:mm a');
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
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             _buildQueueInfoRow('Queue Name', queue.name),
//             const Divider(),
//             _buildQueueInfoRow('Current Token', '${queue.currentToken}'),
//             _buildQueueInfoRow('Estimated Wait', '${queue.waitingTime} mins'),
//             _buildQueueInfoRow(
//               'Next Available',
//               queue.nextAvailable != null
//                   ? dateFormat.format(queue.nextAvailable!)
//                   : 'Not Available',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQueueInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 3,
//             child: Text(
//               label,
//               style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]),
//             ),
//           ),
//           Expanded(
//             flex: 5,
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDateTimePickers(BuildContext context) {
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
//       child: Column(
//         children: [
//           ListTile(
//             leading: const Icon(Icons.calendar_today, color:appBlueColor),
//             title: Obx(() => Text(
//               'Date: ${controller.formattedScheduledDate}',
//               style: const TextStyle(fontSize: 16),
//             )),
//             trailing: TextButton(
//               onPressed: () => controller.selectDate(context),
//               child: const Text('Select'),
//             ),
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.access_time,color:appBlueColor),
//             title: Obx(() => Text(
//               'Time: ${controller.formattedScheduledTime}',
//               style: const TextStyle(fontSize: 16),
//             )),
//             trailing: TextButton(
//               onPressed: () => controller.selectTime(context),
//               child: const Text('Select'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBookButton() {
//     return ElevatedButton.icon(
//       onPressed: controller.isScheduled.value ? controller.bookVirtualToken : null,
//       icon: const Icon(Icons.check),
//       label: const Text('Book My Token'),
//       style: ElevatedButton.styleFrom(
//         minimumSize: const Size.fromHeight(50),
//         backgroundColor: appBlueColor,
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       ),
//     );
//   }
//   Widget _buildBookingFeedback() {
//     if (controller.bookingSuccess.value) {
//       final qrData = jsonEncode({
//         "tokenId": controller.tokenId.value,
//         "queueId": controller.queueId.value,
//         "userId": controller.userId.value,
//         "timestamp": DateTime.now().toIso8601String(),
//       });
//
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: Colors.green[50],
//               border: Border.all(color: Colors.green),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.green),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     'Your token has been successfully booked!',
//                     style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           QrImageView(
//             data: qrData,
//             version: QrVersions.auto,
//             size: 200.0,
//           ),
//           const SizedBox(height: 10),
//           const Text("Show this QR code at the counter to check in."),
//         ],
//       );
//     } else {
//       return Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: const Text(
//           'Please select a date and time to book your token.',
//           style: TextStyle(color: Colors.grey),
//         ),
//       );
//     }
//   }
//   // Widget _buildBookingFeedback() {
//   //   if (controller.bookingSuccess.value) {
//   //     return Container(
//   //       padding: const EdgeInsets.all(14),
//   //       decoration: BoxDecoration(
//   //         color: Colors.green[50],
//   //         border: Border.all(color: Colors.green),
//   //         borderRadius: BorderRadius.circular(12),
//   //       ),
//   //       child: const Row(
//   //         children: [
//   //           Icon(Icons.check_circle, color: Colors.green),
//   //           SizedBox(width: 10),
//   //           Expanded(
//   //             child: Text(
//   //               'Your token has been successfully booked!',
//   //               style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     );
//   //   } else {
//   //     return Container(
//   //       padding: const EdgeInsets.all(14),
//   //       decoration: BoxDecoration(
//   //         color: Colors.grey[200],
//   //         borderRadius: BorderRadius.circular(12),
//   //       ),
//   //       child: const Text(
//   //         'Please select a date and time to book your token.',
//   //         style: TextStyle(color: Colors.grey),
//   //       ),
//   //     );
//   //   }
//   // }
//
//   void _initializeFCM() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       final context = Get.context;
//       if (context != null && message.notification != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(message.notification!.title ?? 'New Notification'),
//             backgroundColor: appBlueColor,
//           ),
//         );
//       }
//     });
//
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     FirebaseMessaging.instance.requestPermission();
//   }
//
//   static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     debugPrint("Handling background message: ${message.messageId}");
//   }
// }
//
//
//
//
// class QRScannerView extends StatefulWidget {
//   const QRScannerView({super.key});
//
//   @override
//   State<QRScannerView> createState() => _QRScannerViewState();
// }
//
// class _QRScannerViewState extends State<QRScannerView> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   bool isScanned = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Scan Token QR")),
//       body: QRView(
//         key: qrKey,
//         onQRViewCreated: _onQRViewCreated,
//       ),
//     );
//   }
//
//   void _onQRViewCreated(QRViewController ctrl) {
//     controller = ctrl;
//     controller!.scannedDataStream.listen((scanData) async {
//       if (!isScanned) {
//         isScanned = true;
//         controller?.pauseCamera();
//
//         try {
//           final decoded = jsonDecode(scanData.code ?? "{}");
//           final tokenId = decoded["tokenId"];
//           final queueId = decoded["queueId"];
//           final userId = decoded["userId"];
//
//           await FirebaseFirestore.instance
//               .collection("bookings")
//               .doc(tokenId)
//               .update({"status": "checked_in"});
//
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Token $tokenId checked in successfully!")),
//           );
//         } catch (e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Failed to check in: $e")),
//           );
//         }
//
//         await Future.delayed(const Duration(seconds: 2));
//         Navigator.pop(context);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controller/booking_controller.dart';
import '../util/app_color.dart';
import 'qr_scanner_view.dart';

class BookingView extends StatelessWidget {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<BookingController>()) {
      Get.put(BookingController());
    }
    final queue = Get.arguments as dynamic?;
    if (queue == null) return _buildErrorScreen();

    final controller = Get.find<BookingController>();
    controller.initializeWithQueue(queue);

    return Scaffold(
      backgroundColor: softBgColor,
      appBar: AppBar(
        backgroundColor: appBlueColor,
        title: const Text('Book Virtual Token',style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh,color: Colors.white,),
            onPressed: controller.refreshQueueData,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appGradientStart,
        onPressed: () => Get.to(() => QRScannerView()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _infoSection(controller),
            const SizedBox(height: 20),
            _dateTimeSection(context, controller),
            const SizedBox(height: 20),
            _estimatedTimeSection(controller),
            const SizedBox(height: 20),
            _progressSection(controller),
            const SizedBox(height: 30),
            _bookButton(controller),
            const SizedBox(height: 20),
            _feedbackSection(controller),
            const SizedBox(height: 20),
            _qrSection(controller),
          ],
        ),
      ),
    );
  }

  Widget _softContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: softContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            offset: const Offset(-6, -6),
            blurRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(2, 2),
            blurRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
  Widget _infoSection(BookingController c) {
    return _softContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [appGradientStart, appGradientEnd]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Queue Information',
              style: TextStyle(color: Colors.white, fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          _infoRow('Name', c.currentQueue?.name ?? ''),
          _infoRow('Type', c.currentQueue?.type ?? ''),
          _infoRow('Current Token', c.currentQueue?.currentToken ?? 'None'),
          _infoRow('Waiting Time', '${c.currentQueue?.waitingTime ?? 0} mins'),
          _infoRow('Queue Length', '${c.currentQueue?.queueLength ?? 0}'),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 3, child: Text(val, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _dateTimeSection(BuildContext ctx, BookingController c) {
    return _softContainer(
      child: Column(children: [
        ListTile(
          leading: const Icon(Icons.calendar_today, color: appBlueColor),
          title: const Text('Select Date'),
          trailing: Obx(() => Text(c.formattedScheduledDate)),
          onTap: () => c.selectDate(ctx),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.access_time, color: appBlueColor),
          title: const Text('Select Time'),
          trailing: Obx(() => Text(c.formattedScheduledTime)),
          onTap: () => c.selectTime(ctx),
        ),
      ]),
    );
  }

  Widget _estimatedTimeSection(BookingController c) {
    return Obx(() {
      if (!c.isScheduled || c.currentQueue == null) return const SizedBox();
      final wait = c.userPosition * (c.currentQueue?.waitingTime ?? 0);
      return _softContainer(
        child: Column(
          children: [
            const Text('Estimated Wait Time', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('$wait minutes',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('(Position #${c.userPosition} in queue)'),
          ],
        ),
      );
    });
  }

  Widget _progressSection(BookingController c) {
    return Obx(() {
      if (c.currentQueue == null) return const SizedBox();
      final progress = c.currentQueue!.queueLength == 0
          ? 0.0
          : c.userPosition / c.currentQueue!.queueLength;
      return _softContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Queue Progress', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(appBlueColor),
            ),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Position: ${c.userPosition}'),
              Text('Total: ${c.currentQueue?.queueLength}'),
            ]),
          ],
        ),
      );
    });
  }

  Widget _bookButton(BookingController c) {
    return Obx(() {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          minimumSize: const Size.fromHeight(50),
          elevation: 4,
        ),
        onPressed: (c.isScheduled && !c.isLoading) ? c.bookVirtualToken : null,
        child: Ink(
          decoration: BoxDecoration(
            gradient: (c.isScheduled && !c.isLoading)
                ? const LinearGradient(colors: [appGradientStart, appGradientEnd])
                : const LinearGradient(colors: [Colors.grey, Colors.grey]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            alignment: Alignment.center,
            child: c.isLoading
                ? const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(color: Colors.white),
            )
                : Text(
              c.bookingSuccess ? 'Book Another Token' : 'Book My Token',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      );
    });
  }

  Widget _feedbackSection(BookingController c) {
    return Obx(() {
      IconData icon;
      String message;
      Color color;
      if (c.bookingError.isNotEmpty) {
        icon = Icons.error_outline;
        message = c.bookingError;
        color = Colors.red;
      } else if (c.bookingSuccess) {
        icon = Icons.check_circle;
        message = 'Success! Your token is ${c.userToken}';
        color = Colors.green;
      } else {
        icon = Icons.info_outline;
        message = 'Select date & time to book your token';
        color = appBlueColor;
      }
      return _softContainer(
          child: Row(children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ]));
    });
  }

  Widget _qrSection(BookingController c) {
    return Obx(() {
      if (!c.bookingSuccess) return const SizedBox();
      return _softContainer(
        child: Column(children: [
          const Text('Your Check‑In QR Code', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: QrImageView(data: c.bookingId, version: QrVersions.auto, size: 200),
          ),
          const SizedBox(height: 12),
          const Text('Show this code at the counter to check in', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text('Token: ${c.userToken}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
      );
    });
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: softBgColor,
      appBar: AppBar(backgroundColor: appBlueColor, title: const Text('Error')),
      body: Center(
        child: _softContainer(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 20),
            const Text('Invalid Queue Data',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Please select a valid queue from the list.'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: appGradientStart,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
            ),
          ]),
        ),
      ),
    );
  }
}
