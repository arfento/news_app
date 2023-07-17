// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'news_bloc.dart';

abstract class NewsState extends Equatable {}

class NewsInitial extends NewsState {
  @override
  List<Object> get props => [];
}

class NewsLoading extends NewsState {
  @override
  List<Object> get props => [];
}

class NewsError extends NewsState {
  final String message;
  NewsError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class NewsLoaded extends NewsState {
  final List<News> news;
  NewsLoaded({
    required this.news,
  });

  @override
  List<Object> get props => [news];
}
