import 'dart:convert';

import 'package:family_cash/core/remoute/remoute_request.dart';
import 'package:family_cash/features/data/models/family_model.dart';
import 'package:family_cash/features/data/models/response_model.dart';
import 'package:family_cash/features/domain/entity/family_entity.dart';

abstract class FamailyRemoteSource {
  Future<List<FamilyModel>> getFamiliesFromRemote(String token);
  Future<ResponseModel> setFamilyToRemoute(String token, FamilyEntity family);
  Future<ResponseModel> updateFamilyInRemoute(
      String token, FamilyEntity family);
  Future<ResponseModel> deleteFamilyInRemoute(String token, int id);

  //Future<FamilyModel> deleteFamilyRemote(int id, String token);
}

class FamilyRemoteSourceImpl implements FamailyRemoteSource {
  @override
  Future<List<FamilyModel>> getFamiliesFromRemote(String token) async {
    final response =
        await RemoteRequest(token: token).call("family/all", 'GET');
    // Преобразуем JSON-ответ в список объектов FamilyModel
    final List<dynamic> data = json.decode(response.body);
    final families = data.map((json) => FamilyModel.fromJson(json)).toList();
    return families;
  }

  @override
  Future<ResponseModel> setFamilyToRemoute(
      String token, FamilyEntity family) async {
    final response = await RemoteRequest(token: token)
        .call("family/create", 'POST', body: family);
    return ResponseModel.fromJson(json.decode(response.body));
  }

  @override
  Future<ResponseModel> updateFamilyInRemoute(
      String token, FamilyEntity family) async {
    final response = await RemoteRequest(token: token)
        .call("family/update", 'POST', body: family);
    return ResponseModel.fromJson(json.decode(response.body));
  }

  @override
  Future<ResponseModel> deleteFamilyInRemoute(String token, int id) async {
    final response =
        await RemoteRequest(token: token).call("family/delete/$id", 'DELETE');
    final responseModel = ResponseModel.fromJson(json.decode(response.body));
    return responseModel;
  }
}
