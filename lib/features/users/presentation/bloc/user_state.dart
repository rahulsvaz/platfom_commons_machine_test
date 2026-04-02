part of 'user_bloc.dart';

enum UserStatus { initial, loading, success, error }

class UserState extends Equatable {
  final UserStatus status;
  final List<User> users;
  final List<User> createdUsers;
  final List<User> remoteUsers;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isCreatingUser;
  final String? errorMessage;
  final User? createdUser;

  const UserState({
    this.status = UserStatus.initial,
    this.users = const [],
    this.createdUsers = const [],
    this.remoteUsers = const [],
    this.currentPage = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.isCreatingUser = false,
    this.errorMessage,
    this.createdUser,
  });

  UserState copyWith({
    UserStatus? status,
    List<User>? users,
    List<User>? createdUsers,
    List<User>? remoteUsers,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isCreatingUser,
    String? errorMessage,
    User? createdUser,
    bool clearError = false,
    bool clearCreatedUser = false,
  }) {
    return UserState(
      status: status ?? this.status,
      users: users ?? this.users,
      createdUsers: createdUsers ?? this.createdUsers,
      remoteUsers: remoteUsers ?? this.remoteUsers,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isCreatingUser: isCreatingUser ?? this.isCreatingUser,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      createdUser: clearCreatedUser ? null : createdUser ?? this.createdUser,
    );
  }

  @override
  List<Object?> get props => [
    status,
    users,
    createdUsers,
    remoteUsers,
    currentPage,
    hasMore,
    isLoadingMore,
    isCreatingUser,
    errorMessage,
    createdUser,
  ];
}
