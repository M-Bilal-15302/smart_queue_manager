import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/admin_controller.dart';
import '../model/token_model.dart';
import '../routs/routs.dart';
import '../service/queue_services.dart';
import '../util/app_color.dart';

class AdminView extends GetView<AdminController> {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: const Text('Admin Panel', style: TextStyle(color: Colors.white)),
        backgroundColor: appBlueColor,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text("Admin Navigation", style: TextStyle(fontSize: 20)),
            ),
            ListTile(
              title: const Text("Token Management"),
              leading: const Icon(Icons.confirmation_num),
              onTap: controller.switchToTokenTab,
            ),
            ListTile(
              title: const Text("Queue Management"),
              leading: const Icon(Icons.queue),
              onTap:()=>Get.toNamed(Routes.AddQUEUE),
            ),
            ListTile(
              title: const Text("Notifications"),
              leading: const Icon(Icons.notifications),
              onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
            ),
            // ListTile(
            //   title: const Text("Manage Counter"),
            //   leading: const Icon(Icons.desktop_windows),
            //   onTap: () => Get.toNamed(Routes.COUNTER),
            // ),
            ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.logout),
              onTap: controller.logout,
            ),
          ],
        ),
      ),
      body: Obx(
              () => controller.currentTab.value == 0 ? _buildTokenUI() : _buildQueueUI(context)
      ),
      floatingActionButton:
       FloatingActionButton(
          backgroundColor: appBlueColor,
          child: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () => controller.currentTab.value == 0
              ? controller.refreshData()
              : _showAddEditQueueDialog(context),
        )
    );
  }

  Widget _buildTokenUI() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Token Management", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildStatsPanel(),
          const SizedBox(height: 20),
          Expanded(child: _buildTokenQueue()),
        ],
      ),
    );
  }

  Widget _buildStatsPanel() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem('Total', controller.totalTokens.value, Colors.deepPurple, Colors.purple.shade50),
            _buildStatItem('Active', controller.activeTokens.value, Colors.blue, Colors.blue.shade50),
            _buildStatItem('Waiting', controller.waitingTokens.value, Colors.orange, Colors.orange.shade50),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem(String title, int value, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor)),
          const SizedBox(height: 6),
          Text('$value', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }

  Widget _buildTokenQueue() {
    return Obx(() {
      if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
      if (controller.tokens.isEmpty) return const Center(child: Text('No tokens in queue.'));

      return RefreshIndicator(
        onRefresh: controller.refreshData,
        child: ListView.separated(
          itemCount: controller.tokens.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final token = controller.tokens[index];
            return _buildTokenCard(token);
          },
        ),
      );
    });
  }

  Widget _buildTokenCard(AdminToken token) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: _getStatusColor(token.status),
          child: Icon(
            _getStatusIcon(token.status),
            color: Colors.white,
          ),
        ),
        title: Text('Token ${token.tokenNumber}', style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('Status: ${token.status} • ${token.queueName}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
        trailing: _buildTokenActions(token),
      ),
    );
  }
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'waiting':
        return Icons.hourglass_empty;
      case 'progress':
        return Icons.play_arrow;
      case 'completed':
        return Icons.check_circle;
      case 'skipped':
        return Icons.skip_next;
      default:
        return Icons.help_outline;
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
        return Colors.grey;
      default:
        return Colors.black54;
    }
  }

  Widget _buildTokenActions(AdminToken token) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (token.status.toLowerCase() == 'waiting')
          IconButton(
            icon: const Icon(Icons.campaign, color: Colors.green),
            tooltip: 'Call Token',
            onPressed: () => controller.callToken(token),
          ),
        if (token.status.toLowerCase() == 'progress') ...[
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.orange),
            tooltip: 'Skip Token',
            onPressed: () => controller.skipToken(token),
          ),
          IconButton(
            icon: const Icon(Icons.done_all, color: Colors.blue),
            tooltip: 'Complete Token',
            onPressed: () => controller.completeToken(token),
          ),
        ],
      ],
    );
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
                onTap: () {
                  _showAddEditQueueDialog(context, queue: queue);
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Circle avatar with queue type icon
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.blue.shade50,
                        child: Icon(
                          Icons.queue,
                          size: 32,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(width: 20),

                      // Expanded details column
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

                            // Wrap chips inside normal container, NOT Flexible or Expanded
                            Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              children: [
                                _infoChip(Icons.category, 'Type', queue.type,Colors.orange),
                                _infoChip(Icons.confirmation_number, 'Token', queue.currentToken,Colors.purpleAccent),
                                _infoChip(Icons.timer, 'Waiting', '${queue.waitingTime} mins',Colors.green),
                                if (queue.nextAvailable != null)
                                  _infoChip(
                                    Icons.access_time,
                                    'Next Available',
                                    _formatDate(queue.nextAvailable!),Colors.blue
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Action buttons column with fixed width to avoid overflow
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
// Helper widget for info chips
  Widget _infoChip(IconData icon, String label, String value,Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,maxLines: 3,
              style: const TextStyle(fontWeight:
              FontWeight.w400, color: Colors.black87,overflow: TextOverflow.ellipsis,),
            ),
          ),
        ],
      ),
    );
  }

  /// Format DateTime to readable string
  String _formatDate(DateTime date) {
    // Example: "Jun 17, 2025 - 14:35"
    return '${date.day}/${date.month}/${date.year}  ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showAddEditQueueDialog(BuildContext context, {QueueItem? queue}) {
    final isEditing = queue != null;
    final nameController = TextEditingController(text: queue?.name ?? '');
    final typeController = TextEditingController(text: queue?.type ?? '');
    final tokenController = TextEditingController(text: queue?.currentToken ?? '');
    final waitController = TextEditingController(text: queue?.waitingTime.toString() ?? '0');
    final nextAvailableController = TextEditingController(
      text: queue?.nextAvailable?.toLocal().toString().split('.').first ?? '',
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEditing ? "Edit Queue" : "Add Queue"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
              TextField(controller: typeController, decoration: const InputDecoration(labelText: "Type")),
              TextField(controller: tokenController, decoration: const InputDecoration(labelText: "Current Token")),
              TextField(controller: waitController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Waiting Time (mins)")),
              TextField(
                controller: nextAvailableController,
                readOnly: true,
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (pickedDate != null) {
                    final pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                    if (pickedTime != null) {
                      final dt = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
                      nextAvailableController.text = dt.toString().split('.').first;
                    }
                  }
                },
                decoration: const InputDecoration(labelText: "Next Available"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              final type = typeController.text.trim();
              final currentToken = tokenController.text.trim();
              final waitingTime = int.tryParse(waitController.text.trim()) ?? 0;
              final nextAvailable = DateTime.tryParse(nextAvailableController.text.trim());

              if (isEditing) {
                controller.editQueue(
                  queue!.id,
                  name: name,
                  type: type,
                  currentToken: currentToken,
                  waitingTime: waitingTime,
                  nextAvailable: nextAvailable,
                );
              } else {
                controller.addQueue(
                  name: name,
                  type: type,
                  currentToken: currentToken,
                  waitingTime: waitingTime,
                  nextAvailable: nextAvailable,
                );
              }
              Get.back();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
