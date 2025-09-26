//
//
//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
//
// class QueueService extends GetxService {
//   final activeQueues = <QueueItem>[].obs;
//   final myTokens = <Token>[].obs;
//   final counters = <Counter>[].obs;
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   Future<QueueService> init() async {
//     _db.collection('queues')
//         .snapshots()
//         .listen((snapshot) {
//       final list = snapshot.docs.map((doc) {
//         final data = doc.data();
//         return QueueItem(
//           id: doc.id,
//           name: data['name'] ?? '',
//           type: data['type'] ?? '',
//           currentToken: data['currentToken'] ?? '',
//           waitingTime: data['waitingTime'] ?? 0,
//           nextAvailable: (data['nextAvailable'] as Timestamp?)?.toDate(),
//         );
//       }).toList();
//       activeQueues.assignAll(list);
//     });
//     return this;
//   }
//
//
//
//   // Future<QueueService> init() async {
//   //   _db.collection('tokens')
//   //       .orderBy('bookedAt', descending: true)
//   //       .snapshots()
//   //       .listen((snapshot) {
//   //     myTokens.assignAll(snapshot.docs.map((doc) {
//   //       final data = doc.data();
//   //       return Token(
//   //         id: doc.id,
//   //         queueId: data['queueId'],
//   //         number: data['number'],
//   //         status: data['status'],
//   //         bookedAt: (data['bookedAt'] as Timestamp).toDate(),
//   //         estimatedTime: (data['estimatedTime'] as Timestamp).toDate(),
//   //       );
//   //     }).toList());
//   //   });
//   //   return this;
//   // }
//
//
//
//
//   // Book a token
//   Future<String> bookToken(String queueId, String serviceType) async {
//     await Future.delayed(Duration(seconds: 1));
//     final token = Token(
//       id: 'T${DateTime.now().millisecondsSinceEpoch}',
//       queueId: queueId,
//       number: '${myTokens.length + 100}',
//       status: 'Waiting',
//       bookedAt: DateTime.now(),
//       estimatedTime: DateTime.now().add(const Duration(minutes: 1)),
//     );
//     myTokens.add(token);
//     return token.id;
//   }
//
//   // Call next token
//   Future<void> callNextToken(String counterId) async {
//     try {
//       final counterIndex = counters.indexWhere((c) => c.id == counterId);
//       if (counterIndex == -1) throw 'Counter not found';
//
//       final nextToken = _generateNextToken(counters[counterIndex].currentToken);
//
//       counters[counterIndex] = counters[counterIndex].copyWith(
//         status: 'Busy',
//         currentToken: nextToken,
//         lastCalled: DateTime.now(),
//       );
//
//       counters.refresh();
//       print('Called token $nextToken at ${counters[counterIndex].name}');
//     } catch (e) {
//       print('Error calling token: $e');
//       rethrow;
//     }
//   }
//
//   // Complete current token
//   Future<void> completeCurrentToken(String counterId) async {
//     try {
//       final index = counters.indexWhere((c) => c.id == counterId);
//       if (index == -1) throw 'Counter not found';
//
//       counters[index] = counters[index].copyWith(
//         currentToken: null,
//         status: 'Available',
//         lastCalled: DateTime.now(),
//       );
//
//       counters.refresh();
//       print('Token at counter ${counters[index].name} marked as completed.');
//     } catch (e) {
//       print('Error completing token: $e');
//       rethrow;
//     }
//   }
//
//   // Skip current token
//   Future<void> skipCurrentToken(String counterId) async {
//     try {
//       final index = counters.indexWhere((c) => c.id == counterId);
//       if (index == -1) throw 'Counter not found';
//
//       final skippedToken = counters[index].currentToken ?? 'Unknown';
//       final nextToken = _generateNextToken(skippedToken);
//
//       counters[index] = counters[index].copyWith(
//         currentToken: nextToken,
//         status: 'Busy',
//         lastCalled: DateTime.now(),
//       );
//
//       counters.refresh();
//       print('Skipped token $skippedToken. Assigned new token $nextToken.');
//     } catch (e) {
//       print('Error skipping token: $e');
//       rethrow;
//     }
//   }
//
//   // Token generation logic
//   String _generateNextToken(String? currentToken) {
//     return 'T${DateTime.now().millisecondsSinceEpoch}';
//   }
// }
// class QueueItem {
//   final String id;
//   final String name;
//   final String type;
//   final int waitingTime;
//   final String currentToken;
//   final DateTime? nextAvailable;
//
//   QueueItem({
//     required this.id,
//     required this.name,
//     required this.type,
//     this.waitingTime = 0,
//     required this.currentToken,
//     this.nextAvailable,
//   });
// }
//
// class Token {
//   final String id;
//   final String queueId;
//   final String number;
//   final String status;
//   final DateTime bookedAt;
//   final DateTime estimatedTime;
//
//   Token({
//     required this.id,
//     required this.queueId,
//     required this.number,
//     required this.status,
//     required this.bookedAt,
//     required this.estimatedTime,
//   });
// }
//
// class Counter {
//   final String id;
//   final String name;
//   final String type;
//   final String status;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final DateTime lastCalled;
//   final String? currentToken;
//   final String? currentServiceType;
//
//   Counter({
//     required this.id,
//     required this.name,
//     required this.type,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.lastCalled,
//     this.currentToken,
//     this.currentServiceType,
//   });
//
//   Counter copyWith({
//     String? id,
//     String? name,
//     String? type,
//     String? status,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     DateTime? lastCalled,
//     String? currentToken,
//     String? currentServiceType,
//   }) {
//     return Counter(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       type: type ?? this.type,
//       status: status ?? this.status,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       lastCalled: lastCalled ?? this.lastCalled,
//       currentToken: currentToken ?? this.currentToken,
//       currentServiceType: currentServiceType ?? this.currentServiceType,
//     );
//   }
//
//   factory Counter.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return Counter(
//       id: doc.id,
//       name: data['name'] ?? 'Unnamed Counter',
//       type: data['type'] ?? 'general',
//       status: data['status'] ?? 'Available',
//       createdAt: (data['createdAt'] as Timestamp).toDate(),
//       updatedAt: (data['updatedAt'] as Timestamp).toDate(),
//       lastCalled: (data['lastCalled'] as Timestamp).toDate(),
//       currentToken: data['currentToken'],
//       currentServiceType: data['currentServiceType'],
//     );
//   }
//
//   Map<String, dynamic> toFirestore() {
//     return {
//       'name': name,
//       'type': type,
//       'status': status,
//       'createdAt': Timestamp.fromDate(createdAt),
//       'updatedAt': Timestamp.fromDate(updatedAt),
//       'lastCalled': Timestamp.fromDate(lastCalled),
//       if (currentToken != null) 'currentToken': currentToken,
//       if (currentServiceType != null) 'currentServiceType': currentServiceType,
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'auth_services.dart';

class QueueService extends GetxService {
  final activeQueues = <QueueItem>[].obs;
  final myTokens = <Token>[].obs;
  final counters = <Counter>[].obs;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<QueueService> init() async {
    // Initialize queues stream
    _db.collection('queues').snapshots().listen((snapshot) {
      activeQueues.assignAll(snapshot.docs.map((doc) => QueueItem.fromFirestore(doc)));
    });

    // Initialize user tokens stream
    final userId = Get.find<AuthService>().currentUser?.uid;
    if (userId != null) {
      _db.collection('tokens')
          .where('userId', isEqualTo: userId)
          .orderBy('bookedAt', descending: true)
          .snapshots()
          .listen((snapshot) {
        myTokens.assignAll(snapshot.docs.map((doc) => Token.fromFirestore(doc)));
      });
    }

    // Initialize counters stream
    _db.collection('counters').snapshots().listen((snapshot) {
      counters.assignAll(snapshot.docs.map((doc) => Counter.fromFirestore(doc)));
    });

    return this;
  }

  // MARK: - Booking Management

  Future<Token> bookToken({
    required String queueId,
    required String serviceType,
    required DateTime scheduledTime,
  }) async {
    try {
      final queueRef = _db.collection('queues').doc(queueId);
      final userId = Get.find<AuthService>().currentUser!.uid;

      // Generate token data
      final tokenId = 'T${DateTime.now().millisecondsSinceEpoch}';
      final tokenNumber = _generateTokenNumber(serviceType);
      final qrCode = 'QUEUE-$queueId-TOKEN-$tokenId-USER-$userId';
      final position = await _calculateQueuePosition(queueId);

      // Create token document
      final token = Token(
        id: tokenId,
        queueId: queueId,
        userId: userId,
        number: tokenNumber,
        status: 'waiting',
        bookedAt: DateTime.now(),
        estimatedTime: scheduledTime,
        qrCode: qrCode,
        position: position,
        serviceType: serviceType,
      );

      final batch = _db.batch();

      // Create token
      batch.set(_db.collection('tokens').doc(tokenId), {
        'queueId': queueId,
        'userId': userId,
        'number': tokenNumber,
        'status': 'waiting',
        'bookedAt': Timestamp.now(),
        'estimatedTime': Timestamp.fromDate(scheduledTime),
        'qrCode': qrCode,
        'position': position,
        'serviceType': serviceType,
      });

      // Update queue length
      batch.update(queueRef, {
        'queueLength': FieldValue.increment(1),
        'lastUpdated': Timestamp.now(),
      });

      await batch.commit();

      return token;
    } catch (e) {
      print('Error booking token: $e');
      rethrow;
    }
  }

  Future<void> createBooking({
    required String queueId,
    required String bookingId,
    required String userId,
    required String tokenNumber,
    required DateTime scheduledTime,
    required int position,
  }) async {
    try {
      // Validate inputs
      if (queueId.isEmpty || bookingId.isEmpty || userId.isEmpty) {
        throw 'Required fields are missing';
      }

      // Generate QR code data
      final qrCode = 'QUEUE-$queueId-BOOKING-$bookingId-USER-$userId';

      // Create booking document
      await _db.collection('bookings').doc(bookingId).set({
        'queueId': queueId,
        'userId': userId,
        'tokenNumber': tokenNumber,
        'qrCode': qrCode,
        'status': 'waiting',
        'position': position,
        'scheduledTime': Timestamp.fromDate(scheduledTime),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update queue counters
      await _db.collection('queues').doc(queueId).update({
        'queueLength': FieldValue.increment(1),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      print('Booking $bookingId created successfully');
    } catch (e) {
      print('Error creating booking: $e');
      rethrow;
    }
  }
  Future<QueueItem> getQueue(String queueId) async {
    try {
      final doc = await _db.collection('queues').doc(queueId).get();

      if (!doc.exists) {
        throw 'Queue not found';
      }

      return QueueItem.fromFirestore(doc);
    } catch (e) {
      print('Error getting queue: $e');
      rethrow;
    }
  }

  Future<bool> validateBooking(String bookingCode) async {
    try {
      if (!bookingCode.startsWith('QUEUE-')) return false;

      final parts = bookingCode.split('-');
      if (parts.length != 6) return false;

      final tokenId = parts[3];
      final tokenDoc = await _db.collection('tokens').doc(tokenId).get();

      return tokenDoc.exists &&
          tokenDoc['qrCode'] == bookingCode &&
          tokenDoc['status'] == 'waiting';
    } catch (e) {
      print('Validation error: $e');
      return false;
    }
  }

  Future<void> checkInBooking(String bookingCode) async {
    try {
      final isValid = await validateBooking(bookingCode);
      if (!isValid) throw 'Invalid booking';

      final parts = bookingCode.split('-');
      final tokenId = parts[3];
      final queueId = parts[1];
      final userId = parts[5];

      final batch = _db.batch();
      final tokenRef = _db.collection('tokens').doc(tokenId);
      final queueRef = _db.collection('queues').doc(queueId);

      // Update token status
      batch.update(tokenRef, {
        'status': 'checked-in',
        'checkedInAt': Timestamp.now(),
      });

      // Update queue active count
      batch.update(queueRef, {
        'activeCount': FieldValue.increment(1),
        'lastUpdated': Timestamp.now(),
      });

      // Add activity log
      batch.set(_db.collection('activities').doc(), {
        'type': 'check-in',
        'tokenId': tokenId,
        'queueId': queueId,
        'userId': userId,
        'timestamp': Timestamp.now(),
      });

      await batch.commit();
    } catch (e) {
      print('Check-in error: $e');
      rethrow;
    }
  }
  Future<void> skipCurrentToken(String counterId) async {
    try {
      // 1. Validate inputs
      if (counterId.isEmpty) throw 'Invalid counter ID';

      // 2. Get counter reference
      final counterRef = _db.collection('counters').doc(counterId);
      final counterDoc = await counterRef.get();

      if (!counterDoc.exists) throw 'Counter not found';
      if (counterDoc['status'] != 'busy') {
        throw 'Counter is not currently busy';
      }

      // 3. Get current token details
      final currentTokenId = counterDoc['currentToken'];
      if (currentTokenId == null) throw 'No active token to skip';

      // 4. Run transaction to ensure data consistency
      await _db.runTransaction((transaction) async {
        // 5. Mark current token as skipped
        transaction.update(_db.collection('tokens').doc(currentTokenId), {
          'status': 'skipped',
          'skippedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // 6. Get next token for the same service type
        final nextToken = await _getNextTokenForService(
          counterDoc['currentQueueId'],
        );

        // 7. Update counter with new token
        transaction.update(counterRef, {
          'currentToken': nextToken.id,
          'currentTokenNumber': nextToken.number,
          'lastCalled': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // 8. Update new token status
        transaction.update(_db.collection('tokens').doc(nextToken.id), {
          'status': 'in-progress',
          'calledAt': FieldValue.serverTimestamp(),
          'counterId': counterId,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });

      print('Successfully skipped token at counter $counterId');
    } on FirebaseException catch (e) {
      print('Firebase error skipping token: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error skipping token: $e');
      rethrow;
    }
  }
  // MARK: - Counter Operations

  Future<void> callNextToken(String counterId) async {
    try {
      final counterRef = _db.collection('counters').doc(counterId);
      final counterDoc = await counterRef.get();

      if (!counterDoc.exists) throw 'Counter not found';

      // Get next token for this service type
      final nextToken = await _getNextTokenForService(counterDoc['currentQueueId']);

      final batch = _db.batch();

      // Update counter
      batch.update(counterRef, {
        'currentToken': nextToken.id,
        'currentTokenNumber': nextToken.number,
        'status': 'busy',
        'lastCalled': Timestamp.now(),
      });

      // Update token status
      batch.update(_db.collection('tokens').doc(nextToken.id), {
        'status': 'in-progress',
        'calledAt': Timestamp.now(),
        'counterId': counterId,
      });

      await batch.commit();
    } catch (e) {
      print('Error calling next token: $e');
      rethrow;
    }
  }

  Future<void> completeCurrentToken(String counterId) async {
    try {
      final counterRef = _db.collection('counters').doc(counterId);
      final counterDoc = await counterRef.get();

      if (!counterDoc.exists) throw 'Counter not found';
      if (counterDoc['currentToken'] == null) throw 'No active token';

      final batch = _db.batch();

      // Update token
      batch.update(_db.collection('tokens').doc(counterDoc['currentToken']), {
        'status': 'completed',
        'completedAt': Timestamp.now(),
      });

      // Update counter
      batch.update(counterRef, {
        'currentToken': null,
        'currentTokenNumber': null,
        'status': 'available',
        'lastUpdated': Timestamp.now(),
      });

      await batch.commit();
    } catch (e) {
      print('Error completing token: $e');
      rethrow;
    }
  }

  // MARK: - Helper Methods

  String _generateTokenNumber(String prefix) {
    final now = DateTime.now();
    return '$prefix-${now.hour}${now.minute}${now.second}-${now.millisecondsSinceEpoch % 1000}';
  }

  Future<int> _calculateQueuePosition(String queueId) async {
    final count = await _db.collection('tokens')
        .where('queueId', isEqualTo: queueId)
        .where('status', isEqualTo: 'waiting')
        .count()
        .get();
    return count.count! + 1;
  }

  Future<Token> _getNextTokenForService(String queueId) async {
    final query = await _db.collection('tokens')
        .where('queueId', isEqualTo: queueId)
        .where('status', isEqualTo: 'waiting')
       // .where('serviceType', isEqualTo: serviceType)
        .orderBy('bookedAt')
        .limit(1)
        .get();

    if (query.docs.isEmpty) throw 'No waiting tokens for this service';
    return Token.fromFirestore(query.docs.first);
  }
}

// MARK: - Model Classes

class QueueItem {
  final String id;
  final String name;
  final String type;
  final int waitingTime;
  final String currentToken;
  final DateTime? nextAvailable;
  final int queueLength;
  final int activeCount;

  QueueItem({
    required this.id,
    required this.name,
    required this.type,
    this.waitingTime = 0,
    required this.currentToken,
    this.nextAvailable,
    this.queueLength = 0,
    this.activeCount = 0,
  });

  factory QueueItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QueueItem(
      id: doc.id,
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      currentToken: data['currentToken'] ?? '',
      waitingTime: data['waitingTime'] ?? 0,
      nextAvailable: (data['nextAvailable'] as Timestamp?)?.toDate(),
      queueLength: data['queueLength'] ?? 0,
      activeCount: data['activeCount'] ?? 0,
    );
  }
}

class Token {
  final String id;
  final String queueId;
  final String userId;
  final String number;
  final String status;
  final DateTime bookedAt;
  final DateTime estimatedTime;
  final String qrCode;
  final int position;
  final String serviceType;
  final DateTime? calledAt;
  final DateTime? checkedInAt;
  final DateTime? completedAt;
  final String? counterId;

  Token({
    required this.id,
    required this.queueId,
    required this.userId,
    required this.number,
    required this.status,
    required this.bookedAt,
    required this.estimatedTime,
    required this.qrCode,
    required this.position,
    required this.serviceType,
    this.calledAt,
    this.checkedInAt,
    this.completedAt,
    this.counterId,
  });

  factory Token.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Token(
      id: doc.id,
      queueId: data['queueId'],
      userId: data['userId'],
      number: data['number'],
      status: data['status'] ?? 'waiting',
      bookedAt: (data['bookedAt'] as Timestamp).toDate(),
      estimatedTime: (data['estimatedTime'] as Timestamp).toDate(),
      qrCode: data['qrCode'],
      position: data['position'] ?? 0,
      serviceType: data['serviceType'],
      calledAt: (data['calledAt'] as Timestamp?)?.toDate(),
      checkedInAt: (data['checkedInAt'] as Timestamp?)?.toDate(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      counterId: data['counterId'],
    );
  }
}

class Counter {
  final String id;
  final String name;
  final String type;
  final String status;
  final String? currentQueueId;
  final String? currentToken;
  final String? currentTokenNumber;
  final String? currentServiceType;
  final DateTime lastCalled;

  Counter({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    this.currentQueueId,
    this.currentToken,
    this.currentTokenNumber,
    this.currentServiceType,
    required this.lastCalled,
  });

  factory Counter.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Counter(
      id: doc.id,
      name: data['name'] ?? 'Counter',
      type: data['type'] ?? 'general',
      status: data['status'] ?? 'available',
      currentQueueId: data['currentQueueId'],
      currentToken: data['currentToken'],
      currentTokenNumber: data['currentTokenNumber'],
      currentServiceType: data['currentServiceType'],
      lastCalled: (data['lastCalled'] as Timestamp).toDate(),
    );
  }
}