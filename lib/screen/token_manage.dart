import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/counter_controller.dart';

class TokenManagementView extends StatelessWidget {
  final CounterController controller = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Token Management'),
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final counters = controller.filteredCounters;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: counters.length,
          itemBuilder: (context, index) {
            final counter = counters[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(counter.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("Current Token: ${counter.currentToken ?? 'None'}"),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              controller.callNextToken(counter.id),
                          child: const Text('Call Next'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => controller.skipToken(counter.id),
                          child: const Text('Skip'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
