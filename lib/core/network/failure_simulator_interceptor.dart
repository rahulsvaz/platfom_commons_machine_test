import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';

class FailureSimulatorInterceptor extends Interceptor {
  final bool enabled;
  final Random _random;

  FailureSimulatorInterceptor({required this.enabled, Random? random})
    : _random = random ?? Random();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!enabled || options.method != 'GET') {
      handler.next(options);
      return;
    }

    if (_random.nextDouble() <= 0.30) {
      final statusCode = _random.nextBool() ? 500 : null;
      handler.reject(
        DioException(
          requestOptions: options,
          error: statusCode == null
              ? const SocketException('Simulated network failure')
              : 'Simulated server failure',
          response: statusCode == null
              ? null
              : Response<dynamic>(
                  requestOptions: options,
                  statusCode: statusCode,
                  data: const {'status_message': 'Simulated server failure'},
                ),
          type: DioExceptionType.unknown,
        ),
      );
      return;
    }

    handler.next(options);
  }
}
