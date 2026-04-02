import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:platfom_commons_machine_test/core/network/failure_simulator_interceptor.dart';

import 'api_support.dart';

class DioApiClient {
  static final DioApiClient _instance = DioApiClient._internal();
  factory DioApiClient() => _instance;

  late final Dio _reqresDio;
  late final Dio _movieDio;

  DioApiClient._internal() {
    _reqresDio = _buildReqresClient();
    _movieDio = _buildMovieClient();
  }

  void _logResponse(String apiName, Response response) {
    log('┌─────────────────────────────────────────', name: apiName);
    log('│ 📡 API     : $apiName', name: apiName);
    log('│ 🔗 URL     : ${response.requestOptions.uri}', name: apiName);
    log('│ ✅ Status  : ${response.statusCode}', name: apiName);
    log('│ 📦 Response: ${response.data}', name: apiName);
    log('└─────────────────────────────────────────', name: apiName);
  }

  void _logError(String apiName, DioException e) {
    log('┌─────────────────────────────────────────', name: apiName);
    log('│ 📡 API     : $apiName', name: apiName);
    log('│ 🔗 URL     : ${e.requestOptions.uri}', name: apiName);
    log('│ ❌ Status  : ${e.response?.statusCode}', name: apiName);
    log('│ 💬 Message : ${e.message}', name: apiName);
    log('└─────────────────────────────────────────', name: apiName);
  }

  Future<Response> get(
    String path, {
    required String apiName,
    bool useMovieApi = false,
    bool logResponse = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    const maxAttempts = 3;
    DioException? lastError;
    final client = useMovieApi ? _movieDio : _reqresDio;

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final response = await client.get(
          path,
          queryParameters: queryParameters,
          options: options,
        );
        if (logResponse) _logResponse(apiName, response);
        return response;
      } on DioException catch (e) {
        lastError = e;
        _logError(apiName, e);

        final shouldRetry = _isRetryableGetError(e);
        if (!shouldRetry || attempt == maxAttempts) {
          rethrow;
        }

        await Future.delayed(_retryDelay(attempt));
      }
    }

    throw lastError!;
  }

  Future<Response> post(
    String path, {
    required String apiName,
    bool useMovieApi = false,
    required dynamic data,
    bool logResponse = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await (useMovieApi ? _movieDio : _reqresDio).post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      if (logResponse) _logResponse(apiName, response);
      return response;
    } on DioException catch (e) {
      _logError(apiName, e);
      rethrow;
    }
  }

  Future<Response> put(
    String path, {
    required String apiName,
    bool useMovieApi = false,
    required dynamic data,
    bool logResponse = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await (useMovieApi ? _movieDio : _reqresDio).put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      if (logResponse) _logResponse(apiName, response);
      return response;
    } on DioException catch (e) {
      _logError(apiName, e);
      rethrow;
    }
  }

  Future<Response> delete(
    String path, {
    required String apiName,
    bool useMovieApi = false,
    dynamic data,
    bool logResponse = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await (useMovieApi ? _movieDio : _reqresDio).delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      if (logResponse) _logResponse(apiName, response);
      return response;
    } on DioException catch (e) {
      _logError(apiName, e);
      rethrow;
    }
  }

  bool _isRetryableGetError(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode != null && statusCode >= 500) {
      return true;
    }

    final exception = error.error;
    if (exception is SocketException) {
      return true;
    }

    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.unknown;
  }

  Duration _retryDelay(int attempt) {
    final seconds = switch (attempt) {
      1 => 1,
      2 => 2,
      _ => 4,
    };
    return Duration(seconds: seconds);
  }

  Dio _buildReqresClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiSupport.reqresBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'x-api-key': ApiSupport.reqresApiKey,
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) {
          _logError(e.requestOptions.path, e);
          handler.next(e);
        },
      ),
    );

    dio.interceptors.add(
      FailureSimulatorInterceptor(enabled: ApiSupport.enableFailureSimulation),
    );

    return dio;
  }

  Dio _buildMovieClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiSupport.movieBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {'accept': 'application/json'},
        queryParameters: {'apikey': ApiSupport.movieApiKey},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) {
          _logError(e.requestOptions.path, e);
          handler.next(e);
        },
      ),
    );

    dio.interceptors.add(
      FailureSimulatorInterceptor(enabled: ApiSupport.enableFailureSimulation),
    );

    return dio;
  }
}
