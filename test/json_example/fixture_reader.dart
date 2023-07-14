import 'dart:convert';
import 'dart:io';

import 'package:flutter_news/data/models/news_model.dart';

String fixture(String name) =>
    File('test/json_example/$name').readAsStringSync();

List<NewsModel> getMockFilms() {
  return (json.decode(fixture('news.json')) as List)
      .map((e) => NewsModel.fromMap(e))
      .toList();
}
