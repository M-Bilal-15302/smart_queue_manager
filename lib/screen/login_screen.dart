import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';
import '../routs/routs.dart';
import '../util/app_color.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Center(
                child: Column(
                  children: [
                    Icon(Icons.lock_outline_rounded, size: 72, color:appBlueColor),
                    SizedBox(height: 10),
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color:appBlueColor,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Please login to continue',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              Obx(() => SwitchListTile(
                title: const Text('Admin Login'),
                value: controller.isAdminLogin.value,
                onChanged: (value) => controller.toggleLoginType(),
                activeColor: appBlueColor,
              )),
              const SizedBox(height: 20),

              TextFormField(
                controller: controller.emailController,
                decoration: _inputDecoration(label: 'Email', icon: Icons.email),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: controller.passwordController,
                obscureText: true,
                decoration: _inputDecoration(label: 'Password', icon: Icons.lock),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appBlueColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: controller.isLoading.value ? null : controller.login,
                  child: controller.isLoading.value
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Text('Login', style: TextStyle(fontSize: 16,color: Colors.white)),
                ),
              )),
              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () => Get.toNamed(Routes.REGISTER),
                  child: const Text(
                    'Don\'t have an account? Register here',
                    style: TextStyle(color: appBlueColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: appBlueColor),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color:appBlueColor),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
