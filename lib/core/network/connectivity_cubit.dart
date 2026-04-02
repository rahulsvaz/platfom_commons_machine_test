import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:platfom_commons_machine_test/core/network/connectivity_service.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final ConnectivityService _service;
  StreamSubscription<bool>? _subscription;

  ConnectivityCubit(this._service) : super(const ConnectivityState()) {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final hasInternet = await _service.hasInternetConnection();
    emit(ConnectivityState(isOnline: hasInternet));
    _subscription = _service.connectionStream().listen((hasInternet) {
      emit(ConnectivityState(isOnline: hasInternet));
    });
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
