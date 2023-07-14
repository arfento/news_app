// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter_news/core/constants.dart';
import 'package:flutter_news/core/exceptions.dart';
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
  Future<List<NewsModel>> getNews({required NewsParams parameters}) async {
    try {
      final response = await client.get(
        Uri.parse(
            "$baseUrl/top-headlines?country=${parameters.country}&category=${parameters.category}&apiKey=${Constants.apiKey}"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        },
      );
      switch (response.statusCode) {
        case 200:
          final results = (json.decode(response.body)['articles']);
          final news =
              (results as List).map((e) => NewsModel.fromMap(e)).toList();
          return news;
        case 400:
          throw const ServerException(message: 'Bad Request');
        case 401:
          throw const ServerException(message: 'Unauthorized');
        case 500:
          throw const ServerException(message: 'Internal Server Error');
        default:
          throw const ServerException(message: 'Unknown Error');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw e.toString();
    }
  }
}
