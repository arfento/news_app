import 'package:flutter_news/data/datasources/news_local_data_source.dart';
import 'package:flutter_news/data/models/news_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NewsHiveHelper implements NewsLocalDataSource {
  @override
  Future<List<NewsModel>> getNews() async {
    final box = await Hive.openBox<NewsModel>('news');
    final news = box.values.toList().cast<NewsModel>();
    return news;
  }

  @override
  saveNews(List<NewsModel> newsModels) async {
    final box = await Hive.openBox<NewsModel>('news');
    box.clear();
    for (var news in newsModels) {
      box.add(news);
    }
  }
}
