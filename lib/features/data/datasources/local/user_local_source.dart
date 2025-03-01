import 'dart:convert';
import 'package:family_cash/features/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const key = 'USER_SHARED';

abstract class UserLocalSource {
  Future<UserModel> getUserFromCache();
  Future<void> setUserToCache(UserModel user);
}

class UserLocalSourceImpl implements UserLocalSource {
  final SharedPreferences sharedPreferences;

  UserLocalSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel> getUserFromCache() async {
    final String? user = sharedPreferences.getString(key);
    if (user != null) {
      return UserModel.fromJson(jsonDecode(user));
    }
    return UserModel(
        registrationDate: DateTime.now(), id: -1, name: "", email: "");
  }

  @override
  Future<void> setUserToCache(UserModel user) async {
    final String jsonUser = json.encode(user.toJson());
    await Future.value(sharedPreferences.setString(key, jsonUser));
  }
}
