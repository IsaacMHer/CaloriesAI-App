import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../core/constants/api_constants.dart';
import 'storage_service.dart';

/// Servicio base para todas las llamadas a la API usando Dio
class ApiService {
  final Dio _dio;
  final StorageService _storage;
  final Logger _logger = Logger();

  ApiService(this._storage) : _dio = Dio() {
    _configureDio();
  }

  /// Configura Dio con interceptores y opciones base
  void _configureDio() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout =
        const Duration(milliseconds: ApiConstants.connectTimeout);
    _dio.options.receiveTimeout =
        const Duration(milliseconds: ApiConstants.receiveTimeout);
    _dio.options.headers['Content-Type'] = ApiConstants.contentTypeJson;

    // Interceptor para agregar token automáticamente
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Agregar token si existe
          final token = _storage.getString('auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers[ApiConstants.authorizationHeader] =
                '${ApiConstants.bearerPrefix} $token';
          }

          _logger.d('Request: ${options.method} ${options.path}');
          _logger.d('Headers: ${options.headers}');
          if (options.data != null) {
            _logger.d('Data: ${options.data}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d('Response: ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          _logger.e(
            'Error: ${error.response?.statusCode} ${error.requestOptions.path}',
            error: error,
          );
          return handler.next(error);
        },
      ),
    );
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Upload multipart file
  Future<Response> uploadFile(
    String path,
    String filePath,
    String fieldName, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?data,
      });

      final response = await _dio.post(path, data: formData);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Maneja errores de Dio y los convierte en mensajes amigables
  Exception _handleError(DioException error) {
    String errorMessage;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Tiempo de espera agotado. Verifica tu conexión.';
        break;

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        if (statusCode == 400) {
          errorMessage = data?['message'] ?? 'Solicitud inválida';
        } else if (statusCode == 401) {
          errorMessage = 'No autorizado. Inicia sesión nuevamente.';
        } else if (statusCode == 403) {
          errorMessage = 'Acceso denegado';
        } else if (statusCode == 404) {
          errorMessage = 'Recurso no encontrado';
        } else if (statusCode == 500) {
          errorMessage = 'Error en el servidor. Intenta más tarde.';
        } else {
          errorMessage = data?['message'] ?? 'Error en la solicitud';
        }
        break;

      case DioExceptionType.cancel:
        errorMessage = 'Solicitud cancelada';
        break;

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          errorMessage = 'Sin conexión a internet';
        } else {
          errorMessage = 'Error desconocido. Intenta nuevamente.';
        }
        break;

      default:
        errorMessage = 'Error de conexión';
    }

    return Exception(errorMessage);
  }
}
