
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_queue_awkum/service/queue_services.dart';
import '../model/QueueState.dart';
import '../model/token_model.dart';

class AdminService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final counters = <Counter>[].obs;
  final tokens = <AdminToken>[].obs;
  final stats = QueueStats().obs;

  @override
  void onInit() {
    super.onInit();
    _setupRealtimeListeners();
  }

  Future<AdminService> init() async {
    await _fetchInitialData();
    return this;
  }

  Future<void> _fetchInitialData() async {
    await Future.wait([_loadCounters(), _loadTokens(), _loadStats()]);
  }

  // Update token status
  Future<void> updateTokenStatus(String tokenId, String status) async {
    await _firestore.collection('tokens').doc(tokenId).update({
      'status': status,
      ' ': FieldValue.serverTimestamp(),
    });
  }

  // Load counters from Firestore
  Future<void> _loadCounters() async {
    try {
      final snapshot = await _firestore.collection('counters').get();
      counters.assignAll(
          snapshot.docs.map((doc) => Counter.fromFirestore(doc)).toList());
    } catch (e) {
      Get.snackbar('Error', 'Failed to load counters');
      print("Check error loadCounter----$e");
      rethrow;
    }
  }

  // Load tokens from Firestore
  Future<void> _loadTokens() async {
    try {
      final snapshot = await _firestore.collection('tokens')
          .orderBy('createdAt', descending: true)
          .limit(100)
          .get();

      tokens.assignAll(
          snapshot.docs.map((doc) => AdminToken.fromFirestore(doc)).toList());
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tokens');
      print("Check error loadToken----$e");
      rethrow;
    }
  }

  // Load stats from Firestore
  Future<void> _loadStats() async {
    try {
      final doc = await _firestore.collection('queue_stats').doc('current').get();
      stats.value = QueueStats.fromFirestore(doc);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load queue stats');
      print("Check error queue status----$e");
      rethrow;
    }
  }

  // Real-time listener for token updates
  Stream<AdminToken> get tokenStream {
    return _firestore.collection('tokens').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => AdminToken.fromFirestore(doc)).first;
    });
  }

  void _setupRealtimeListeners() {
    _firestore.collection('tokens')
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots()
        .listen((snapshot) {
      tokens.assignAll(
          snapshot.docs.map((doc) => AdminToken.fromFirestore(doc)).toList());
    });

    _firestore.collection('counters').snapshots().listen((snapshot) {
      counters.assignAll(
          snapshot.docs.map((doc) => Counter.fromFirestore(doc)).toList());
    });

    _firestore.collection('queue_stats').doc('current')
        .snapshots()
        .listen((doc) {
      stats.value = QueueStats.fromFirestore(doc);
    });
  }

  // Get all tokens
  Future<List<AdminToken>> getTokens() async {
    final snapshot = await _firestore.collection('tokens').get();
    return snapshot.docs.map((doc) => AdminToken.fromFirestore(doc)).toList();
  }

  // Call a token (update status to 'called')
  Future<void> callToken(String tokenId, String counterId) async {
    try {
      final batch = _firestore.batch();

      // Update token status
      final tokenRef = _firestore.collection('tokens').doc(tokenId);
      batch.update(tokenRef, {
        'status': 'called',
        'calledAt': FieldValue.serverTimestamp(),
        'counterId': counterId,
      });

      // Update counter status
      final counterRef = _firestore.collection('counters').doc(counterId);
      batch.update(counterRef, {
        'currentToken': tokenId,
        'status': 'busy',
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      // Update stats
      final statsRef = _firestore.collection('queue_stats').doc('current');
      batch.update(statsRef, {
        'calledTokens': FieldValue.increment(1),
        'waitingTokens': FieldValue.increment(-1),
      });

      await batch.commit();
    } catch (e) {
      Get.snackbar('Error', 'Failed to call token: ${e.toString()}');
      print("Check error call tokens----$e");
      rethrow;
    }
  }

  // Complete a token (update status to 'completed')
  Future<void> completeToken(String tokenId, String counterId) async {
    try {
      final batch = _firestore.batch();

      // Update token status
      final tokenRef = _firestore.collection('tokens').doc(tokenId);
      batch.update(tokenRef, {
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
      });

      // Update counter status
      final counterRef = _firestore.collection('counters').doc(counterId);
      batch.update(counterRef, {
        'currentToken': null,
        'status': 'available',
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      // Update stats
      final statsRef = _firestore.collection('queue_stats').doc('current');
      batch.update(statsRef, {
        'completedTokens': FieldValue.increment(1),
      });

      await batch.commit();
    } catch (e) {
      Get.snackbar('Error', 'Failed to complete token: ${e.toString()}');
      print("Check error complete tokens----$e");
      rethrow;
    }
  }

  // Cancel a token (update status to 'cancelled')
  Future<void> cancelToken(String tokenId) async {
    try {
      await _firestore.collection('tokens').doc(tokenId).update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('queue_stats').doc('current').update({
        'cancelledTokens': FieldValue.increment(1),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel token: ${e.toString()}');
      print("Check error cancelToken----$e");
      rethrow;
    }
  }

  // Add a counter
  Future<void> addCounter(String name, String type) async {
    try {
      await _firestore.collection('counters').add({
        'name': name,
        'type': type,
        'status': 'available',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to add counter');
      print("Check error add ..Counter----$e");
      rethrow;
    }
  }

  // Log out the user
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      Get.snackbar('Error', 'Failed to logout');
      rethrow;
    }
  }

  // Book a token and save to Firestore
  Future<Response> bookToken(String serviceType, DateTime date, TimeOfDay time) async {
    try {
      final tokenData = {
        'serviceType': serviceType,
        'date': date.toIso8601String(),
        'time': time.format(Get.context!),
        'status': 'waiting',
        'createdAt': FieldValue.serverTimestamp(),
      };
      await _firestore.collection('tokens').add(tokenData);

      return Response(
        isSuccessful: true,
        message: "Token successfully booked for $serviceType on ${date.toLocal()} at ${time.format(Get.context!)}",
      );
    } catch (e) {
      return Response(
        isSuccessful: false,
        message: "Failed to book the token: ${e.toString()}",
      );
    }
  }
}

class Response {
  final bool isSuccessful;
  final String message;

  Response({required this.isSuccessful, required this.message});
}
