import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/register_controller.dart';
import '../util/app_color.dart';

class RegisterView extends GetView<RegisterController> {
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
              Center(
                child: Column(
                  children: const [
                    Icon(Icons.app_registration_rounded, size: 72, color: appBlueColor),
                    SizedBox(height: 10),
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: appBlueColor,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Register to get started',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              _buildTextField(
                label: 'Full Name',
                icon: Icons.person,
                controller: controller.nameController,
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 20),

              _buildTextField(
                label: 'Email',
                icon: Icons.email,
                controller: controller.emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your email';
                  if (!value.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _buildTextField(
                label: 'Password',
                icon: Icons.lock,
                controller: controller.passwordController,
                obscure: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter password';
                  if (value.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _buildTextField(
                label: 'Confirm Password',
                icon: Icons.lock_outline,
                controller: controller.confirmPasswordController,
                obscure: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please confirm password';
                  if (value != controller.passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appBlueColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Text('Register', style: TextStyle(fontSize: 16,color: Colors.white)),
                ),
              )),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Already have an account? Login',
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

  /// Common styled input field
  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool obscure = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: appBlueColor),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: appBlueColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
