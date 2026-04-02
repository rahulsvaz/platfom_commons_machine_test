import 'package:flutter/material.dart';
import 'package:platfom_commons_machine_test/core/sync/workmanager_bootstrap.dart';
import 'package:platfom_commons_machine_test/shared/injection_container.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await WorkmanagerBootstrap.init();
  runApp(const MyApp());
}
