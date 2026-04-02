import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platfom_commons_machine_test/core/navigation/app_navigator.dart';
import 'package:platfom_commons_machine_test/core/network/connectivity_cubit.dart';
import 'package:platfom_commons_machine_test/core/theme/app_theme.dart';
import 'package:platfom_commons_machine_test/core/sync/sync_service.dart';
import 'package:platfom_commons_machine_test/shared/injection_container.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ConnectivityCubit>(),
      child: BlocListener<ConnectivityCubit, ConnectivityState>(
        listenWhen: (previous, current) =>
            !previous.isOnline && current.isOnline,
        listener: (context, state) async {
          await sl<SyncService>().syncAll();
        },
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: AppNavigator.router,
        ),
      ),
    );
  }
}
