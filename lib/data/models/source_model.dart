// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter_news/domain/entities/source.dart';
part 'source_model.g.dart';

@HiveType(typeId: 1)
class SourceModel extends Equatable {
  @HiveField(0)
  final String? name;

  const SourceModel({
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }

  factory SourceModel.fromMap(Map<String, dynamic> map) {
    return SourceModel(
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SourceModel.fromJson(String source) =>
      SourceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props => [name!];

  @override
  bool get stringify => true;
}

extension SourceModelExtension on SourceModel {
  Source get toSource => Source(name: name);
}
