part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUsersEvent extends UserEvent {}

class SearchUsersEvent extends UserEvent {
  final String query;
  const SearchUsersEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadMoreUsersEvent extends UserEvent {}
