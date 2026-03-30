part of 'user_bloc.dart';

enum UserStatus { initial, loading, success, failure, empty }

class UserState extends Equatable {
  final UserStatus status;
  final List<User> allUsers;
  final List<User> filteredUsers;
  final List<User> pagedUsers;
  final String searchQuery;
  final String errorMessage;
  final bool hasReachedMax;

  const UserState({
    this.status = UserStatus.initial,
    this.allUsers = const [],
    this.filteredUsers = const [],
    this.pagedUsers = const [],
    this.searchQuery = '',
    this.errorMessage = '',
    this.hasReachedMax = false,
  });

  UserState copyWith({
    UserStatus? status,
    List<User>? allUsers,
    List<User>? filteredUsers,
    List<User>? pagedUsers,
    String? searchQuery,
    String? errorMessage,
    bool? hasReachedMax,
  }) {
    return UserState(
      status: status ?? this.status,
      allUsers: allUsers ?? this.allUsers,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      pagedUsers: pagedUsers ?? this.pagedUsers,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allUsers,
    filteredUsers,
    pagedUsers,
    searchQuery,
    errorMessage,
    hasReachedMax,
  ];
}
