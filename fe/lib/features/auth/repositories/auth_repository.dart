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

      if (response.data['data'] != null) {
        return AuthResponse.fromJson(response.data['data']);
      } else {
        return AuthResponse.fromJson(response.data);
      }
    } on DioException catch (e) {
      String errorMessage = 'Lỗi kết nối';

      if (e.response != null) {
        // Có phản hồi từ server (VD: 401, 400, 500)
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          errorMessage =
              data['message'] ??
              data['Message'] ??
              'Lỗi HTTP ${e.response!.statusCode}';
        } else if (data is String && data.isNotEmpty) {
          errorMessage = data;
        }
      } else {
        // Không kết nối được (VD: server sập, sai IP, hoặc lỗi SSL)
        errorMessage = 'Lỗi mạng: ${e.message}';
      }

      throw Exception(errorMessage); // Ném lỗi có thông điệp rõ ràng
    } catch (e) {
      // Bắt các lỗi do code Frontend (VD: lỗi parse JSON, Type Error)
      throw Exception('Lỗi xử lý dữ liệu: $e');
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
