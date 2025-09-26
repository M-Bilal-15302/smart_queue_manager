import 'package:get/get.dart';
import '../controller/counter_controller.dart';

class CounterBinding extends Bindings {
  @override
  void dependencies() {
    print('Initializing CounterBinding');
    Get.lazyPut<CounterController>(() => CounterController());
  }
}
