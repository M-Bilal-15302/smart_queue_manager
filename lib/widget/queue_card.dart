import 'package:flutter/material.dart';
import '../model/queue_model.dart';
import '../util/app_constant.dart';

class QueueCard extends StatelessWidget {
  final Queue queue;

  const QueueCard({super.key, required this.queue});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;

    switch (queue.status) {
      case 'called':
        statusColor = Colors.orange;
        statusIcon = Icons.notifications_active;
        break;
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default: // waiting
        statusColor = Colors.blue;
        statusIcon = Icons.access_time;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Token #${queue.tokenNumber}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(statusIcon, color: statusColor),
                    const SizedBox(width: 5),
                    Text(
                      queue.status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Service: ${queue.serviceType}'),
            Text('Booked at: ${queue.bookingTime.toString()}'),
            if (queue.calledTime != null)
              Text('Called at: ${queue.calledTime.toString()}'),
            if (queue.completedTime != null)
              Text('Completed at: ${queue.completedTime.toString()}'),
            if (queue.status == 'waiting')
              Text('Estimated wait: ${queue.estimatedWaitTime} minutes'),
          ],
        ),
      ),
    );
  }
}