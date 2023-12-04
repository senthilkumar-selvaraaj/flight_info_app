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
    print("serModel ==> $userModal");
    if (userModal != null) {
      print(userModal);
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

  String get name {
    return '${user?.name}';
  }


  Future logOut() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.remove('UserModal');
    user = null;
  }

  Future<void> saveUser(User userResult) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    Global.storage.user = userResult;
    await preference.setString('UserModal', json.encode(userResult.toJson()));
  }
}
