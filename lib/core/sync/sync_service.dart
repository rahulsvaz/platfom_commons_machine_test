import 'package:platfom_commons_machine_test/core/storage/app_boxes.dart';
import 'package:platfom_commons_machine_test/core/storage/hive_storage_service.dart';
import 'package:platfom_commons_machine_test/features/users/data/datasource/user_remote_data_source.dart';

class SyncService {
  final HiveStorageService _storage;
  final UserRemoteDataSource _userRemoteDataSource;

  const SyncService(this._storage, this._userRemoteDataSource);

  Future<void> syncPendingUsers() async {
    final usersBox = _storage.box(AppBoxes.users);
    final Map<dynamic, dynamic> snapshot = usersBox.toMap();

    for (final entry in snapshot.entries) {
      final value = entry.value;
      if (value is! Map ||
          value['isLocalCreated'] != true ||
          value['isSynced'] == true) {
        continue;
      }

      final createdUser = await _userRemoteDataSource.createUser(
        name: value['fullName'] as String? ?? '',
        job: value['job'] as String? ?? '',
      );

      final updated = Map<String, dynamic>.from(value)
        ..['serverId'] = createdUser.serverId
        ..['isSynced'] = true
        ..['createdAt'] = createdUser.createdAt
        ..['avatar'] = value['avatar'] ?? ''
        ..['email'] = value['email'] ?? ''
        ..['fullName'] = createdUser.fullName;

      await usersBox.put(entry.key, updated);
    }
  }

  Future<void> markBookmarkSyncComplete() async {
    final bookmarksBox = _storage.box(AppBoxes.bookmarks);
    final Map<dynamic, dynamic> snapshot = bookmarksBox.toMap();

    for (final entry in snapshot.entries) {
      final items = (entry.value as List<dynamic>? ?? [])
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
      final updated = items
          .map((item) => item..['isSynced'] = true)
          .toList(growable: false);
      await bookmarksBox.put(entry.key, updated);
    }
  }

  Future<void> syncAll() async {
    await syncPendingUsers();
    await markBookmarkSyncComplete();
  }
}
