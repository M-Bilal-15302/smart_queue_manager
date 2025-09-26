// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// import '../model/token_model.dart';
// import '../service/admin_services.dart';
// import '../service/queue_services.dart';
// import '../util/app_constant.dart';
//
// class BookingController extends GetxController {
//   final selectedServiceType = ''.obs;
//   final isScheduled = false.obs;
//   final scheduledDate = DateTime.now().obs;
//   final scheduledTime = TimeOfDay.now().obs;
//   final isLoading = false.obs;
//   final bookingSuccess = false.obs;
//   final AdminService adminService = Get.find();
//
//   // Initialize the controller with queue data (which type of service and counters to choose)
//   void initializeWithQueue(QueueItem queue) {
//     selectedServiceType.value = queue.type == 'Bank'
//         ? AppConstants.bankCounters.first
//         : AppConstants.hospitalCounters.first;
//     isScheduled.value = false;
//   }
//
//   // Handle the date selection using DatePicker widget
//   Future<void> selectDate(BuildContext context) async {
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: scheduledDate.value,
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 30)),
//     );
//     if (pickedDate != null) {
//       scheduledDate.value = pickedDate;
//       isScheduled.value = true; // Set as scheduled when the user picks a date
//     }
//   }
//   Future<void> _saveBookingToHistory() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//
//     final now = DateTime.now();
//
//     final scheduledDateTime = DateTime(
//       scheduledDate.value.year,
//       scheduledDate.value.month,
//       scheduledDate.value.day,
//       scheduledTime.value.hour,
//       scheduledTime.value.minute,
//     );
//
//     // Generate a unique token number
//     final tokenNumber = DateTime.now().millisecondsSinceEpoch.toString();
//
//     final newToken = TokenBooking(
//       id: '',
//       number: tokenNumber,
//       userId: user.uid,
//       serviceType: selectedServiceType.value,
//       bookedTime: now,
//       status: 'waiting',
//       scheduledTime: scheduledDateTime,
//     );
//
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc("useruid")
//         .collection('tokens')
//         .add(newToken.toMap());
//   }
//   Future<void> selectTime(BuildContext context) async {
//     final pickedTime = await showTimePicker(
//       context: context,
//       initialTime: scheduledTime.value,
//     );
//     if (pickedTime != null) {
//       scheduledTime.value = pickedTime;
//       isScheduled.value = true; // Set as scheduled when the user picks a time
//     }
//   }
//   Future<void> bookVirtualToken() async {
//     isLoading.value = true;  // Show loading indicator while the booking is being processed
//
//     try {
//       // Assuming an API call here to book the token
//       final response = await adminService.bookToken(selectedServiceType.value, scheduledDate.value, scheduledTime.value);
//
//       // If the booking is successful
//       if (response.isSuccessful) {
//         bookingSuccess.value = true;
//         _saveBookingToHistory();
//         Get.snackbar(
//           'Booking Successful',
//           'Your token has been successfully booked.',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green[200],
//           colorText: Colors.white,
//         );
//         saveTokenToDatabase();
//       } else {
//         // If the booking fails (due to server error or invalid data)
//         bookingSuccess.value = false;
//         Get.snackbar(
//           'Booking Failed',
//           'An error occurred while booking your token. Please try again.',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red[200],
//           colorText: Colors.white,
//         );
//       }
//     } catch (error) {
//       // Catch unexpected errors
//       bookingSuccess.value = false;
//       Get.snackbar(
//         'Booking Failed',
//         'An unexpected error occurred: ${error.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red[200],
//         colorText: Colors.white,
//       );
//       print("Check booking token------${error.toString()}");
//     } finally {
//       // Stop the loading indicator once the process is complete
//       isLoading.value = false;
//     }
//   }
//
//   // Format the scheduled date in a readable format
//   String get formattedScheduledDate =>
//       DateFormat('yyyy-MM-dd').format(scheduledDate.value);
//   String get formattedScheduledTime =>
//       '${scheduledTime.value.hour}:${scheduledTime.value.minute.toString().padLeft(2, '0')}';
// }
// Future<void> saveTokenToDatabase() async {
//   final FirebaseMessaging messaging = FirebaseMessaging.instance;
//   final FirebaseAuth auth = FirebaseAuth.instance;
//
//   final user = auth.currentUser;
//   if (user == null) {
//     debugPrint('❌ No authenticated user found while saving FCM token.');
//     return;
//   }
//
//   String? token = await messaging.getToken();
//   if (token != null) {
//     await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//       'fcmToken': token,
//       'lastUpdated': FieldValue.serverTimestamp(),
//     }, SetOptions(merge: true)); // prevent overwrite
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../service/auth_services.dart';
import '../service/queue_services.dart';

class BookingController extends GetxController {
  final QueueService _queueService = Get.find();
  final Rx<QueueItem?> _currentQueue = Rx<QueueItem?>(null);
  final Rx<DateTime?> _scheduledDate = Rx<DateTime?>(null);
  final Rx<TimeOfDay?> _scheduledTime = Rx<TimeOfDay?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _bookingSuccess = false.obs;
  final RxString _bookingError = ''.obs;
  final RxString _bookingId = ''.obs;
  final RxString _userToken = ''.obs;
  final RxInt _userPosition = (-1).obs;

  QueueItem? get currentQueue => _currentQueue.value;
  bool get isScheduled => _scheduledDate.value != null && _scheduledTime.value != null;
  bool get isLoading => _isLoading.value;
  bool get bookingSuccess => _bookingSuccess.value;
  String get bookingError => _bookingError.value;
  String get bookingId => _bookingId.value;
  String get userToken => _userToken.value;
  int get userPosition => _userPosition.value;

  String get formattedScheduledDate => _scheduledDate.value != null
      ? DateFormat('EEE, MMM d').format(_scheduledDate.value!)
      : 'Not selected';

  String get formattedScheduledTime => _scheduledTime.value != null
      ? _scheduledTime.value!.format(Get.context!)
      : 'Not selected';

  void initializeWithQueue(QueueItem queue) {
    _currentQueue.value = queue;
    _bookingSuccess.value = false;
    _bookingError.value = '';
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      _scheduledDate.value = picked;
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      _scheduledTime.value = picked;
    }
  }

  Future<void> bookVirtualToken() async {
    if (!isScheduled || currentQueue == null) return;

    _isLoading.value = true;
    _bookingError.value = '';

    try {
      // Generate a unique booking ID
      _bookingId.value = '${currentQueue!.id}-${DateTime.now().millisecondsSinceEpoch}';

      // Generate token number (e.g., B-1024 for Bank queue)
      _userToken.value = _generateToken(currentQueue!.type);
      _userPosition.value = currentQueue!.queueLength + 1;
      await _queueService.createBooking(
        queueId: currentQueue!.id,
        bookingId: _bookingId.value,
        userId: Get.find<AuthService>().currentUser!.uid,
        tokenNumber: _userToken.value,
        scheduledTime: _combineDateTime(),
        position: _userPosition.value,
      );

      _bookingSuccess.value = true;
      _queueService.bookToken(queueId: currentQueue!.id,
          serviceType:_userToken.value, scheduledTime: _combineDateTime());
    } catch (e) {
      _bookingError.value = 'Failed to book token: ${e.toString()}';
      _bookingSuccess.value = false;
      print('Failed to book token: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  String _generateToken(String queueType) {
    final prefix = queueType.substring(0, 1).toUpperCase();
    final random = DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    return '$prefix-$random';
  }

  DateTime _combineDateTime() {
    return DateTime(
      _scheduledDate.value!.year,
      _scheduledDate.value!.month,
      _scheduledDate.value!.day,
      _scheduledTime.value!.hour,
      _scheduledTime.value!.minute,
    );
  }

  void refreshQueueData() async {
    if (currentQueue == null) return;

    _isLoading.value = true;
    try {
      final updatedQueue = await _queueService.getQueue(currentQueue!.id);
      if (updatedQueue != null) {
        _currentQueue.value = updatedQueue;
        updateUserPosition();
      }
    } catch (e) {
      _bookingError.value = 'Failed to refresh queue data';
    } finally {
      _isLoading.value = false;
    }
  }

  void updateUserPosition() {
    if (bookingSuccess && currentQueue != null) {
      // This would normally come from the database
      // For demo, we'll just decrement by 1 each refresh
      if (_userPosition.value > 1) {
        _userPosition.value -= 1;
      }
    }
  }
}