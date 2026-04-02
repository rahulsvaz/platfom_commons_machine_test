import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:platfom_commons_machine_test/core/error/failures.dart';
import 'package:platfom_commons_machine_test/features/users/domain/entity/user.dart';
import 'package:platfom_commons_machine_test/features/users/domain/usecases/use_cases.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersPage _getUsersPage;
  final GetCreatedUsers _getCreatedUsers;
  final CreateUserUseCase _createUser;
  final SyncPendingUsers _syncPendingUsers;

  UserBloc({
    required GetUsersPage getUsersPage,
    required GetCreatedUsers getCreatedUsers,
    required CreateUserUseCase createUser,
    required SyncPendingUsers syncPendingUsers,
  }) : _getUsersPage = getUsersPage,
       _getCreatedUsers = getCreatedUsers,
       _createUser = createUser,
       _syncPendingUsers = syncPendingUsers,
       super(const UserState()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<LoadMoreUsersEvent>(_onLoadMoreUsers);
    on<AddUserEvent>(_onAddUser);
    on<SyncUsersEvent>(_onSyncUsers);
  }

  Future<void> _onLoadUsers(
    LoadUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.loading, clearError: true));

    final localResult = await _getCreatedUsers();
    final pageResult = await _getUsersPage(page: 1);

    final localUsers = localResult.fold((_) => <User>[], (users) => users);

    pageResult.fold(
      (failure) => emit(
        state.copyWith(
          status: UserStatus.error,
          createdUsers: localUsers,
          users: localUsers,
          errorMessage: failure.message,
          currentPage: 1,
          hasMore: false,
        ),
      ),
      (page) => emit(
        state.copyWith(
          status: UserStatus.success,
          createdUsers: localUsers,
          remoteUsers: page.users,
          users: [...localUsers, ...page.users],
          currentPage: page.currentPage,
          hasMore: page.hasMore,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onLoadMoreUsers(
    LoadMoreUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, clearError: true));
    final nextPage = state.currentPage + 1;
    final result = await _getUsersPage(page: nextPage);

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingMore: false, errorMessage: failure.message),
      ),
      (page) {
        final updatedRemoteUsers = [...state.remoteUsers, ...page.users];
        emit(
          state.copyWith(
            status: UserStatus.success,
            remoteUsers: updatedRemoteUsers,
            users: [...state.createdUsers, ...updatedRemoteUsers],
            currentPage: page.currentPage,
            hasMore: page.hasMore,
            isLoadingMore: false,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onAddUser(AddUserEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(isCreatingUser: true, clearCreatedUser: true));

    final result = await _createUser(
      CreateUserParams(name: event.name, job: event.job),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isCreatingUser: false, errorMessage: failure.message),
      ),
      (user) {
        final updatedCreatedUsers = [user, ...state.createdUsers];
        emit(
          state.copyWith(
            status: UserStatus.success,
            isCreatingUser: false,
            createdUsers: updatedCreatedUsers,
            users: [...updatedCreatedUsers, ...state.remoteUsers],
            createdUser: user,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onSyncUsers(
    SyncUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    final result = await _syncPendingUsers();
    result.fold(
      (failure) {
        if (failure is! NetworkFailure) {
          emit(state.copyWith(errorMessage: failure.message));
        }
      },
      (_) async {
        add(const LoadUsersEvent());
      },
    );
  }
}
