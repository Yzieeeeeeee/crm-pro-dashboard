import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Centralized Dio HTTP client with interceptors, logging, and error handling.
class DioClient {
  DioClient._();
  static final DioClient instance = DioClient._();

  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  final Logger _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  /// Static toggle to simulate network offline state.
  static bool isOfflineSimulated = false;

  late final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )..interceptors.addAll([
      _OfflineSimulationInterceptor(),
      _LoggingInterceptor(_logger),
      _ErrorInterceptor(),
    ]);
}

/// Intercepts requests and rejects immediately if offline mode is simulated.
class _OfflineSimulationInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (DioClient.isOfflineSimulated) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'No internet connection (Simulated)',
        ),
      );
    } else {
      handler.next(options);
    }
  }
}

/// Logs request and response details for debugging.
class _LoggingInterceptor extends Interceptor {
  final Logger _logger;

  _LoggingInterceptor(this._logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i('→ ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.i('← ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e('✗ ${err.type} ${err.requestOptions.uri}');
    handler.next(err);
  }
}

/// Maps Dio errors to typed exceptions.
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: const NetworkException('Connection timed out'),
            type: err.type,
          ),
        );
        break;
      case DioExceptionType.connectionError:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: const NetworkException('No internet connection'),
            type: err.type,
          ),
        );
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode ?? 0;
        final message = _getServerErrorMessage(statusCode);
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ServerException(message, statusCode),
            type: err.type,
            response: err.response,
          ),
        );
        break;
      default:
        handler.next(err);
    }
  }

  String _getServerErrorMessage(int code) {
    switch (code) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Resource not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Server error ($code)';
    }
  }
}

/// Exception for network-related errors.
class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);

  @override
  String toString() => message;
}

/// Exception for server-side errors with HTTP status codes.
class ServerException implements Exception {
  final String message;
  final int statusCode;
  const ServerException(this.message, this.statusCode);

  @override
  String toString() => '$message (HTTP $statusCode)';
}
