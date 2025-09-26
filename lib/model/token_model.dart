import 'package:cloud_firestore/cloud_firestore.dart';
class TokenBooking {
  final String id;
  final String number;
  final String userId;
  final String serviceType;
  final DateTime bookedTime;
  final DateTime? calledTime;
  final DateTime? completedTime;
  final String status;
  final DateTime? scheduledTime;

  TokenBooking({
    required this.id,
    required this.number,
    required this.userId,
    required this.serviceType,
    required this.bookedTime,
    this.calledTime,
    this.completedTime,
    this.status = 'waiting',
    this.scheduledTime,
  });

  factory TokenBooking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TokenBooking(
      id: doc.id,
      number: data['number'] ?? '',
      userId: data['userId'] ?? '',
      serviceType: data['serviceType'] ?? '',
      bookedTime: (data['bookedTime'] as Timestamp).toDate(),
      calledTime: data['calledTime'] != null ? (data['calledTime'] as Timestamp).toDate() : null,
      completedTime: data['completedTime'] != null ? (data['completedTime'] as Timestamp).toDate() : null,
      status: data['status'] ?? 'waiting',
      scheduledTime: data['scheduledTime'] != null ? (data['scheduledTime'] as Timestamp).toDate() : null,
    );
  }
  factory TokenBooking.fromMap(Map<String, dynamic> data, String id) {
    return TokenBooking(
      id: id,
      number: data['number'] ?? '',
      userId: data['userId'] ?? '',
      serviceType: data['serviceType'] ?? '',
      bookedTime: data['bookedTime'].toDate(),
      calledTime: data['calledTime']?.toDate(),
      completedTime: data['completedTime']?.toDate(),
      status: data['status'] ?? 'waiting',
      scheduledTime: data['scheduledTime']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'userId': userId,
      'serviceType': serviceType,
      'bookedTime': bookedTime,
      'calledTime': calledTime,
      'completedTime': completedTime,
      'status': status,
      'scheduledTime': scheduledTime,
    };
  }
}






class AdminToken {
  final String id;
  final String tokenNumber;
  final String queueName;
  final String status;
  final String userId;
  final String servicesType;
  final DateTime createdAt;

  AdminToken({
    required this.id,
    required this.tokenNumber,
    required this.queueName,
    required this.status,
    required this.userId,
    required this.servicesType,
    required this.createdAt,
  });

  factory AdminToken.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AdminToken(
      id: doc.id,
      tokenNumber: data['tokenNumber'] ?? "",
      queueName: data['queueName'] ?? "",
      status: data['status'] ?? "",
      userId: data['userId'] ?? "",
      servicesType: data['serviceType'] ?? "",
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'tokenNumber': tokenNumber,
      'queueName': queueName,
      'status': status,
      'serviceType': servicesType,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// ✨ Used for updating individual fields like status
  AdminToken copyWith({
    String? id,
    String? tokenNumber,
    String? queueName,
    String? status,
    String? userId,
    DateTime? createdAt,
  }) {
    return AdminToken(
      id: id ?? this.id,
      tokenNumber: tokenNumber ?? this.tokenNumber,
      queueName: queueName ?? this.queueName,
      servicesType: servicesType ?? this.servicesType,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
