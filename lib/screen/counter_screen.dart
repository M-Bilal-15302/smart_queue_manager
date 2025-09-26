// app/modules/counter/counter_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/counter_controller.dart';
import '../service/queue_services.dart';
import '../util/app_color.dart';

class CounterView extends GetView<CounterController> {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<CounterController>()) {
      Get.put(CounterController());
    }
    return Scaffold(
     appBar: AppBar(backgroundColor: Colors.blueAccent,title: Text("Counter Manage",style: TextStyle(color: Colors.white),),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          // Show a loading indicator while data is being fetched
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  GetX<QueueService>(builder: (queueService) {
                    return Column(
                      children: controller.filteredCounters
                          .map((counter) => _buildCounterCard(counter))
                          .toList(),
                    );
                  }),
                ],
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _buildCounterCard(Counter counter) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(//DecorationImage
        border: Border.all(
          color: Colors.grey.shade300,
          width:1.6,
        ), //Border.all
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [//BoxShadow
          BoxShadow(
            color: Colors.white,
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ), //BoxShadow
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    counter.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: appBlueColor,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    counter.status,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: counter.status == 'Available'
                      ? Colors.green
                      : Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  counter.type == 'Hospital'
                      ? Icons.local_hospital
                      : counter.type == 'Bank'
                      ? Icons.account_balance
                      : Icons.storefront,
                  color:appBlueColor,
                ),
                const SizedBox(width: 8),
                Text(
                  counter.type,
                  style: TextStyle(color: appBlueColor, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (counter.currentToken != null) ...[
              Text(
                'Current Token: ${counter.currentToken}',
                style: TextStyle(fontSize: 16, color: Colors.blue[700]),
              ),
              const SizedBox(height: 4),
            ],
            if (counter.lastCalled != null) ...[
              Text(
                'Last Called: ${DateFormat('hh:mm a').format(counter.lastCalled!)}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
            ],
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.callNextToken(counter.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: appBlueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: controller.isLoading.value
                  ? const CircularProgressIndicator(
                color: Colors.white,
              )
                  : const Text(
                'Call Next Token',
                style: TextStyle(color: Colors.white),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
