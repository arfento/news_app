import 'package:flutter_news/data/datasources/news_hive_helper.dart';
import 'package:flutter_news/data/datasources/news_local_data_source.dart';
import 'package:flutter_news/data/datasources/news_remote_data_source.dart';
import 'package:flutter_news/data/repository/news_repository_impl.dart';
import 'package:flutter_news/domain/repository/news_repository.dart';
import 'package:flutter_news/domain/usecases/get_news_usecase.dart';
import 'package:flutter_news/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

init() async {
  //datasource
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(hive: sl()),
  );

  //repositories
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Usecases
  sl.registerLazySingleton(() => GetNewsUsecase(repository: sl()));

  // Presentation

  // BLoC
  sl.registerFactory(() => NewsBloc(getNewsUsecase: sl()));
  //misc
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => NewsHiveHelper());
}
