import 'package:flutter/foundation.dart';
import 'package:platfom_commons_machine_test/core/api/dio_api_client.dart';
import 'package:platfom_commons_machine_test/core/storage/hive_storage_service.dart';
import 'package:platfom_commons_machine_test/core/sync/sync_service.dart';
import 'package:platfom_commons_machine_test/features/users/data/datasource/user_remote_data_source.dart';
import 'package:workmanager/workmanager.dart';

const String syncTaskName = 'sync-offline-payloads';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      final storage = HiveStorageService();
      await storage.init();
      final syncService = SyncService(
        storage,
        UserRemoteDataSource(DioApiClient()),
      );
      await syncService.syncAll();
      return true;
    } catch (error, stackTrace) {
      debugPrint('Workmanager sync failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  });
}

class WorkmanagerBootstrap {
  const WorkmanagerBootstrap._();

  static Future<void> init() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
    await Workmanager().registerPeriodicTask(
      syncTaskName,
      syncTaskName,
      frequency: const Duration(hours: 1),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );
  }
}
