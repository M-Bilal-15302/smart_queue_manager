import 'package:flutter/material.dart';
import 'package:get/get.dart';
enum SnackType { success, error, info }
class Utils {

  static void showSnackBar(String message, SnackType type) {
    Icon icon;
    Color background;
    Color textColor;

    switch (type) {
      case SnackType.success:
        icon = const Icon(Icons.check_circle, color: Colors.white);
        background = Colors.green.shade600;
        textColor = Colors.white;
        break;
      case SnackType.error:
        icon = const Icon(Icons.error, color: Colors.white);
        background = Colors.red.shade400;
        textColor = Colors.white;
        break;
      case SnackType.info:
      default:
        icon = const Icon(Icons.info, color: Colors.white);
        background = Colors.blueAccent;
        textColor = Colors.white;
        break;
    }

    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: background,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        borderRadius: 12,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        snackPosition: SnackPosition.TOP,
        isDismissible: true,
        barBlur: 10,
        messageText: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

