import '../constants/contractors_constants.dart';

class ContractorsService {
  Future<String> getData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ContractorsConstants.loadedMessage;
  }
}
