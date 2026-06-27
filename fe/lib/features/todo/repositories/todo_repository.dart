import 'package:dio/dio.dart';
import 'package:fe/core/api/api_client.dart';
import 'package:fe/features/todo/models/todo.dart';

class TodoRepository {
  final ApiClient _apiClient;

  TodoRepository(this._apiClient);

  Future<List<Todo>> fetchTodos() async {
    try {
      final response = await _apiClient.client.get('todo');

      final List data = response.data['data'];
      return data.map((json) => Todo.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Không thể tải danh sách công việc',
      );
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
      final response = await _apiClient.client.post(
        'todo/$id',
        data: {
          if (title != null) 'title': title,
          if (isCompleted != null) 'isCompleted': isCompleted,
        },
      );
      return Todo.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Tạo công việc thất bại');
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
