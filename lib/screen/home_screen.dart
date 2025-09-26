// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:samrt_queue/util/app_color.dart';
// import '../routs/routs.dart';
// import 'booking_screen.dart';
// import 'counter_screen.dart';
// import 'history_screen.dart';
// import 'queue_status.dart';
// class HomeView extends StatelessWidget {
//   final RxInt currentIndex = 0.obs;
//
//   // Pages for each section
//   final List<Widget> _pages = [
//     QueueView(),       // index 0
//     BookingView(),     // index 1
//     HistoryView(),     // index 2
//     CounterView(),     // index 3
//   ];
//   // Titles for AppBar
//   final List<String> _titles = [
//     'Queue Status',
//     'Book Token',
//     'History',
//     'Manage Counters',
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       drawer: _buildDrawer(context),
//       appBar: AppBar(
//         backgroundColor: appBlueColor,
//         elevation: 0,
//         title: Obx(() => Text(
//           _titles[currentIndex.value],
//           style: const TextStyle(color: Colors.white),
//         )),
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               Get.defaultDialog(
//                 title: "Logout",
//                 content: const Text("Are you sure you want to logout?"),
//                 confirm: ElevatedButton(
//                   onPressed: () {
//                     Get.offNamed(Routes.LOGIN);
//                   },
//                   child: const Text("Yes"),
//                 ),
//                 cancel: TextButton(
//                   onPressed: () => Get.back(),
//                   child: const Text("Cancel"),
//                 ),
//               );
//             },
//           )
//         ],
//       ),
//       body: Obx(() => _pages[currentIndex.value]),
//     );
//   }
//
//   Widget _buildDrawer(BuildContext context) {
//     return Drawer(
//       child: SafeArea(
//         child: Column(
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: appBlueColor,
//               ),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Colors.white,
//                     child: Icon(Icons.person, size: 30, color: appBlueColor),
//                   ),
//                   SizedBox(width: 16),
//                   Text(
//                     'Welcome, User',
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                 ],
//               ),
//             ),
//             _buildDrawerItem(
//               icon: Icons.home,
//               text: 'Queue Status',
//               index: 0,
//             ),
//             _buildDrawerItem(
//               icon: Icons.add,
//               text: 'Book Token',
//               index: 1,
//             ),
//             _buildDrawerItem(
//               icon: Icons.history,
//               text: 'History',
//               index: 2,
//             ),
//             _buildDrawerItem(
//               icon: Icons.desktop_windows,
//               text: 'Manage Counters',
//               index: 3,
//             ),
//             const Spacer(),
//             const Divider(),
//             ListTile(
//               leading: const Icon(Icons.exit_to_app, color: Colors.red),
//               title: const Text('Logout', style: TextStyle(color: Colors.red)),
//               onTap: () {
//                 Get.back(); // Close drawer
//                 Get.defaultDialog(
//                   title: "Logout",
//                   content: const Text("Are you sure you want to logout?"),
//                   confirm: ElevatedButton(
//                     onPressed: () {
//                       // TODO: Add logout logic
//                       Get.back();
//                     },
//                     child: const Text("Yes"),
//                   ),
//                   cancel: TextButton(
//                     onPressed: () => Get.back(),
//                     child: const Text("Cancel"),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDrawerItem({
//     required IconData icon,
//     required String text,
//     required int index,
//   }) {
//     return Obx(() {
//       bool isSelected = currentIndex.value == index;
//       return ListTile(
//         leading: Icon(icon, color: isSelected ? appBlueColor : Colors.grey[800]),
//         title: Text(
//           text,
//           style: TextStyle(
//             color: isSelected ? appBlueColor : Colors.black87,
//             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//         selected: isSelected,
//         onTap: () {
//           currentIndex.value = index;
//           Get.back(); // Close drawer
//         },
//       );
//     });
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routs/routs.dart';
import '../util/app_color.dart';
import 'counter_screen.dart';
import 'history_screen.dart';
import 'queue_status.dart';

class HomeView extends StatelessWidget {
  final RxInt currentIndex = 0.obs;

  // Updated pages without BookingView
  final List<Widget> _pages = [
    QueueView(),       // index 0
    HistoryView(),     // index 1
   // CounterView(),     // index 2
  ];

  // Updated titles without "Book Token"
  final List<String> _titles = [
    'Queue Status',
    'History',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: appBlueColor,
        elevation: 0,
        title: Obx(() => Text(
          _titles[currentIndex.value],
          style: const TextStyle(color: Colors.white),
        )),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.defaultDialog(
                title: "Logout",
                content: const Text("Are you sure you want to logout?"),
                confirm: ElevatedButton(
                  onPressed: () {
                    Get.offNamed(Routes.LOGIN);
                  },
                  child: const Text("Yes"),
                ),
                cancel: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Cancel"),
                ),
              );
            },
          )
        ],
      ),
      body: Obx(() => _pages[currentIndex.value]),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: appBlueColor,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 30, color: appBlueColor),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Welcome, User',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.home,
              text: 'Queue Status',
              index: 0,
            ),
            _buildDrawerItem(
              icon: Icons.history,
              text: 'History',
              index: 1,
            ),
            // _buildDrawerItem(
            //   icon: Icons.desktop_windows,
            //   text: 'Manage Counters',
            //   index: 2,
            // ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back(); // Close drawer
                Get.defaultDialog(
                  title: "Logout",
                  content: const Text("Are you sure you want to logout?"),
                  confirm: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Close dialog
                      Get.offAllNamed(Routes.LOGIN); // Navigate to login
                    },
                    child: const Text("Yes"),
                  ),
                  cancel: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required int index,
  }) {
    return Obx(() {
      bool isSelected = currentIndex.value == index;
      return ListTile(
        leading: Icon(icon, color: isSelected ? appBlueColor : Colors.grey[800]),
        title: Text(
          text,
          style: TextStyle(
            color: isSelected ? appBlueColor : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onTap: () {
          currentIndex.value = index;
          Get.back(); // Close drawer
        },
      );
    });
  }
}
