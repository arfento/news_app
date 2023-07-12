// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:http/http.dart' as http;

import 'package:flutter_news/core/news_params.dart';
import 'package:flutter_news/data/models/news_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsModel>> getNews({required NewsParams parameters});
}

class NewsRemoteDataSourceImpl extends NewsRemoteDataSource {
  final http.Client client;
  final baseUrl = "https://newsapi.org/v2";

  NewsRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<List<NewsModel>> getNews({required NewsParams parameters}) {}
}
