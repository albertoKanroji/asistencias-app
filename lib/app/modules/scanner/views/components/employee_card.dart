import 'package:flutter/material.dart';

import '../../constants/scanner_constants.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    required this.fullName,
    this.imageUrl,
    this.actions,
    super.key,
  });

  final String fullName;
  final String? imageUrl;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
                  ? NetworkImage(imageUrl!)
                  : null,
              child: (imageUrl == null || imageUrl!.isEmpty)
                  ? Text(
                      fullName.isNotEmpty
                          ? fullName.substring(0, 1)
                          : ScannerConstants.unknownInitial,
                    )
                  : null,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    
                    fullName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 10,
                    ),
                  ),
                  if (actions != null) ...[
                    const SizedBox(height: 0),
                    actions!,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
