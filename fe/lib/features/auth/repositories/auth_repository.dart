import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/auth_response.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<AuthResponse> login(String username, String password) async {
    try {
      final response = await _apiClient.client.post(
        'auth/login',
        data: {'username': username, 'password': password},
      );

      return AuthResponse.fromJson(response.data['data']);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Lỗi kết nối';
      throw Exception(errorMessage);
    }
  }

  Future<void> register(String username, String password) async {
    try {
      await _apiClient.client.post(
        'auth/register',
        data: {'username': username, 'password': password},
      );
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Đăng ký thật bại';
      throw Exception(errorMessage);
    }
  }
}
