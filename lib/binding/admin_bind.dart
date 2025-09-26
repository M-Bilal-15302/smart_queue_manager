// app/modules/admin/admin_binding.dart
import 'package:get/get.dart';
import '../controller/admin_controller.dart';
import '../service/admin_services.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminController>(() => AdminController());
    Get.lazyPut<AdminService>(
          () => AdminService(),
      fenix: true,
    );
  }

}