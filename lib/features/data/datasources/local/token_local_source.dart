import 'package:shared_preferences/shared_preferences.dart';

const key = 'TOKEN_SHARED';

abstract class TokenLocalSource {
  Future<String> getTokenFromCache();
  Future<void> setTokenToCache(String token);
  Future<void> delTokenFromCache();
}

class TokenLocalSourceImpl implements TokenLocalSource {
  final SharedPreferences sharedPreferences;

  TokenLocalSourceImpl({required this.sharedPreferences});

  // Obtain shared preferences.

  @override
  Future<String> getTokenFromCache() async {
    return Future.value(sharedPreferences.getString(key) ?? "");
  }

  @override
  Future<void> setTokenToCache(String token) async {
    Future.value(sharedPreferences.setString(key, token));
  }

  @override
  Future<void> delTokenFromCache() async {
    Future.value(sharedPreferences.remove(key));
  }
}
