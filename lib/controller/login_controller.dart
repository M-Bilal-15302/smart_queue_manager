// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import '../routs/routs.dart';
// import '../service/auth_services.dart';
//
// class LoginController extends GetxController {
//   final AuthService _authService = Get.find();
//
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   var isLoading = false.obs;
//   var isAdminLogin = false.obs;
//
//   Future<void> login() async {
//     if (formKey.currentState!.validate()) {
//       isLoading.value = true;
//       try {
//         // ✅ Check if email is in Firebase database
//         bool emailExists = await _authService.isEmailRegisteredInDatabase(
//           emailController.text.trim(),
//         );
//
//         if (!emailExists) {
//           Get.snackbar('Unauthorized', 'This email is not allowed to login.');
//           return;
//         }
//
//         if (isAdminLogin.value) {
//           await _authService.adminLogin(
//             emailController.text.trim(),
//             passwordController.text.trim(),
//           );
//           Get.offAllNamed(Routes.ADMIN);
//         } else {
//           await _authService.login(
//             emailController.text.trim(),
//             passwordController.text.trim(),
//           );
//           Get.offAllNamed(Routes.HOME);
//         }
//       } catch (e) {
//         Get.snackbar('Error', 'Login failed: ${e.toString()}');
//       } finally {
//         isLoading.value = false;
//       }
//     }
//   }
//
//
//   void toggleLoginType() {
//     isAdminLogin.value = !isAdminLogin.value;
//   }
//
//   @override
//   void onClose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../routs/routs.dart';
import '../service/auth_services.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var isAdminLogin = false.obs;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    isLoading.value = true;
    try {
      // 🔎 Check if email is registered
      bool exists = await _authService.isEmailRegistered(email);
      if (!exists) {
        Get.snackbar('Unauthorized', 'This email is not allowed to login.');
        return;
      }

      if (isAdminLogin.value) {
        await _authService.adminLogin(email, password);
        Get.offAllNamed(Routes.ADMIN);
      } else {
        await _authService.login(email, password);
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleLoginType() => isAdminLogin.value = !isAdminLogin.value;
}
