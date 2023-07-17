import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_news/core/failures.dart';
import 'package:flutter_news/core/news_params.dart';
import 'package:flutter_news/domain/entities/news.dart';
import 'package:flutter_news/domain/entities/source.dart';
import 'package:flutter_news/domain/usecases/get_news_usecase.dart';
import 'package:flutter_news/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockGetNews extends Mock implements GetNewsUsecase {}

void main() {
  late MockGetNews mockGetNewsUsecase;
  late NewsBloc newsBloc;

  final List<News> news = [
    News(
        author: 'author',
        title: 'title',
        description: 'description',
        urlToImage: 'urlToImage',
        publishedDate: DateTime.now(),
        content: 'content',
        source: const Source(name: 'name')),
    News(
        author: 'author 2',
        title: 'title 2',
        description: 'description 2',
        urlToImage: 'urlToImage 2',
        publishedDate: DateTime.now(),
        content: 'content 2',
        source: const Source(name: 'name 2'))
  ];

  final newsParams = NewsParams(country: 'GB', category: 'Sports');

  setUp(() {
    mockGetNewsUsecase = MockGetNews();
    newsBloc = NewsBloc(getNewsUsecase: mockGetNewsUsecase);
  });

  group('Get news usecase', () {
    test('Initial bloc state should be NewsInitial', () {
      expect(newsBloc.state, equals(NewsInitial()));
    });

    test('Bloc calls getnews usecase', () async {
      when(() => mockGetNewsUsecase.execute(parameters: newsParams))
          .thenAnswer((invocation) async => Right(news));

      newsBloc.add(GetNewsEvent(parameters: newsParams));

      await untilCalled(
          () => mockGetNewsUsecase.execute(parameters: newsParams));
      verify(
        () => mockGetNewsUsecase.execute(parameters: newsParams),
      );
    });

    blocTest<NewsBloc, NewsState>(
      'Should emit correct order or states when GetNews is called with success.',
      build: () {
        when(() => mockGetNewsUsecase.execute(parameters: newsParams))
            .thenAnswer((invocation) async => Right(news));
        return newsBloc;
      },
      act: (bloc) => newsBloc.add(GetNewsEvent(parameters: newsParams)),
      expect: () => [NewsLoading(), NewsLoaded(news: news)],
    );
    blocTest<NewsBloc, NewsState>(
      'Should emit correct order or states when GetNews is called with error.',
      build: () {
        when(() => mockGetNewsUsecase.execute(parameters: newsParams))
            .thenAnswer(
                (invocation) async => Left(ServerFailure(message: 'Error')));
        return newsBloc;
      },
      act: (bloc) => newsBloc.add(GetNewsEvent(parameters: newsParams)),
      expect: () => [NewsLoading(), NewsError(message: "Error")],
    );
  });
}
