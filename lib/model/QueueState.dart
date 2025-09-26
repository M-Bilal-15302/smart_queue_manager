import 'package:cloud_firestore/cloud_firestore.dart';

class QueueStats {
  final int waitingTokens;
  final int calledTokens;
  final int completedTokens;
  final int cancelledTokens;

  QueueStats({
    this.waitingTokens = 0,
    this.calledTokens = 0,
    this.completedTokens = 0,
    this.cancelledTokens = 0,
  });

  factory QueueStats.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return QueueStats(
      waitingTokens: data['waitingTokens'] ?? 0,
      calledTokens: data['calledTokens'] ?? 0,
      completedTokens: data['completedTokens'] ?? 0,
      cancelledTokens: data['cancelledTokens'] ?? 0,
    );
  }
}