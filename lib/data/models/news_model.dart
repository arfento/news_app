// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_news/domain/entities/news.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:flutter_news/data/models/source_model.dart';

part 'news_model.g.dart';

@HiveType(typeId: 0)
class NewsModel extends Equatable {
  @HiveField(0)
  final SourceModel source;
  @HiveField(1)
  final String? author;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final String? urlToImage;
  @HiveField(5)
  final String publishedDate;
  @HiveField(6)
  final String? content;
  const NewsModel({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.publishedDate,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'source': source.toMap(),
      'author': author,
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'publishedDate': publishedDate,
      'content': content,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      source: SourceModel.fromMap(map['source'] as Map<String, dynamic>),
      author: map['author'] != null ? map['author'] as String : null,
      title: map['title'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      urlToImage:
          map['urlToImage'] != null ? map['urlToImage'] as String : null,
      publishedDate: map['publishedDate'] as String,
      content: map['content'] != null ? map['content'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsModel.fromJson(String source) =>
      NewsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props {
    return [
      source,
      author!,
      title,
      description!,
      urlToImage!,
      publishedDate,
      content!,
    ];
  }

  @override
  bool get stringify => true;
}

extension NewsModelExtension on NewsModel {
  News get toNews => News(
      author: author,
      title: title,
      description: description,
      urlToImage: urlToImage,
      publishedDate: publishedDate,
      content: content,
      source: source.toSource);
}
