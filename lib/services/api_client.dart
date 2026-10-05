import 'package:dio/dio.dart';
import 'package:mediafarnetcc/model/auth_local_storage_service.dart';


class ApiException implements Exception {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? errors;

  ApiException({
    required this.statusCode,
    required this.message,
    this.errors,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {

  static const String _baseUrl = 'http://mediafarne.test/api';

  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );


    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final semAuth = options.extra['semAuth'] == true;

          if (!semAuth) {
            final authUser = await AuthLocalStorageService.carregarAuthUser();
            if (authUser != null) {
              options.headers['Authorization'] = 'Bearer ${authUser.tokenAuth}';
            }
          }


          return handler.next(options);
        },
      ),
    );
  }


  ApiException _tratarErro(DioException e) {

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return ApiException(
        statusCode: 0,
        message: 'Falha de conexão com o servidor.',
      );
    }

    final statusCode = e.response?.statusCode ?? 0;
    final body = e.response?.data;

    String mensagem = 'Erro desconhecido';
    Map<String, dynamic>? erros;

    if (body is Map<String, dynamic>) {
      mensagem = body['message'] ?? mensagem;
      if (body['errors'] is Map<String, dynamic>) {
        erros = body['errors'];
      }
    }

    switch (statusCode) {
      case 401:
        mensagem = 'Não autenticado. Faça login novamente.';
        break;
      case 404:
        mensagem = body is Map
            ? (body['message'] ?? 'Recurso não encontrado.')
            : 'Recurso não encontrado.';
        break;
      case 422:
        mensagem = 'Dados inválidos.';
        break;
      case 500:
        mensagem = 'Erro interno do servidor.';
        break;
    }

    return ApiException(statusCode: statusCode, message: mensagem, errors: erros);
  }

  Future<dynamic> get(String endpoint, {bool comAuth = true}) async {
    try {
      final response = await _dio.get(
        endpoint,
        options: Options(extra: {'semAuth': !comAuth}),
      );
      return response.data;
    } on DioException catch (e) {
      throw _tratarErro(e);
    }
  }

  Future<dynamic> post(
      String endpoint, {
        Map<String, dynamic>? body,
        bool comAuth = true,
      }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: body,
        options: Options(extra: {'semAuth': !comAuth}),
      );
      return response.data;
    } on DioException catch (e) {
      throw _tratarErro(e);
    }
  }

  Future<dynamic> put(
      String endpoint, {
        Map<String, dynamic>? body,
        bool comAuth = true,
      }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: body,
        options: Options(extra: {'semAuth': !comAuth}),
      );
      return response.data;
    } on DioException catch (e) {
      throw _tratarErro(e);
    }
  }

  Future<dynamic> delete(String endpoint, {bool comAuth = true}) async {
    try {
      final response = await _dio.delete(
        endpoint,
        options: Options(extra: {'semAuth': !comAuth}),
      );
      return response.data;
    } on DioException catch (e) {
      throw _tratarErro(e);
    }
  }
}