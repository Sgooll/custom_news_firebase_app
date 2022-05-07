part of 'single_news_cubit.dart';

@immutable
abstract class SingleNewsState {} // abstract states class

class SingleNewsInitial extends SingleNewsState {}

class SingleNewsLoadedState extends SingleNewsState {
  final News news;

  SingleNewsLoadedState(this.news);
}

class SingleNewsErrorState extends SingleNewsState {
  final String errorMessage;

  SingleNewsErrorState(this.errorMessage);
}