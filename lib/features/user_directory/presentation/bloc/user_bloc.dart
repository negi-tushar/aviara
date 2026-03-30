import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/error/failures.dart';

part 'user_event.dart';
part 'user_state.dart';

const int pageSize = 4;

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase getUsersUseCase;

  UserBloc({required this.getUsersUseCase}) : super(const UserState()) {
    on<FetchUsersEvent>(_onFetchUsers);
    on<SearchUsersEvent>(_onSearchUsers);
    on<LoadMoreUsersEvent>(_onLoadMoreUsers);
  }

  Future<void> _onFetchUsers(
    FetchUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.loading));
    
    try {
      final users = await getUsersUseCase(NoParams());
      
      if (users.isEmpty) {
        emit(state.copyWith(status: UserStatus.empty));
      } else {
        // Initial load
        final paged = users.take(pageSize).toList();
        emit(
          state.copyWith(
            status: UserStatus.success,
            allUsers: users,
            filteredUsers: users,
            pagedUsers: paged,
            hasReachedMax: paged.length >= users.length,
          ),
        );
      }
    } catch (error) {
      String message = 'An unexpected error occurred';
      if (error is Failure) {
        message = error.message;
      }
      
      emit(
        state.copyWith(
          status: UserStatus.failure,
          errorMessage: message,
        ),
      );
    }
  }

  void _onSearchUsers(SearchUsersEvent event, Emitter<UserState> emit) {
    final query = event.query.toLowerCase();

    final filtered = state.allUsers.where((user) {
      return user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query);
    }).toList();

    if (filtered.isEmpty) {
      emit(
        state.copyWith(
          status: UserStatus.empty,
          searchQuery: event.query,
          filteredUsers: [],
          pagedUsers: [],
          hasReachedMax: true,
        ),
      );
    } else {
      final paged = filtered.take(pageSize).toList();
      emit(
        state.copyWith(
          status: UserStatus.success,
          searchQuery: event.query,
          filteredUsers: filtered,
          pagedUsers: paged,
          hasReachedMax: paged.length >= filtered.length,
        ),
      );
    }
  }

  void _onLoadMoreUsers(LoadMoreUsersEvent event, Emitter<UserState> emit) {
    if (state.hasReachedMax) return;

    final currentLength = state.pagedUsers.length;
    final nextBatch = state.filteredUsers
        .skip(currentLength)
        .take(pageSize)
        .toList();

    if (nextBatch.isEmpty) {
      emit(state.copyWith(hasReachedMax: true));
    } else {
      emit(
        state.copyWith(
          pagedUsers: List.of(state.pagedUsers)..addAll(nextBatch),
          hasReachedMax:
              (currentLength + nextBatch.length) >= state.filteredUsers.length,
        ),
      );
    }
  }
}
