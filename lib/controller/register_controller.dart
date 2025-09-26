// app/modules/register/register_controller.dart
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../routs/routs.dart';
import '../service/auth_services.dart';

class RegisterController extends GetxController {
  final AuthService _authService = Get.find();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        Get.snackbar('Error', 'Passwords do not match');
        return;
      }

      isLoading.value = true;
      try {
        await _authService.register(
         email:  emailController.text.trim(),
        password:   passwordController.text.trim(),
         name:  nameController.text.trim(),
        );
        Get.offAllNamed(Routes.LOGIN);

      } catch (e) {
        Get.snackbar('Error', 'Registration failed: ${e.toString()}');
        print("Check register error 2222  ${e.toString()}");
      } finally {
        isLoading.value = false;
      }
    }
  }
}