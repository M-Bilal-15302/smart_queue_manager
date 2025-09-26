// // app/modules/counter/counter_controller.dart
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../service/queue_services.dart';
//
// class CounterController extends GetxController {
//   final QueueService queueService = Get.find();
//   final isLoading = false.obs;
//   final counters = <Counter>[].obs;
//   final filteredCounters = <Counter>[].obs;  // This is now managed in the controller
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchCounters();
//   }
//
//   Future<void> fetchCounters() async {
//     isLoading.value = true;
//     try {
//       // Simulate API call with delay
//       await Future.delayed(const Duration(seconds: 1));
//       counters.assignAll(queueService.counters); // Replace with actual fetch
//       filteredCounters.assignAll(counters); // Initially display all counters
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to load counters');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void filterCounters(String category) {
//     if (category == 'All') {
//       filteredCounters.assignAll(counters);
//     } else {
//       filteredCounters.assignAll(counters.where((counter) => counter.type == category).toList());
//     }
//   }
//
//   Future<void> callNextToken(String counterId) async {
//     try {
//       isLoading.value = true;
//
//       final counterExists = counters.any((c) => c.id == counterId);
//       if (!counterExists) {
//         throw 'Selected counter not available';
//       }
//
//       await queueService.callNextToken(counterId);
//       await fetchCounters(); // Refresh the list
//
//       Get.snackbar(
//         'Success',
//         'Called next token',
//         colorText: Colors.white,
//         backgroundColor: Colors.green,
//         duration: const Duration(seconds: 2),
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         e.toString().replaceAll('Bad state:', '').trim(),
//         colorText: Colors.white,
//         backgroundColor: Colors.red,
//         duration: const Duration(seconds: 3),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }


// app/modules/counter/counter_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../service/queue_services.dart';

class CounterController extends GetxController {
  final QueueService queueService = Get.find();

  final isLoading = false.obs;
  final counters = <Counter>[].obs;
  final filteredCounters = <Counter>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCounters();
  }

  Future<void> fetchCounters() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
      counters.assignAll(queueService.counters); // Replace with real fetch if needed
      filteredCounters.assignAll(counters);
    } catch (e) {
      _handleError('Failed to load counters', e);
    } finally {
      isLoading.value = false;
    }
  }

  void filterCounters(String category) {
    if (category == 'All') {
      filteredCounters.assignAll(counters);
    } else {
      filteredCounters.assignAll(
        counters.where((counter) => counter.type == category).toList(),
      );
    }
  }

  Future<void> callNextToken(String counterId) async {
    isLoading.value = true;
    try {
      final exists = counters.any((c) => c.id == counterId);
      if (!exists) throw 'Selected counter not available';

      await queueService.callNextToken(counterId);
      await fetchCounters();

      Get.snackbar(
        'Success',
        'Called next token',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      _handleError('Failed to call next token', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> skipToken(String counterId) async {
    isLoading.value = true;
    try {
      await queueService.skipCurrentToken(counterId);
      await fetchCounters();

      Get.snackbar(
        'Token Skipped',
        'The token has been skipped successfully.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      _handleError('Failed to skip token', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeCurrentToken(String counterId) async {
    isLoading.value = true;
    try {
      await queueService.completeCurrentToken(counterId);
      await fetchCounters();

      Get.snackbar(
        'Completed',
        'Token marked as completed.',
        backgroundColor: Colors.teal,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      _handleError('Failed to complete token', e);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(String title, dynamic error) {
    String message = error.toString().replaceAll('Bad state:', '').trim();

    if (message.contains('socket')) {
      message = 'Network error. Please check your internet connection.';
    }

    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    debugPrint('Error: $error');
    debugPrintStack();
  }
}
