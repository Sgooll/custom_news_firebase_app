part of 'news_cubit.dart';

@immutable
abstract class NewsState {} // abstract states class

class NewsInitial extends NewsState {}

class NewsLoadedState extends NewsState {
  final List<News> newsList;
  final String selectedValue;

  NewsLoadedState(this.newsList, this.selectedValue);
}

class NewsErrorState extends NewsState {
  final String errorMessage;

  NewsErrorState(this.errorMessage);
}