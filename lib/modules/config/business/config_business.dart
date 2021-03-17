import 'package:summarizeddebts/modules/config/repository/config_repository.dart';

class ConfigBusiness {
  final ConfigRepository _configRepository;

  ConfigBusiness(this._configRepository);

  Future<void> signOut() {
    return this._configRepository.signOut();
  }
}
