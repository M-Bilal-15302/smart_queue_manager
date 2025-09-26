// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// class AuthService extends GetxService {
//   var isLoggedIn = false.obs;
//   var isAdmin = false.obs;
//   var userId = ''.obs;
//
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<AuthService> init() async {
//     print('[AuthService] Initializing...');
//     await Future.delayed(const Duration(milliseconds: 500));
//     isLoggedIn.value = false;
//     isAdmin.value = false;
//     print('[AuthService] Initialized: isLoggedIn=${isLoggedIn.value}, isAdmin=${isAdmin.value}');
//     return this;
//   }
//
//   /// Check if email exists in Firestore `users` collection
//   Future<bool> isEmailRegistered(String email) async {
//     final result = await _firestore
//         .collection('users')
//         .where('email', isEqualTo: email)
//         .get();
//     return result.docs.isNotEmpty;
//   }
//
//   Future<void> login(String email, String password) async {
//     // TODO: Replace with actual FirebaseAuth signInWithEmailAndPassword
//     await Future.delayed(Duration(seconds: 1));
//     isLoggedIn.value = true;
//     userId.value = 'user_${DateTime.now().millisecondsSinceEpoch}';
//   }
//
//   Future<void> adminLogin(String email, String password) async {
//     await Future.delayed(Duration(seconds: 1));
//     isLoggedIn.value = true;
//     isAdmin.value = true;
//     userId.value = 'admin_${DateTime.now().millisecondsSinceEpoch}';
//   }
//
//   Future<void> register(String email, String password, String name) async {
//     try {
//       // Create user in Firebase Authentication
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);
//       await _firestore.collection('users').doc(userCredential.user!.uid).set({
//         'email': email,
//         'name': name,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//
//       // Update state
//       isLoggedIn.value = true;
//       isAdmin.value = false;
//       userId.value = userCredential.user!.uid;
//     } on FirebaseAuthException catch (e) {
//       throw Exception(e.message);
//     } catch (e) {
//       throw Exception('Unexpected error: ${e.toString()}');
//     }
//   }
//
//   Future<void> logout() async {
//     isLoggedIn.value = false;
//     isAdmin.value = false;
//     userId.value = '';
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final RxBool isLoggedIn = false.obs;
  final RxBool isAdmin = false.obs;
  final RxString userId = ''.obs;
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoading = false.obs;
  final Rx<User?> _currentUser = Rx<User?>(null);
  User? get currentUser => _currentUser.value;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<AuthService> init() async {
    // Auto-login if user is already authenticated
    _auth.authStateChanges().listen((User? user) async {
      _currentUser.value = user;
      if (user != null) {
        await _handleLoggedInUser(user);
      } else {
        _handleLoggedOutUser();
      }
    });
    return this;
  }

  Future<void> _handleLoggedInUser(User user) async {
    try {
      isLoading.value = true;
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        isLoggedIn.value = true;
        isAdmin.value = userData['isAdmin'] ?? false;
        userId.value = user.uid;
        userName.value = userData['name'] ?? '';
        userEmail.value = user.email ?? '';

        print('[AuthService] User logged in: ${user.email} (Admin: ${isAdmin.value})');
      } else {
        await _auth.signOut();
        throw Exception('User document not found');
      }
    } catch (e) {
      errorMessage.value = 'Error loading user data: ${e.toString()}';
      print('[AuthService] Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void _handleLoggedOutUser() {
    isLoggedIn.value = false;
    isAdmin.value = false;
    userId.value = '';
    userName.value = '';
    userEmail.value = '';
    print('[AuthService] User logged out');
  }

  Future<bool> isEmailRegistered(String email) async {
    try {
      final result = await _firestore
          .collection('users')
          .where('email', isEqualTo: email.toLowerCase())
          .limit(1)
          .get();
      return result.docs.isNotEmpty;
    } catch (e) {
      print('[AuthService] Error checking email: ${e.toString()}');
      return false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await _handleLoggedInUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getAuthErrorMessage(e);
      print('[AuthService] Login error: ${e.code}');
    } catch (e) {
      errorMessage.value = 'Login failed: ${e.toString()}';
      print('[AuthService] Login error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> adminLogin(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // First login normally
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Then verify admin status
      final userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      if (userDoc.exists && (userDoc.data()?['isAdmin'] == true)) {
        await _handleLoggedInUser(userCredential.user!);
      } else {
        await _auth.signOut();
        throw Exception('Administrator privileges required');
      }
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getAuthErrorMessage(e);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    bool admin = false,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Create auth user
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Create user document
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email.toLowerCase(),
        'name': name.trim(),
        'isAdmin': admin,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _handleLoggedInUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getAuthErrorMessage(e);
    } catch (e) {
      errorMessage.value = 'Registration failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _auth.signOut();
      _currentUser.value = null;
      _handleLoggedOutUser();
    } catch (e) {
      errorMessage.value = 'Logout failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getAuthErrorMessage(e);
    } catch (e) {
      errorMessage.value = 'Password reset failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({String? name, String? email, String? password}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final user = _auth.currentUser;

      if (user == null) throw Exception('Not authenticated');

      // Update email if changed
      if (email != null && email.trim() != user.email) {
        await user.verifyBeforeUpdateEmail(email.trim());
      }

      // Update password if changed
      if (password != null && password.isNotEmpty) {
        await user.updatePassword(password);
      }

      // Update Firestore document
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null) updates['name'] = name.trim();
      if (email != null) updates['email'] = email.trim().toLowerCase();

      await _firestore.collection('users').doc(user.uid).update(updates);

      // Refresh user data
      await _handleLoggedInUser(user);
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getAuthErrorMessage(e);
    } catch (e) {
      errorMessage.value = 'Profile update failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'weak-password':
        return 'Password should be at least 6 characters';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}