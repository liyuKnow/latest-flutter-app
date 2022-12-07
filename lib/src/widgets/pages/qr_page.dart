import 'package:flutter/material.dart';

import 'package:latest_app/src/widgets/pages/update_found_user.dart';
import 'package:latest_app/src/widgets/common/custom_snack_bar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRPage extends StatefulWidget {
  const QRPage({super.key, required this.userId});

  final int userId;
  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Scan for User ${widget.userId}"),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state as CameraFacing) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
          allowDuplicates: true,
          controller: cameraController,
          onDetect: _foundbarCode),
    );
  }

  _foundbarCode(Barcode barcode, MobileScannerArguments? args) {
    /// open screen
    if (!_screenOpened) {
      final String code = barcode.rawValue ?? "---";
      if (code == widget.userId.toString()) {
        // ^ GOTO OUR UPDATE PAGE
        // print("it is a match $code");
        // const UpdateUser();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateFoundUser(
                  screenClosed: _screenWasClosed,
                  value: code,
                  userId: widget.userId),
            ));
      } else {
        // ^ SHOW ERROR SNACK AND RETURN TO LIST
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //   content: CustomSnackBar(
        //     cardColor: Color(0xFFC72C41),
        //     bubbleColor: Color(0xFF801336),
        //     title: "Oh Snap",
        //     message: "No it is not our id",
        //   ),
        //   behavior: SnackBarBehavior.floating,
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ));
      }
    }
  }

  void _screenWasClosed() {
    _screenOpened = false;
  }
}
