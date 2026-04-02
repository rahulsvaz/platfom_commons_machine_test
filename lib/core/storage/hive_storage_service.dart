import 'package:hive_flutter/hive_flutter.dart';
import 'package:platfom_commons_machine_test/core/storage/app_boxes.dart';

class HiveStorageService {
  const HiveStorageService();

  Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<dynamic>(AppBoxes.users),
      Hive.openBox<dynamic>(AppBoxes.userPages),
      Hive.openBox<dynamic>(AppBoxes.moviePages),
      Hive.openBox<dynamic>(AppBoxes.movieDetails),
      Hive.openBox<dynamic>(AppBoxes.bookmarks),
    ]);
  }

  Box<dynamic> box(String name) => Hive.box<dynamic>(name);
}
