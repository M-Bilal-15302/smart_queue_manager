import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../model/token_model.dart';

class HistoryController extends GetxController {
  final tokens = <AdminToken>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void onInit() {
    super.onInit();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    print("-----$userId");
    _loadTokens();
  }
  Future<GetxController> init() async {
    await _fetchInitialData();
    return this;
  }
  Future<void> _fetchInitialData() async {
    await Future.wait([_loadTokens()]);
  }
  Future<void> _loadTokens() async {
    try {
      final snapshot = await _firestore.collection('tokens')
          // .orderBy('createdAt', descending: true)
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
  // Future<void> fetchUserTokens() async {
  //   final userId = FirebaseAuth.instance.currentUser?.uid;
  //   print("Check userIDs-----$userId");
  //
  //   final snapshot = await _firestore
  //       .collection('tokens')
  //       .get();
  //
  //   tokens.value = snapshot.docs.map((doc) => AdminToken.fromFirestore(doc)).toList();
  // }

}
