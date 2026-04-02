import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  final Connectivity _connectivity;
  final InternetConnectionChecker _checker;

  ConnectivityService({
    Connectivity? connectivity,
    InternetConnectionChecker? checker,
  }) : _connectivity = connectivity ?? Connectivity(),
       _checker = checker ?? InternetConnectionChecker();

  Future<bool> hasInternetConnection() async {
    final result = await _connectivity.checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      return false;
    }
    return _checker.hasConnection;
  }

  Stream<bool> connectionStream() {
    return _connectivity.onConnectivityChanged.asyncMap((result) async {
      if (result.contains(ConnectivityResult.none)) {
        return false;
      }
      return _checker.hasConnection;
    }).distinct();
  }
}
