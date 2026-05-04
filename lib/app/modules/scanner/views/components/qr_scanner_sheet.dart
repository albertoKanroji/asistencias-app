import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../constants/scanner_constants.dart';

class QrScannerSheet extends StatefulWidget {
  const QrScannerSheet({required this.onCodeDetected, super.key});

  final Future<void> Function(String code) onCodeDetected;

  @override
  State<QrScannerSheet> createState() => _QrScannerSheetState();
}

class _QrScannerSheetState extends State<QrScannerSheet> {
  static const MethodChannel _kioskChannel =
      MethodChannel('registro_asistencia/kiosk');

  late final MobileScannerController _scannerController;
  bool _isStarting = true;

  Future<void> _playScanFeedback() async {
    try {
      final played = await _kioskChannel.invokeMethod<bool>('playScanBeep');
      if (played == true) {
        return;
      }
    } catch (_) {
      // Fall back to framework system sound when native beep is unavailable.
    }

    await SystemSound.play(SystemSoundType.alert);
  }

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      autoStart: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCamera();
    });
  }

  Future<void> _startCamera() async {
    setState(() => _isStarting = true);
    try {
      await _scannerController.start();
    } finally {
      if (mounted) {
        setState(() => _isStarting = false);
      }
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height *
            ScannerConstants.cameraSheetHeightFactor,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              ScannerConstants.scannerSheetTitle,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      MobileScanner(
                        controller: _scannerController,
                        onDetect: (capture) {
                          final code = capture.barcodes.first.rawValue;
                          if (code != null && code.isNotEmpty) {
                            unawaited(_playScanFeedback());
                            widget.onCodeDetected(code);
                          }
                        },
                      ),
                      if (_isStarting)
                        Container(
                          color: Colors.black26,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(ScannerConstants.closeButton),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
