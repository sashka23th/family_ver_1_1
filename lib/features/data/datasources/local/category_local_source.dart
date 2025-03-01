import 'dart:convert';

import 'package:family_cash/features/data/models/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const key = 'CATEGORY_SHARED';

abstract class CategoryLocalSource {
  Future<List<CategoryModel>> getCategories();
  Future<void> setCatigoriesList(List<CategoryModel> categories);
}

class CategoryLocalSourceImpl implements CategoryLocalSource {
  final SharedPreferences sharedPreferences;

  CategoryLocalSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final List<String>? categorioes = sharedPreferences.getStringList(key);
    if (categorioes != null && categorioes.isNotEmpty) {
      return categorioes
          .map((category) => CategoryModel.fromJson(jsonDecode(category)))
          .toList();
    }
    return [];
  }

  @override
  Future<void> setCatigoriesList(List<CategoryModel> categories) async {
    final List<String> list =
        categories.map((category) => jsonEncode(category.toJson())).toList();
    await sharedPreferences.setStringList(key, list);
  }
}
