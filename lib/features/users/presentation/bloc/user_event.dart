part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsersEvent extends UserEvent {
  const LoadUsersEvent();
}

class LoadMoreUsersEvent extends UserEvent {
  const LoadMoreUsersEvent();
}

class AddUserEvent extends UserEvent {
  final String name;
  final String job;

  const AddUserEvent({required this.name, required this.job});

  @override
  List<Object?> get props => [name, job];
}

class SyncUsersEvent extends UserEvent {
  const SyncUsersEvent();
}
