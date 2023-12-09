
import 'package:flight_info_app/models/user_model.dart';
import 'package:flight_info_app/services/api_service.dart';
import 'package:flight_info_app/utils/global_storage.dart';

class AuthRepositary {
  Future<void> login(Map<String, String> body) async {
    try {
      final response = await HttpClient(
          request: HttpRequest.login,
          body: body).send();
      try {
        Global.storage.saveUser(User.fromJson(response));
      } catch (e) {
        throw BadRequestException('Data Exception');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout(Map<String, dynamic> body) async {
    try {
      await HttpClient(request: HttpRequest.logout, body: body).send();
    } catch (e) {
      rethrow;
    }
  }
}
