import 'dart:convert';

import 'package:family_cash/features/data/models/family_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const key = 'FAMILY_SHARED';
const keyDefault = 'FAMILY_SHARED_DEFAULT';

abstract class FamilyLocalSource {
  Future<List<FamilyModel>> getFamiliesFromCache();
  Future<FamilyModel> getFamilyDefault();
  Future<void> setFamiliesToCache(List<FamilyModel> families);
  Future<String> setFamilyDefault(int id);
  Future<void> removeFamiliesFromCache();

  //Future<void> delFamilyFromCache(int id);
}

class FamilyLocalSourceImpl implements FamilyLocalSource {
  final SharedPreferences sharedPreferences;

  FamilyLocalSourceImpl({required this.sharedPreferences});

  @override
  Future<List<FamilyModel>> getFamiliesFromCache() async {
    List<String>? familiesJsonList = sharedPreferences.getStringList(key);

    if (familiesJsonList != null && familiesJsonList.isNotEmpty) {
      // Конвертируем каждую строку JSON обратно в объект CategoryModel
      return familiesJsonList
          .map((familyJson) => FamilyModel.fromJson(jsonDecode(familyJson)))
          .toList();
    }
    return [];
  }

  @override
  Future<void> setFamiliesToCache(List<FamilyModel> families) async {
    List<String> familiesJsonList =
        families.map((category) => jsonEncode(category.toJson())).toList();
    await sharedPreferences.setStringList(key, familiesJsonList);
  }

  @override
  Future<String> setFamilyDefault(int id) async {
    final families = await getFamiliesFromCache();
    String message = '';
    final family = families.firstWhere(
      (family) => family.id == id,
      orElse: () => const FamilyModel(id: -1, name: ""),
    );
    if (family.id > 0) {
      sharedPreferences.setInt(keyDefault, family.id);
      message = "Family default updated";
    } else {
      message = "No family to update";
    }
    return message;
  }

  @override
  Future<FamilyModel> getFamilyDefault() async {
    final listFamilies = await getFamiliesFromCache();
    if (listFamilies.isEmpty) return const FamilyModel(id: -1, name: "");

    // Check if the key exists and holds an int, if not, reset it
    // if (sharedPreferences.containsKey(key) &&
    //     sharedPreferences.get(key) is! int) {
    //   await sharedPreferences.remove(key); // Remove incorrect data
    // }

    int defaultId = sharedPreferences.getInt(keyDefault) ?? -1;
    if (defaultId > 0) {
      return listFamilies.firstWhere((family) => (family.id == defaultId));
    } else {
      await setFamilyDefault(listFamilies.first.id);
      return Future.value(listFamilies.first);
    }
  }

  @override
  Future<void> removeFamiliesFromCache() async {
    await sharedPreferences.remove(key);
  }

  // @override
  // Future<void> delFamilyFromCache(int id) async {
  //   List<FamilyModel> families = await getFamiliesFromCache();

  //   // Фильтруем список, исключая категорию с переданным ID
  //   families = families.where((family) => family.id != id).toList();

  //   // Сохраняем обновленный список
  //   await setFamiliesToCache(families);
  // }
}
