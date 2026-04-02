import 'package:dartz/dartz.dart';
import 'package:platfom_commons_machine_test/core/error/failures.dart';
import 'package:platfom_commons_machine_test/features/users/domain/entity/user.dart';
import 'package:platfom_commons_machine_test/features/users/domain/entity/users_page.dart';

abstract class UserRepo {
  Future<Either<Failure, UsersPage>> getUsersPage({required int page});
  Future<Either<Failure, List<User>>> getCreatedUsers();
  Future<Either<Failure, User>> createUser({
    required String name,
    required String job,
  });
  Future<Either<Failure, List<User>>> syncPendingUsers();
}
