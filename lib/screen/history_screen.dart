import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/history_controller.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  late final HistoryController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<HistoryController>()) {
      controller = Get.put(HistoryController());
    } else {
      controller = Get.find<HistoryController>();
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'waiting':
        return Colors.orange;
      case 'progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'skipped':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime dateTime) =>
      DateFormat('yyyy-MM-dd • hh:mm a').format(dateTime);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final tokens = controller.tokens;
        if (tokens.isEmpty) {
          return const Center(
            child: Text(
              'No tokens booked yet.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tokens.length,
          itemBuilder: (_, i) {
            final token = tokens[i];
            final color = _getStatusColor(token.status);
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.confirmation_number, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Token :'
                            ' ${token.servicesType}',overflow: TextOverflow.ellipsis,maxLines:2,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      Icon(Icons.check_circle_outline, size: 18, color: color),
                      const SizedBox(width: 8),
                      Text('Status: ${token.status}',
                          style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w500)),
                    ]),
                    const SizedBox(height: 10),
                    Row(children: [
                      const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text('Booked at: ${_formatDate(token.createdAt)}',
                          style: const TextStyle(color: Colors.black87)),
                    ]),
                    const SizedBox(height: 8),
                    Row(children: [
                      const Icon(Icons.schedule, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text('Estimated: ${_formatDate(token.createdAt)}',
                          style: const TextStyle(color: Colors.black87)),
                    ]),
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
