import 'package:get/get.dart';

import '../services/contractors_service.dart';

class ContractorsController extends GetxController {
  ContractorsController(this._service);

  final ContractorsService _service;
  final message = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    message.value = await _service.getData();
  }
}
