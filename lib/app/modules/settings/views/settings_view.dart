import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/settings_constants.dart';
import '../../../shared/widgets/app_primary_button.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: (controller.photo != null && controller.photo!.isNotEmpty)
                        ? NetworkImage(controller.photo!)
                        : null,
                    child: (controller.photo == null || controller.photo!.isEmpty)
                        ? Text(controller.fullName.substring(0, 1).toUpperCase())
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    controller.fullName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text('${SettingsConstants.usernameLabel}: ${controller.username}'),
                  Text('${SettingsConstants.emailLabel}: ${controller.email}'),
                  Text('${SettingsConstants.areaLabel}: ${controller.area}'),
                  Text('${SettingsConstants.positionLabel}: ${controller.position}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(controller.message.value),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    SettingsConstants.kioskSectionTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<bool>(
                    future: controller.isKioskFullyPermitted(),
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return const SizedBox.shrink();
                      }

                      return Text(
                        SettingsConstants.kioskNotPermittedMessage,
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => AppPrimaryButton(
                      label: SettingsConstants.kioskExitButton,
                      isLoading: controller.isUnlockingKiosk.value,
                      onPressed: () => _askExitPin(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppPrimaryButton(
            label: SettingsConstants.logoutButton,
            onPressed: () => controller.logout(),
          ),
        ],
      ),
    );
  }

  Future<void> _askExitPin(BuildContext context) async {
    final pinController = TextEditingController();

    final pin = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(SettingsConstants.kioskPinTitle),
        content: TextField(
          controller: pinController,
          keyboardType: TextInputType.number,
          obscureText: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: SettingsConstants.kioskPinHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(pinController.text),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    pinController.dispose();

    if (pin == null || pin.trim().isEmpty) {
      return;
    }

    await controller.unlockKioskWithPin(pin);
  }
}
