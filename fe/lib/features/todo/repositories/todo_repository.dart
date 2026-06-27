import 'package:dio/dio.dart';
import 'package:fe/core/api/api_client.dart';
import 'package:fe/features/todo/models/todo.dart';

class TodoRepository {
  final ApiClient _apiClient;

  TodoRepository(this._apiClient);

  Future<List<Todo>> fetchTodos() async {
    try {
      final response = await _apiClient.client.get('todo');

      if (response.data is Map<String, dynamic>) {
        final rawData = response.data['data'] ?? response.data['Data'];

        if (rawData is List) {
          return rawData.map((json) => Todo.fromJson(json)).toList();
        }
      } else if (response.data is List) {
        return (response.data as List)
            .map((json) => Todo.fromJson(json))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      String errorMessage = 'Không thể tải danh sách công việc';
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          errorMessage = data['message'] ?? data['Message'] ?? errorMessage;
        } else if (data is String && data.isNotEmpty) {
          errorMessage = data;
        }
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Lỗi xử lý dữ liệu từ máy chủ: $e');
    }
  }

  Future<Todo> createTodo(String title) async {
    try {
      final response = await _apiClient.client.post(
        'todo',
        data: {'title': title},
      );
      return Todo.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Tạo công việc thất bại');
    }
  }

  Future<Todo> updateTodo(int id, String? title, bool? isCompleted) async {
    try {
      final response = await _apiClient.client.put(
        'todo/$id',
        data: {
          if (title != null) 'title': title,
          if (isCompleted != null) 'isCompleted': isCompleted,
        },
      );

      if (response.data is Map<String, dynamic>) {
        final data = response.data['data'] ?? response.data['Data'];
        if (data != null) {
          return Todo.fromJson(data);
        }
        return Todo.fromJson(response.data);
      }

      throw Exception('Dữ liệu phản hồi không đúng định dạng');
    } on DioException catch (e) {
      String errorMessage = 'Cập nhật thất bại';

      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          errorMessage = data['message'] ?? data['Message'] ?? errorMessage;
        } else if (data is String && data.isNotEmpty) {
          errorMessage = data; // Bắt gọn chuỗi văn bản thuần túy
        }
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Lỗi hệ thống: $e');
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await _apiClient.client.delete('todo/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Xóa thất bại');
    }
  }
}
