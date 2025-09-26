// // app/modules/splash/splash_controller.dart
import 'package:get/get.dart';
import '../routs/routs.dart';
import '../service/auth_services.dart';
//
// class SplashController extends GetxController {
//   final AuthService _authService = Get.find();
//
//   // @override
//   // void onInit() {
//   //   super.onInit();
//   //   _init();
//   // }
//   @override
//   void onReady() {
//     // Changed from onInit to onReady
//     super.onReady();
//     _init();
//   }
//
//   Future<void> _init() async {
//     await Future.delayed(const Duration(seconds: 2));
//     Get.offNamed(Routes.LOGIN);
//     if (_authService.isLoggedIn.value) {
//       if (_authService.isAdmin.value) {
//         Get.offNamed(Routes.ADMIN);
//       } else {
//         Get.offNamed(Routes.HOME);
//       }
//     } else {
//       Get.offNamed(Routes.LOGIN);
//     }
//   }
// }

class SplashController extends GetxController {
  final AuthService authService = Get.find();
  final RxBool isLoading = true.obs;

  @override
  void onReady() {
    super.onReady();
    print('[SplashController] Ready, starting navigation check');
    _navigateToAppropriateScreen();
  }

  Future<void> _navigateToAppropriateScreen() async {
    try {
      print('[SplashController] Checking auth state...');

      // Wait for services to be fully ready
      await Future.delayed(const Duration(milliseconds: 300));

      // Verify services are registered
      if (!Get.isRegistered<AuthService>()) {
        throw 'AuthService not registered';
      }

      print('[SplashController] Auth state: '
          'isLoggedIn=${authService.isLoggedIn.value}, '
          'isAdmin=${authService.isAdmin.value}');

      // Determine route based on auth state
      final String route;
      if (authService.isLoggedIn.value) {
        route = authService.isAdmin.value ? Routes.ADMIN : Routes.HOME;
      } else {
        route = Routes.LOGIN;
      }

      print('[SplashController] Navigating to $route');
      Get.offAllNamed(route);

    } catch (e) {
      print('[SplashController] Navigation error: $e');
      // Emergency fallback
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      isLoading.value = false;
    }
  }
}