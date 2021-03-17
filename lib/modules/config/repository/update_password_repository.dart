import 'package:summarizeddebts/modules/config/repository/api/update_password_api.dart';
import 'package:summarizeddebts/modules/config/repository/api/update_password_request.dart';
import 'package:summarizeddebts/repositories/base/base_repository.dart';

class UpdatePasswordRepository extends BaseRepository {
  final UpdatePasswordApi _api;

  UpdatePasswordRepository(this._api);

  Future<void> updatePassword(UpdatePasswordRequest request) async {
    await super.checkInternetConnection();

    return await this._api.updatePassword(request);
  }
}
