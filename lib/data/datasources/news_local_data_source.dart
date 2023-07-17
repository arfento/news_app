// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_news/core/exceptions.dart';
import 'package:flutter_news/data/datasources/news_hive_helper.dart';
import 'package:flutter_news/data/models/news_model.dart';

abstract class NewsLocalDataSource {
  Future<List<NewsModel>> getNews();
  saveNews(List<NewsModel> newsModels);
}

class NewsLocalDataSourceImpl extends NewsLocalDataSource {
  final NewsHiveHelper hive;

  NewsLocalDataSourceImpl({required this.hive});

  @override
  Future<List<NewsModel>> getNews() async {
    final news = await hive.getNews();
    if (news.isNotEmpty) {
      return news;
    } else {
      throw CacheException();
    }
  }

  @override
  saveNews(List<NewsModel> newsModels) {
    return hive.saveNews(newsModels);
  }
}
