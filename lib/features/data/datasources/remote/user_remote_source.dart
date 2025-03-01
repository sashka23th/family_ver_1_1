import 'dart:convert';
import 'package:family_cash/core/remoute/remoute_request.dart';
import 'package:family_cash/features/data/models/login_model.dart';
import 'package:family_cash/features/data/models/token_model.dart';
import 'package:family_cash/features/data/models/user_model.dart';

abstract class UserRemoteSource {
  //addRegisrationUser(LoginEntity user);
  Future<UserModel> getUserRemote(String token);
  Future<UserModel> addUserRemote(LoginModel login);
  Future<TokenModel> forgotPassword();
}

class UserRemoteSourceImp implements UserRemoteSource {
  @override
  Future<UserModel> getUserRemote(String token) async {
    final response = await RemoteRequest(token: token).call("user", 'GET');
    final model = UserModel.fromJson(json.decode(response.body));
    return model;
  }

  @override
  Future<TokenModel> forgotPassword() async {
    final response = await RemoteRequest(token: '').call("forgot", 'POST');
    final model = TokenModel.fromJson(json.decode(response.body));
    return model;
  }

  @override
  Future<UserModel> addUserRemote(LoginModel login) async {
    final response =
        await RemoteRequest(token: '').call("register", 'POST', body: login);
    final model = UserModel.fromJson(json.decode(response.body));
    return model;
  }

  // @override
  // Future<UserModel> addRegisrationUser(LoginEntity login) async {
  //   final response =
  //       await RemoteRequest(token: '').call('register', 'POST', body: login);
  //   return json.decode(response.body);
  // }
}
