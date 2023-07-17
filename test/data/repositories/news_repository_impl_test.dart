import 'dart:convert';

import 'package:flutter_news/core/exceptions.dart';
import 'package:flutter_news/core/failures.dart';
import 'package:flutter_news/core/news_params.dart';
import 'package:flutter_news/data/datasources/news_local_data_source.dart';
import 'package:flutter_news/data/datasources/news_remote_data_source.dart';
import 'package:flutter_news/data/models/news_model.dart';
import 'package:flutter_news/data/repository/news_repository_impl.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import '../../json_example/fixture_reader.dart';

class MockNewsRemoteDataSource extends Mock implements NewsRemoteDataSource {}

class MockNewsLocalDataSource extends Mock implements NewsLocalDataSource {}

void main() {
  late NewsRepositoryImpl repositoryImpl;
  late MockNewsRemoteDataSource mockNewsRemoteDataSource;
  late MockNewsLocalDataSource mockNewsLocalDataSource;

  setUp(
    () => {
      mockNewsLocalDataSource = MockNewsLocalDataSource(),
      mockNewsRemoteDataSource = MockNewsRemoteDataSource(),
      repositoryImpl = NewsRepositoryImpl(
        remoteDataSource: mockNewsRemoteDataSource,
        localDataSource: mockNewsLocalDataSource,
      )
    },
  );

  final cachedNewsModel = (json.decode(fixture('cached_news.json')) as List)
      .map((e) => NewsModel.fromMap(e))
      .toList();
  final newsModel = (json.decode(fixture('news.json'))['articles'] as List)
      .map((e) => NewsModel.fromMap(e))
      .toList();
  final newsEntityFromRemote = newsModel.map((e) => e.toNews).toList();
  final newsEntityFromLocal = cachedNewsModel.map((e) => e.toNews).toList();

  final newsParams = NewsParams(country: 'GB', category: 'sports');

  group('Get News', () {
    test(
        'Should return remote data when call to remote data source is successful',
        () async {
      when(
        () => mockNewsRemoteDataSource.getNews(parameters: newsParams),
      ).thenAnswer((invocation) async => newsModel);

      final result = await repositoryImpl.getNews(parameters: newsParams);
      final resultFolded = result.fold(
          (failure) => ServerFailure(message: failure.toString()),
          (result) => result);

      verify(() => mockNewsRemoteDataSource.getNews(parameters: newsParams));
      expect(result.isRight(), true);
      expect(resultFolded, newsEntityFromRemote);
      expect(resultFolded, equals(newsEntityFromRemote));
    });
  });

  test('News are saved to cache when retrieved from remote data source',
      () async {
    when(() => mockNewsRemoteDataSource.getNews(parameters: newsParams))
        .thenAnswer((invocation) async => newsModel);
    // Act
    await repositoryImpl.getNews(parameters: newsParams);
    // Assert
    verify(() => mockNewsRemoteDataSource.getNews(parameters: newsParams));
    verify(() => mockNewsLocalDataSource.saveNews(newsModel));
  });
  test(
      'Should return failure when call to remote data source and local data source is fail',
      () async {
    when(() => mockNewsRemoteDataSource.getNews(parameters: newsParams))
        .thenThrow(const ServerException(message: 'Error'));

    when(() => mockNewsLocalDataSource.getNews()).thenThrow(CacheException());

    final result = await repositoryImpl.getNews(parameters: newsParams);
    final resultFolded =
        result.fold((l) => ServerFailure(message: l.toString()), (r) => r);

    verify(
      () => mockNewsRemoteDataSource.getNews(parameters: newsParams),
    );
    verify(
      () => mockNewsLocalDataSource.getNews(),
    );
    expect(result.isLeft(), true);
    expect(resultFolded, ServerFailure(message: 'Error'));
  });

  test('News are retrieved from cache when call to remote data source fails',
      () async {
    when(() => mockNewsRemoteDataSource.getNews(parameters: newsParams))
        .thenThrow(const ServerException(message: 'Error'));

    when(() => mockNewsLocalDataSource.getNews())
        .thenAnswer((invocation) async => cachedNewsModel);

    final result = await repositoryImpl.getNews(parameters: newsParams);
    final resultFolded =
        result.fold((l) => ServerFailure(message: l.toString()), (r) => r);
    verify(() => mockNewsRemoteDataSource.getNews(parameters: newsParams));
    verify(() => mockNewsLocalDataSource.getNews());
    expect(result.isRight(), true);
    expect(resultFolded, newsEntityFromLocal);
    expect(resultFolded, equals(newsEntityFromLocal));
  });
}
