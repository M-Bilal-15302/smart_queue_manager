import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../controller/checkin_controller.dart';

class QRScannerView extends StatelessWidget {
  QRScannerView({super.key});

  final CheckInController controller = Get.put(CheckInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller.scannerController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                controller.processScannedCode(barcode.rawValue ?? '');
              }
            },
          ),
          _buildScannerOverlay(context),
          _buildFlashToggle(),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildFlashToggle() {
    return Obx(() => Positioned(
      right: 20,
      top: 20,
      child: IconButton(
        icon: Icon(
          controller.flashEnabled.value
              ? Icons.flash_on
              : Icons.flash_off,
          color: Colors.white,
        ),
        onPressed: controller.toggleFlash,
      ),
    ));
  }
}