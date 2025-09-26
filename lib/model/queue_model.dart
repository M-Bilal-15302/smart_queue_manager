class Queue {
  final String id;
  final String branchId;
  final String userId;
  final String userName;
  final String serviceType;
  final int tokenNumber;
  final DateTime bookingTime;
  final DateTime? calledTime;
  final DateTime? completedTime;
  final String status; // 'waiting', 'called', 'completed', 'cancelled'
  final int estimatedWaitTime; // in minutes

  Queue({
    required this.id,
    required this.branchId,
    required this.userId,
    required this.userName,
    required this.serviceType,
    required this.tokenNumber,
    required this.bookingTime,
    this.calledTime,
    this.completedTime,
    required this.status,
    required this.estimatedWaitTime,
  });

  factory Queue.fromMap(Map<String, dynamic> data, String id) {
    return Queue(
      id: id,
      branchId: data['branchId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      serviceType: data['serviceType'] ?? '',
      tokenNumber: data['tokenNumber'] ?? 0,
      bookingTime: DateTime.parse(data['bookingTime']),
      calledTime: data['calledTime'] != null ? DateTime.parse(data['calledTime']) : null,
      completedTime: data['completedTime'] != null ? DateTime.parse(data['completedTime']) : null,
      status: data['status'] ?? 'waiting',
      estimatedWaitTime: data['estimatedWaitTime'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'branchId': branchId,
      'userId': userId,
      'userName': userName,
      'serviceType': serviceType,
      'tokenNumber': tokenNumber,
      'bookingTime': bookingTime.toIso8601String(),
      'calledTime': calledTime?.toIso8601String(),
      'completedTime': completedTime?.toIso8601String(),
      'status': status,
      'estimatedWaitTime': estimatedWaitTime,
    };
  }
}