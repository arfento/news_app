import 'package:dartz/dartz.dart';
import 'package:flutter_news/core/failures.dart';
import 'package:flutter_news/core/news_params.dart';
import 'package:flutter_news/domain/entities/news.dart';
import 'package:flutter_news/domain/repository/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  @override
  Future<Either<Failure, List<News>>> getNews(
      {required NewsParams parameters}) {
    // TODO: implement getNews
    throw UnimplementedError();
  }
}
