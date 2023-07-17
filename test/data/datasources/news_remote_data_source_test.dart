import 'dart:io';

import 'package:flutter_news/core/exceptions.dart';
import 'package:flutter_news/core/news_params.dart';
import 'package:flutter_news/data/datasources/news_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../json_example/fixture_reader.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late NewsRemoteDataSourceImpl remoteDataSourceImpl;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    remoteDataSourceImpl = NewsRemoteDataSourceImpl(client: mockClient);
    registerFallbackValue(Uri());
  });

  void setUpMockHttpClient(String fixtureName, int statusCode) {
    when(() => mockClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((invocation) async => http.Response(
              fixture(fixtureName),
              statusCode,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              },
            ));
  }

  final newsParams = NewsParams(country: 'GB', category: 'Sports');

  group('Get News', () {
    test(
        'Should return a list of news models when a status code of 200 is received',
        () async {
      setUpMockHttpClient('news.json', 200);

      final news = await remoteDataSourceImpl.getNews(parameters: newsParams);

      expect(news.length, equals(20));
    });

    test('Should throw an exception when a status code of 400 is received',
        () async {
      setUpMockHttpClient('news.json', 400);

      expect(
          () => remoteDataSourceImpl.getNews(parameters: newsParams),
          throwsA(predicate((error) =>
              error is ServerException && error.message == 'Bad Request')));
    });

    test('Should throw an exception when a status code of 401 is received',
        () async {
      setUpMockHttpClient('news.json', 401);

      expect(
          () => remoteDataSourceImpl.getNews(parameters: newsParams),
          throwsA(predicate((error) =>
              error is ServerException && error.message == 'Unauthorized')));
    });

    test('Should throw an exception when a status code of 500 is received',
        () async {
      setUpMockHttpClient('news.json', 500);

      expect(
          () => remoteDataSourceImpl.getNews(parameters: newsParams),
          throwsA(predicate((error) =>
              error is ServerException &&
              error.message == 'Internal Server Error')));
    });

    test(
        'Should throw an exception of unknown error when a recognised status code is received',
        () async {
      setUpMockHttpClient('news.json', 300);

      expect(
          () => remoteDataSourceImpl.getNews(parameters: newsParams),
          throwsA(predicate((error) =>
              error is ServerException && error.message == 'Unknown Error')));
    });
  });
}
