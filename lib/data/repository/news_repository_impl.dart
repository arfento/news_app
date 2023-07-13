// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:flutter_news/core/exceptions.dart';

import 'package:flutter_news/core/failures.dart';
import 'package:flutter_news/core/news_params.dart';
import 'package:flutter_news/data/datasources/news_local_data_source.dart';
import 'package:flutter_news/data/datasources/news_remote_data_source.dart';
import 'package:flutter_news/data/models/news_model.dart';
import 'package:flutter_news/domain/entities/news.dart';
import 'package:flutter_news/domain/repository/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  @override
  Future<Either<Failure, List<News>>> getNews(
      {required NewsParams parameters}) async {
    try {
      final newsModels = await remoteDataSource.getNews(parameters: parameters);
      await localDataSource.saveNews(newsModels);
      final news = newsModels.map((e) => e.toNews).toList();
      return Right(news);
    } on ServerException catch (error) {
      try {
        final newsModels = await localDataSource.getNews();
        final news = newsModels.map((e) => e.toNews).toList();
        return Right(news);
      } on CacheException {
        return Left(ServerFailure(message: error.toString()));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
