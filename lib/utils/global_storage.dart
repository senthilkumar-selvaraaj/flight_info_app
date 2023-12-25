import 'dart:convert';
import 'package:flight_info_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  User? user;

  Global._();

  static final storage = Global._();

  Future load() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    String? userModal = preference.getString('UserModal');
    if (userModal != null) {
      User user = User.fromJson(json.decode(userModal));
      this.user = user;
    }
  }

  bool get hasUserLogined {
    return (user != null);
  }

  String? get accessToken {
    return user?.authToken;
  }

  String? get refreshToken {
    return user?.refreshToken;
  }

  String get name {
    return '${user?.name}';
  }

  String getLightLogo() {
    return user?.logoLight ?? '';
  }

  String getDarkLogo() {
    return user?.logoDark ?? '';
  }

  Future logOut() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.remove('UserModal');
    user = null;
  }

  void saveUser(User userResult) {
    Global.storage.user = userResult;
  }
}
