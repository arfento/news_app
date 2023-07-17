import 'package:dartz/dartz.dart';
import 'package:flutter_news/core/failures.dart';
import 'package:flutter_news/core/news_params.dart';
import 'package:flutter_news/domain/entities/news.dart';
import 'package:flutter_news/domain/repository/news_repository.dart';

class GetNewsUsecase {
  final NewsRepository repository;

  GetNewsUsecase({required this.repository});

  Future<Either<Failure, List<News>>> execute(
      {required NewsParams parameters}) async {
    return repository.getNews(parameters: parameters);
  }
}
