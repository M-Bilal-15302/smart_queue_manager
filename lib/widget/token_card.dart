import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/token_model.dart';
class TokenCard extends StatelessWidget {
  final TokenBooking token;

  const TokenCard({required this.token});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (token.status) {
      case 'waiting':
        statusColor = Colors.orange;
        break;
      case 'called':
        statusColor = Colors.blue;
        break;
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Token #${token.number}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(
                    token.status.toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: statusColor,
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Service: ${token.serviceType}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Booked: ${DateFormat('MMM d, y - hh:mm a').format(token.bookedTime)}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            if (token.scheduledTime != null) ...[
              SizedBox(height: 8),
              Text(
                'Scheduled: ${DateFormat('MMM d, y - hh:mm a').format(token.scheduledTime!)}',
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
            ],
            if (token.calledTime != null) ...[
              SizedBox(height: 8),
              Text(
                'Called: ${DateFormat('MMM d, y - hh:mm a').format(token.calledTime!)}',
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
            ],
            if (token.completedTime != null) ...[
              SizedBox(height: 8),
              Text(
                'Completed: ${DateFormat('MMM d, y - hh:mm a').format(token.completedTime!)}',
                style: TextStyle(fontSize: 14, color: Colors.green),
              ),
            ],
          ],
        ),
      ),
    );
  }
}