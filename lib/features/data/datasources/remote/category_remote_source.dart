import 'dart:convert';

import 'package:family_cash/core/remoute/remoute_request.dart';
import 'package:family_cash/features/data/models/category_model.dart';
import 'package:family_cash/features/data/models/response_model.dart';

abstract class CategoryRemoteSource {
  Future<List<CategoryModel>> getCategoriesFromRemote(String token);
  Future<ResponseModel> setCategoryToRemote(
      String token, CategoryModel category);
  Future<ResponseModel> updateCategoryToRemote(
      String token, CategoryModel category);
  Future<ResponseModel> delCategoryFromRemote(String token, int id);
}

class CategoryRemoteSourceImpl implements CategoryRemoteSource {
  @override
  Future<List<CategoryModel>> getCategoriesFromRemote(String token) async {
    final response =
        await RemoteRequest(token: token).call("category/all", 'GET');
    // Преобразуем JSON-ответ в список объектов FamilyModel
    final List<dynamic> data = json.decode(response.body);
    final categories =
        data.map((json) => CategoryModel.fromJson(json)).toList();
    return categories;
  }

  @override
  Future<ResponseModel> setCategoryToRemote(
      String token, CategoryModel category) async {
    final response = await RemoteRequest(token: token)
        .call("category/create", 'POST', body: category);
    return ResponseModel.fromJson(await json.decode(response.body));
  }

  @override
  Future<ResponseModel> delCategoryFromRemote(String token, int id) async {
    final response =
        await RemoteRequest(token: token).call("category/delete/$id", 'DELETE');
    return ResponseModel.fromJson(await json.decode(response.body));
  }

  @override
  Future<ResponseModel> updateCategoryToRemote(
      String token, CategoryModel category) async {
    final response = await RemoteRequest(token: token)
        .call("category/update", 'POST', body: category);
    return ResponseModel.fromJson(await json.decode(response.body));
  }
}
