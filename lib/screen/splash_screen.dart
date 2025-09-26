// app/modules/splash/splash_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/splash_controller.dart';
class SplashView extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    debugPrint('[SplashView] Building UI');

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_alt, size: 80),
            const SizedBox(height: 20),
            const Text('Smart Queue Manager', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 30),
            const CircularProgressIndicator(),
            Obx(() {
              if (!controller.isLoading.value) {
                debugPrint('[SplashView] Loading complete but still showing - this should not happen');
              }
              return const SizedBox();
            }),
          ],
        ),
      ),
    );
  }
}
// class SplashView extends GetView<SplashController> {
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Colors.blue,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.people_alt, size: 80, color: Colors.white),
//             SizedBox(height: 20),
//             Text(
//               'Smart Queue Manager',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(height: 10),
//             CircularProgressIndicator(color: Colors.white),
//           ],
//         ),
//       ),
//     );
//   }
// }