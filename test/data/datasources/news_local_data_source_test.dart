import 'dart:convert';

import 'package:flutter_news/core/exceptions.dart';
import 'package:flutter_news/data/datasources/news_hive_helper.dart';
import 'package:flutter_news/data/datasources/news_local_data_source.dart';
import 'package:flutter_news/data/models/news_model.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import '../../json_example/fixture_reader.dart';

class MockNewsHiveHelper extends Mock implements NewsHiveHelper {}

void main() {
  late NewsLocalDataSourceImpl localDataSourceImpl;
  late MockNewsHiveHelper hive;

  setUp(() {
    hive = MockNewsHiveHelper();
    localDataSourceImpl = NewsLocalDataSourceImpl(hive: hive);
  });

  final expectedResult = (json.decode(fixture('cached_news.json')) as List)
      .map((e) => NewsModel.fromMap(e))
      .toList();

  group('Get News', () {
    test('Should return a list of news from cache when there is data in cache',
        () async {
      when(() => hive.getNews())
          .thenAnswer((invocation) async => expectedResult);

      final news = await localDataSourceImpl.getNews();

      expect(news, expectedResult);
    });
    test('Should throw a cache exception cache when there is no data in cache',
        () async {
      when(() => hive.getNews()).thenAnswer((invocation) async => List.empty());

      expect(() => localDataSourceImpl.getNews(),
          throwsA(predicate((p0) => p0 is CacheException)));
    });
  });

  group('Save news', () {
    test('Should call Hive to cache data', () async {
      when(() => hive.saveNews(expectedResult))
          .thenAnswer((invocation) => true);

      await localDataSourceImpl.saveNews(expectedResult);

      verify(() => hive.saveNews(expectedResult)).called(1);
      verifyNoMoreInteractions(hive);
    });
  });
}
