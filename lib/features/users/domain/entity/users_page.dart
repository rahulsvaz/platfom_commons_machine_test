import 'package:platfom_commons_machine_test/features/users/domain/entity/user.dart';

class UsersPage {
  final List<User> users;
  final int currentPage;
  final int totalPages;

  const UsersPage({
    required this.users,
    required this.currentPage,
    required this.totalPages,
  });

  bool get hasMore => currentPage < totalPages;
}
