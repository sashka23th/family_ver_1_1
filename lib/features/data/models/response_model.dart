// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:family_cash/features/data/models/family_model.dart';

class ResponseModel {
  bool success;
  final String? message;
  final FamilyModel? family;

  ResponseModel({this.success = false, this.message = '', this.family});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
        success: json.containsKey('success') ? json['success'] : true,
        message: json.containsKey('message') ? json['message'] : "No message",
        family: json.containsKey('family')
            ? FamilyModel.fromJson(json['family'])
            : null);
  }
}
