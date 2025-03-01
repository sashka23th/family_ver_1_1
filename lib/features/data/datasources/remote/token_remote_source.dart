import 'dart:convert';

import 'package:family_cash/core/remoute/remoute_request.dart';
import 'package:family_cash/features/data/models/token_model.dart';
import 'package:family_cash/features/domain/entity/login_entity.dart';

abstract class TokenRemoteSource {
  getTokenRemote(LoginEntity login);
}

class TokenRemoteSourceImpl implements TokenRemoteSource {
  @override
  Future<TokenModel> getTokenRemote(LoginEntity login) async {
    final response = await RemoteRequest(
      token: '',
    ).call("token", 'POST', body: login);
    final model = TokenModel.fromJson(json.decode(response.body));
    return model;
  }
}
