import 'package:flutter/material.dart';

import '../../constants/scanner_constants.dart';

class ScannerStatusCard extends StatelessWidget {
  const ScannerStatusCard({
    required this.message,
    required this.lastCode,
    required this.isLoading,
    super.key,
  });

  final String message;
  final String lastCode;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 8),
            Text(
              '${ScannerConstants.lastQrPrefix} '
              '${lastCode.isEmpty ? ScannerConstants.noQrValue : lastCode}',
            ),
            if (isLoading) ...[
              const SizedBox(height: 10),
              const LinearProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}
