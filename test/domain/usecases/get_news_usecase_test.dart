import 'package:dartz/dartz.dart';
import 'package:flutter_news/core/failures.dart';
import 'package:flutter_news/core/news_params.dart';
import 'package:flutter_news/domain/entities/news.dart';
import 'package:flutter_news/domain/entities/source.dart';
import 'package:flutter_news/domain/repository/news_repository.dart';
import 'package:flutter_news/domain/usecases/get_news_usecase.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late GetNewsUsecase usecase;
  late MockNewsRepository mockNewsRepository;

  setUp(() => {
        mockNewsRepository = MockNewsRepository(),
        usecase = GetNewsUsecase(repository: mockNewsRepository),
      });

  final news = [
    News(
        author: "author",
        title: "title",
        description: "description",
        urlToImage: "https://img.youtube.com/vi/CA-Xe_M8mpA/maxresdefault.jpg",
        publishedDate: DateTime.now(),
        content: "content",
        source: const Source(name: "name"))
  ];

  final newsParams = NewsParams(country: 'GB', category: 'Sports');

  group('Retrieve news from repository', () {
    test('Should return entity from repository when call is successfull',
        () async {
      when(() => mockNewsRepository.getNews(parameters: newsParams))
          .thenAnswer((invocation) async => Right(news));

      final result = await usecase.execute(parameters: newsParams);

      expect(result, Right(news));
      verify(() => mockNewsRepository.getNews(parameters: newsParams));
      verifyNoMoreInteractions(mockNewsRepository);
    });

    test('Should return failure from repository when call is unsuccessfull',
        () async {
      final errorMessage = ServerFailure(message: "Internal Server Error");
      when(() => mockNewsRepository.getNews(parameters: newsParams))
          .thenAnswer((error) async => Left(errorMessage));

      final result = await usecase.execute(parameters: newsParams);

      expect(result, Left(errorMessage));
      verify(() => mockNewsRepository.getNews(parameters: newsParams));
      verifyNoMoreInteractions(mockNewsRepository);
    });
  });
}
