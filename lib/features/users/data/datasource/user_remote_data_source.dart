import 'package:platfom_commons_machine_test/core/api/api_support.dart';
import 'package:platfom_commons_machine_test/core/api/dio_api_client.dart';
import 'package:platfom_commons_machine_test/features/users/data/model/pagenated_user_model.dart';
import 'package:platfom_commons_machine_test/features/users/data/model/user_model.dart';

class UserRemoteDataSource {
  final DioApiClient _dio;

  const UserRemoteDataSource(this._dio);

  Future<PaginatedUsersModel> getUsers({required int page}) async {
    final response = await _dio.get(
      ApiSupport.users(page: page),
      apiName: 'GetUsersPage$page',
    );
    return PaginatedUsersModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserModel> createUser({
    required String name,
    required String job,
  }) async {
    final response = await _dio.post(
      '/api/users',
      apiName: 'CreateUser',
      data: {'name': name, 'job': job},
    );

    return UserModel.fromCreateJson(
      response.data as Map<String, dynamic>,
      storageId: '',
      isSynced: true,
    );
  }
}
