import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/startup_constants.dart';
import '../../../core/services/auth_service.dart';
import '../controllers/startup_controller.dart';

class StartupView extends StatelessWidget {
  const StartupView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<StartupController>(StartupController(Get.find<AuthService>()));

    return Scaffold(
      body: Center(
        child: Semantics(
          label: StartupConstants.loaderSemanticsLabel,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
