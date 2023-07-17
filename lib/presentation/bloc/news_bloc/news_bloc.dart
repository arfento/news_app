// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news/core/failures.dart';

import 'package:flutter_news/core/news_params.dart';
import 'package:flutter_news/domain/entities/news.dart';
import 'package:flutter_news/domain/usecases/get_news_usecase.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNewsUsecase getNewsUsecase;
  NewsBloc({
    required this.getNewsUsecase,
  }) : super(NewsInitial()) {
    on<GetNewsEvent>(_onGetNewsRequested);
  }

  Future<FutureOr<void>> _onGetNewsRequested(
      GetNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    final result = await getNewsUsecase.execute(parameters: event.parameters);

    emit(result.fold(
      (failure) => NewsError(message: _getErrorMessage(failure)),
      (result) => NewsLoaded(news: result),
    ));
  }

  _getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case CacheFailure:
        return (failure as CacheFailure).message;
      default:
        return 'An unknown error has occured';
    }
  }
}
