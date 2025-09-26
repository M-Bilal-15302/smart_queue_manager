// app/routes/app_pages.dart
import 'package:get/get.dart';
import 'package:smart_queue_awkum/routs/routs.dart';
import '../binding/admin_bind.dart';
import '../binding/booking_bind.dart';
import '../binding/counter_bind.dart';
import '../binding/history_bind.dart';
import '../binding/home_bind.dart';
import '../binding/login_bind.dart';
import '../binding/notification_bind.dart';
import '../binding/queue_bind.dart';
import '../binding/register_binding.dart';
import '../binding/splash_bind.dart';
import '../screen/add_queue_view.dart';
import '../screen/admin_pannel.dart';
import '../screen/booking_screen.dart';
import '../screen/counter_screen.dart';
import '../screen/history_screen.dart';
import '../screen/home_screen.dart';
import '../screen/login_screen.dart';
import '../screen/notification_view.dart';
import '../screen/other_settings_screen.dart';
import '../screen/queue_status.dart';
import '../screen/register_screen.dart';
import '../screen/splash_screen.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(), // Add this line
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.QUEUE,
      page: () => QueueView(),
      binding: QueueBinding(),
    ),
    GetPage(
      name: Routes.BOOKING,
      page: () => BookingView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: Routes.NOTIFICATIONS,
      page: () => NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: Routes.ADMIN,
      page: () => const AdminView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: Routes.COUNTER,
      page: () => const CounterView(),
      binding: CounterBinding(),
    ),
    GetPage(
      name: Routes.AddQUEUE,
      page: () => AddQueueView()
    ),
    GetPage(
      name: Routes.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(name: Routes.OTHER_SETTINGS, page: () => const OtherSettingsPage()),
  ];
}
