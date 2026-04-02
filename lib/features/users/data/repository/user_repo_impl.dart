import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:platfom_commons_machine_test/core/error/failures.dart';
import 'package:platfom_commons_machine_test/core/storage/app_boxes.dart';
import 'package:platfom_commons_machine_test/core/storage/hive_storage_service.dart';
import 'package:platfom_commons_machine_test/features/users/data/datasource/user_remote_data_source.dart';
import 'package:platfom_commons_machine_test/features/users/data/model/pagenated_user_model.dart';
import 'package:platfom_commons_machine_test/features/users/data/model/user_model.dart';
import 'package:platfom_commons_machine_test/features/users/domain/entity/user.dart';
import 'package:platfom_commons_machine_test/features/users/domain/entity/users_page.dart';
import 'package:platfom_commons_machine_test/features/users/domain/repository/user_repo.dart';

class UserRepoImpl implements UserRepo {
  final UserRemoteDataSource _remoteDataSource;
  final HiveStorageService _storage;

  const UserRepoImpl(this._remoteDataSource, this._storage);

  @override
  Future<Either<Failure, UsersPage>> getUsersPage({required int page}) async {
    final pageBox = _storage.box(AppBoxes.userPages);

    try {
      final remotePage = await _remoteDataSource.getUsers(page: page);
      await pageBox.put('page_$page', remotePage.toMap());
      return Right(remotePage.toEntity());
    } on DioException catch (e) {
      final cached = pageBox.get('page_$page');
      if (cached is Map) {
        return Right(
          PaginatedUsersModel.fromMap(
            Map<String, dynamic>.from(cached),
          ).toEntity(),
        );
      }
      return Left(
        ServerFailure(
          message:
              e.response?.data?['error'] as String? ??
              e.message ??
              'Unable to load users.',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getCreatedUsers() async {
    try {
      final usersBox = _storage.box(AppBoxes.users);
      final users =
          usersBox.values
              .map(
                (value) =>
                    UserModel.fromMap(Map<String, dynamic>.from(value as Map)),
              )
              .map((model) => model.toEntity())
              .toList()
            ..sort((a, b) => (b.createdAt ?? '').compareTo(a.createdAt ?? ''));
      return Right(users);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> createUser({
    required String name,
    required String job,
  }) async {
    final usersBox = _storage.box(AppBoxes.users);
    final storageId = 'local_${DateTime.now().microsecondsSinceEpoch}';

    try {
      final remoteUser = await _remoteDataSource.createUser(
        name: name,
        job: job,
      );
      final createdUser = UserModel.fromCreateJson(
        {
          'id': remoteUser.serverId,
          'name': remoteUser.fullName,
          'job': remoteUser.job,
          'createdAt': remoteUser.createdAt,
        },
        storageId: storageId,
        isSynced: true,
      );
      await usersBox.put(storageId, createdUser.toMap());
      return Right(createdUser.toEntity());
    } on DioException {
      final localUser = UserModel(
        storageId: storageId,
        fullName: name,
        email: '',
        avatar: '',
        job: job,
        createdAt: DateTime.now().toIso8601String(),
        isLocalCreated: true,
        isSynced: false,
      );
      await usersBox.put(storageId, localUser.toMap());
      return Right(localUser.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> syncPendingUsers() async {
    final usersBox = _storage.box(AppBoxes.users);
    try {
      final List<User> syncedUsers = [];
      final snapshot = usersBox.toMap();

      for (final entry in snapshot.entries) {
        final user = UserModel.fromMap(
          Map<String, dynamic>.from(entry.value as Map),
        );
        if (!user.isLocalCreated || user.isSynced) {
          continue;
        }

        final remoteUser = await _remoteDataSource.createUser(
          name: user.fullName,
          job: user.job ?? '',
        );

        final updatedUser = user.toEntity().copyWith(
          serverId: remoteUser.serverId,
          isSynced: true,
          createdAt: remoteUser.createdAt ?? user.createdAt,
        );

        await usersBox.put(
          entry.key,
          UserModel.fromEntity(updatedUser).toMap(),
        );
        syncedUsers.add(updatedUser);
      }

      return Right(syncedUsers);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.message ?? 'Sync failed.',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
