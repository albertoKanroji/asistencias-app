import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/contractors_controller.dart';

class ContractorsView extends GetView<ContractorsController> {
  const ContractorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(
        () => Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(controller.message.value),
          ),
        ),
      ),
    );
  }
}
