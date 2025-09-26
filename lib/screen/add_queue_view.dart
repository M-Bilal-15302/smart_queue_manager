import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/queue_controller.dart';
import '../controller/add_queue_controller.dart';
import '../service/queue_services.dart';

class AddQueueView extends StatelessWidget {
  AddQueueView({super.key});

  final AddQueueController controller = Get.put(AddQueueController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController waitingController = TextEditingController();

  void _showAddEditQueueDialog(BuildContext context, {QueueItem? queue}) {
    final isEdit = queue != null;

    if (isEdit) {
      nameController.text = queue!.name;
      typeController.text = queue.type;
      tokenController.text = queue.currentToken;
      waitingController.text = queue.waitingTime.toString();
    } else {
      nameController.clear();
      typeController.clear();
      tokenController.clear();
      waitingController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Edit Queue' : 'Add Queue'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: typeController, decoration: const InputDecoration(labelText: 'Type')),
              TextField(controller: tokenController, decoration: const InputDecoration(labelText: 'Current Token')),
              TextField(
                controller: waitingController,
                decoration: const InputDecoration(labelText: 'Waiting Time (mins)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (isEdit) {
                controller.editQueue(
                  queue!.id,
                  QueueItem(
                    id: queue.id,
                    name: nameController.text,
                    type: typeController.text,
                    currentToken: tokenController.text,
                    waitingTime: int.tryParse(waitingController.text) ?? 0,
                    nextAvailable: queue.nextAvailable,
                  ),
                );
              } else {
                controller.addQueue(
                  name: nameController.text,
                  type: typeController.text,
                  currentToken: tokenController.text,
                  waitingTime: int.tryParse(waitingController.text) ?? 0,
                );
              }
              Get.back();
            },
            child: Text(isEdit ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, String value, Color color) {
    return Chip(
      backgroundColor: color.withOpacity(0.1),
      avatar: Icon(icon, color: color, size: 18),
      label: Text(
        '$label: $value',
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  Widget _buildQueueUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Obx(() {
        if (controller.queues.isEmpty) {
          return const Center(
            child: Text(
              "No queues available.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.separated(
          itemCount: controller.queues.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, index) {
            final queue = controller.queues[index];

            return Material(
              color: Colors.white,
              elevation: 5,
              borderRadius: BorderRadius.circular(14),
              shadowColor: Colors.black26,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => _showAddEditQueueDialog(context, queue: queue),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.blue.shade50,
                        child: Icon(Icons.queue, size: 32, color: Colors.blue.shade700),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              queue.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              children: [
                                _infoChip(Icons.category, 'Type', queue.type, Colors.orange),
                                _infoChip(Icons.confirmation_number, 'Token', queue.currentToken, Colors.purpleAccent),
                                _infoChip(Icons.timer, 'Waiting', '${queue.waitingTime} mins', Colors.green),
                                if (queue.nextAvailable != null)
                                  _infoChip(Icons.access_time, 'Next Available', _formatDate(queue.nextAvailable!), Colors.blue),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.deepOrange),
                            tooltip: 'Edit Queue',
                            onPressed: () => _showAddEditQueueDialog(context, queue: queue),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            tooltip: 'Delete Queue',
                            onPressed: () => controller.deleteQueue(queue.id),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Queue Management")),
      body: _buildQueueUI(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditQueueDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
