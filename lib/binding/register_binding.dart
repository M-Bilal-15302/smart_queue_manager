// app/modules/register/register_binding.dart
import 'package:get/get.dart';
import '../controller/register_controller.dart';

// app/bindings/register_binding.dart
class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    print('Initializing RegisterBinding');
    Get.lazyPut<RegisterController>(
          () => RegisterController(),
      fenix: true, // Optional: keeps controller alive when not in use
    );
  }
}