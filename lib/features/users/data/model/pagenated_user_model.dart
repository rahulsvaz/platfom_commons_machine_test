import 'package:platfom_commons_machine_test/features/users/data/model/user_model.dart';
import 'package:platfom_commons_machine_test/features/users/domain/entity/users_page.dart';

class PaginatedUsersModel {
  final int page;
  final int totalPages;
  final List<UserModel> users;

  const PaginatedUsersModel({
    required this.page,
    required this.totalPages,
    required this.users,
  });

  factory PaginatedUsersModel.fromJson(Map<String, dynamic> json) {
    return PaginatedUsersModel(
      page: json['page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 1,
      users: (json['data'] as List<dynamic>? ?? [])
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  factory PaginatedUsersModel.fromMap(Map<String, dynamic> map) {
    return PaginatedUsersModel(
      page: map['page'] as int? ?? 1,
      totalPages: map['totalPages'] as int? ?? 1,
      users: (map['users'] as List<dynamic>? ?? [])
          .map((e) => UserModel.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'page': page,
      'totalPages': totalPages,
      'users': users.map((user) => user.toMap()).toList(growable: false),
    };
  }

  UsersPage toEntity() {
    return UsersPage(
      users: users.map((user) => user.toEntity()).toList(growable: false),
      currentPage: page,
      totalPages: totalPages,
    );
  }
}
