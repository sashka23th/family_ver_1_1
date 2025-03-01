import 'package:equatable/equatable.dart';

class FamilyEntity extends Equatable {
  final int id;
  final String name;

  const FamilyEntity({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
