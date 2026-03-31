import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class ApiService extends GetxService {
  // ✅ CHANGE CETTE URL SELON TON ENVIRONNEMENT
  static const String baseUrl = 'http://10.0.2.2/immo_api/api';
  // Android emulator → 10.0.2.2
  // iOS simulator   → localhost
  // Device réel     → IP de ton PC (ex: 192.168.1.69)

  final StorageService _storage = Get.find<StorageService>();

  // ========== HEADERS ==========

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = _storage.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Map<String, String> get _headersMultipart {
    final headers = <String, String>{
      'Accept': 'application/json',
    };

    final token = _storage.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // ========== MÉTHODES HTTP ==========

  /// GET request
  Future<ApiResult> get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl$endpoint');
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      return ApiResult.error('Pas de connexion internet');
    } on HttpException {
      return ApiResult.error('Erreur de connexion au serveur');
    } catch (e) {
      return ApiResult.error('Erreur: ${e.toString()}');
    }
  }

  /// POST request
  Future<ApiResult> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .post(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      return ApiResult.error('Pas de connexion internet');
    } on HttpException {
      return ApiResult.error('Erreur de connexion au serveur');
    } catch (e) {
      return ApiResult.error('Erreur: ${e.toString()}');
    }
  }

  /// PUT request
  Future<ApiResult> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .put(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      return ApiResult.error('Pas de connexion internet');
    } on HttpException {
      return ApiResult.error('Erreur de connexion au serveur');
    } catch (e) {
      return ApiResult.error('Erreur: ${e.toString()}');
    }
  }

  /// DELETE request
  Future<ApiResult> delete(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .delete(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      return ApiResult.error('Pas de connexion internet');
    } on HttpException {
      return ApiResult.error('Erreur de connexion au serveur');
    } catch (e) {
      return ApiResult.error('Erreur: ${e.toString()}');
    }
  }

  /// MULTIPART request (upload fichiers)
  Future<ApiResult> uploadFile(
    String endpoint, {
    required File file,
    required Map<String, String> fields,
    String fileField = 'fichier',
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll(_headersMultipart);
      request.fields.addAll(fields);
      request.files.add(
        await http.MultipartFile.fromPath(fileField, file.path),
      );

      final streamedResponse = await request.send().timeout(
            const Duration(seconds: 60),
          );
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } on SocketException {
      return ApiResult.error('Pas de connexion internet');
    } catch (e) {
      return ApiResult.error('Erreur upload: ${e.toString()}');
    }
  }

  // ========== GESTION DES RÉPONSES ==========

  ApiResult _handleResponse(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;

      // Token expiré ou invalide
      if (response.statusCode == 401) {
        _handleUnauthorized();
        return ApiResult(
          success: false,
          statusCode: 401,
          message: body['message'] ?? 'Session expirée',
          data: body,
        );
      }

      return ApiResult(
        success: body['success'] ?? false,
        statusCode: response.statusCode,
        message: body['message'] ?? '',
        data: body,
      );
    } catch (_) {
      return ApiResult(
        success: false,
        statusCode: response.statusCode,
        message: 'Erreur de parsing de la réponse',
        data: null,
      );
    }
  }

  void _handleUnauthorized() {
    _storage.clearSession();
    // La redirection sera gérée par le middleware GetX
  }

  // ========== URL HELPERS ==========

  /// Construit l'URL complète pour un fichier (photo, document, qrcode)
  String getFileUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    // Remonte d'un niveau depuis /api pour accéder aux fichiers
    return baseUrl.replaceAll('/api', '/$path');
  }
}

// ========== RÉSULTAT API ==========

class ApiResult {
  final bool success;
  final int statusCode;
  final String message;
  final Map<String, dynamic>? data;

  ApiResult({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory ApiResult.error(String message) {
    return ApiResult(
      success: false,
      statusCode: 0,
      message: message,
      data: null,
    );
  }

  /// Récupère le champ "data" de la réponse JSON
  dynamic get responseData => data?['data'];

  /// Récupère la pagination
  Map<String, dynamic>? get pagination =>
      data?['pagination'] as Map<String, dynamic>?;

  /// Récupère les erreurs de validation
  List<String> get validationErrors {
    if (data?['errors'] != null) {
      return List<String>.from(data!['errors']);
    }
    return [];
  }

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isValidationError => statusCode == 422;
  bool get isServerError => statusCode == 500;
}