import 'package:flutter/material.dart';

import '../../constants/scanner_constants.dart';

class ExitReasonSheet extends StatefulWidget {
  const ExitReasonSheet({super.key});

  @override
  State<ExitReasonSheet> createState() => _ExitReasonSheetState();
}

class _ExitReasonSheetState extends State<ExitReasonSheet> {
  late final TextEditingController _textController;
  String? _selectedReason;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedReason == null || _selectedReason!.isEmpty) {
      setState(() => _validationError = ScannerConstants.exitReasonChooseOption);
      return;
    }

    final isOther = _selectedReason == ScannerConstants.exitReasonOtherOption;
    final notes = isOther ? _textController.text.trim() : _selectedReason!;
    if (notes.isEmpty) {
      setState(() => _validationError = ScannerConstants.requiredExitReason);
      return;
    }

    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(notes);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                ScannerConstants.exitReasonTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedReason,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: ScannerConstants.exitReasonSelectLabel,
                ),
                items: ScannerConstants.exitReasonOptions
                    .map(
                      (reason) => DropdownMenuItem<String>(
                        value: reason,
                        child: Text(reason),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedReason = value;
                    _validationError = null;
                    if (_selectedReason != ScannerConstants.exitReasonOtherOption) {
                      _textController.clear();
                    }
                  });
                },
              ),
              if (_selectedReason == ScannerConstants.exitReasonOtherOption) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _textController,
                  maxLines: 4,
                  minLines: 3,
                  onChanged: (_) {
                    if (_validationError != null) {
                      setState(() => _validationError = null);
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: ScannerConstants.exitReasonHint,
                  ),
                ),
              ],
              if (_validationError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _validationError!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _submit,
                child: const Text(ScannerConstants.confirmButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
