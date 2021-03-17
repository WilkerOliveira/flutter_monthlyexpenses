import 'package:summarizeddebts/modules/config/repository/api/config_api.dart';
import 'package:summarizeddebts/repositories/base/base_repository.dart';

class ConfigRepository extends BaseRepository {

  Future<void> signOut() {
    return ConfigApi.signOut();
  }

}
