import 'package:dartz/dartz.dart';
import 'package:platfom_commons_machine_test/core/error/failures.dart';
import 'package:platfom_commons_machine_test/features/users/domain/entity/user.dart';
import 'package:platfom_commons_machine_test/features/users/domain/entity/users_page.dart';
import 'package:platfom_commons_machine_test/features/users/domain/repository/user_repo.dart';

class GetUsersPage {
  final UserRepo _repository;

  const GetUsersPage(this._repository);

  Future<Either<Failure, UsersPage>> call({required int page}) {
    return _repository.getUsersPage(page: page);
  }
}

class GetCreatedUsers {
  final UserRepo _repository;

  const GetCreatedUsers(this._repository);

  Future<Either<Failure, List<User>>> call() {
    return _repository.getCreatedUsers();
  }
}

class CreateUserParams {
  final String name;
  final String job;

  const CreateUserParams({required this.name, required this.job});
}

class CreateUserUseCase {
  final UserRepo _repository;

  const CreateUserUseCase(this._repository);

  Future<Either<Failure, User>> call(CreateUserParams params) {
    return _repository.createUser(name: params.name, job: params.job);
  }
}

class SyncPendingUsers {
  final UserRepo _repository;

  const SyncPendingUsers(this._repository);

  Future<Either<Failure, List<User>>> call() {
    return _repository.syncPendingUsers();
  }
}
