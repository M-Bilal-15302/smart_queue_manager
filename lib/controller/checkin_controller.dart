import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../service/queue_services.dart';

class CheckInController extends GetxController {
  final MobileScannerController scannerController = MobileScannerController();
  final RxBool flashEnabled = false.obs;
  final RxBool isLoading = false.obs;
  final RxString checkInMessage = ''.obs;
  final RxBool checkInSuccess = false.obs;

  void toggleFlash() {
    flashEnabled.value = !flashEnabled.value;
    scannerController.toggleTorch();
  }

  Future<void> processScannedCode(String code) async {
    if (isLoading.value || code.isEmpty) return;

    isLoading.value = true;
    checkInMessage.value = '';
    checkInSuccess.value = false;

    try {
      // Validate and process the QR code
      final isValid = await QueueService().validateBooking(code);

      if (isValid) {
        // Mark user as checked in
        await QueueService().checkInBooking(code);
        checkInMessage.value = 'Check-in successful!';
        checkInSuccess.value = true;
      } else {
        checkInMessage.value = 'Invalid QR code';
        checkInSuccess.value = false;
      }
    } catch (e) {
      checkInMessage.value = 'Error processing QR code: ${e.toString()}';
      checkInSuccess.value = false;
    } finally {
      isLoading.value = false;
      // Stop scanning after successful check-in
      if (checkInSuccess.value) {
        scannerController.stop();
      }
    }
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}