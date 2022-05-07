part of 'user_cubit.dart';

@immutable
abstract class UserState {} // abstract states class

class UserInitial extends UserState {}

class UserLoadedState extends UserState {
  final List<News> favouriteNewsList;

  UserLoadedState(this.favouriteNewsList);
}

class UserErrorState extends UserState {
  final String errorMessage;

  UserErrorState(this.errorMessage);
}