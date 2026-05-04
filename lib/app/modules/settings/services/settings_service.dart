import '../constants/settings_constants.dart';

class SettingsService {
  Future<String> getData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return SettingsConstants.availableMessage;
  }
}
