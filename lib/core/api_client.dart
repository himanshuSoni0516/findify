import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'storage_service.dart';

class ApiClient {
  // Base headers for REST API (no auth)
  static Map<String, String> get baseHeaders => {
    'Content-Type': 'application/json',
    'apikey': AppConstants.supabaseAnonKey,
  };

  // Headers with JWT token (for protected routes)
  static Future<Map<String, String>> get authHeaders async {
    final token = await StorageService.getToken();
    return {
      'Content-Type': 'application/json',
      'apikey': AppConstants.supabaseAnonKey,
      'Authorization': 'Bearer $token',
    };
  }

  // POST request
  static Future<http.Response> post(
      String url,
      Map<String, dynamic> body, {
        bool requiresAuth = false,
      }) async {
    final headers = requiresAuth ? await authHeaders : baseHeaders;
    return http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  // GET request
  static Future<http.Response> get(
      String url, {
        bool requiresAuth = true,
        Map<String, String>? extraHeaders,
      }) async {
    final headers = requiresAuth ? await authHeaders : baseHeaders;
    if (extraHeaders != null) headers.addAll(extraHeaders);
    return http.get(Uri.parse(url), headers: headers);
  }

  // PATCH request
  static Future<http.Response> patch(
      String url,
      Map<String, dynamic> body,
      ) async {
    final headers = await authHeaders;
    return http.patch(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  // DELETE request
  static Future<http.Response> delete(String url) async {
    final headers = await authHeaders;
    return http.delete(Uri.parse(url), headers: headers);
  }
}