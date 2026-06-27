import 'package:fe/features/auth/providers/auth_provider.dart';
import 'package:fe/features/todo/models/todo.dart';
import 'package:fe/features/todo/repositories/todo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TodoRepository(apiClient);
});

class TodoNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  final TodoRepository _repository;

  TodoNotifier(this._repository) : super(const AsyncLoading()) {
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    try {
      state = const AsyncLoading();
      final todos = await _repository.fetchTodos();
      state = AsyncData(todos);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> addTodo(String title) async {
    try {
      final newTodo = await _repository.createTodo(title);

      if (state is AsyncData) {
        final currentList = state.value!;
        state = AsyncData([newTodo, ...currentList]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int id, bool currentStatus) async {
    if (currentStatus == true) return;

    final previousState = state;

    if (state is AsyncData) {
      final currentList = state.value!;
      state = AsyncData(
        currentList.map((t) {
          if (t.id == id) {
            return Todo(
              id: t.id,
              title: t.title,
              isCompleted: true, // Ép thành true
              createdAt: t.createdAt,
            );
          }
          return t;
        }).toList(),
      );
    }

    try {
      await _repository.updateTodo(id, null, true);
    } catch (e) {
      state = previousState;
      rethrow;
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await _repository.deleteTodo(id);

      if (state is AsyncData) {
        final currentList = state.value!;
        state = AsyncData(currentList.where((t) => t.id != id).toList());
      }
    } catch (e) {
      rethrow;
    }
  }
}

final todoNotifierProvider =
    StateNotifierProvider<TodoNotifier, AsyncValue<List<Todo>>>((ref) {
      return TodoNotifier(ref.watch(todoRepositoryProvider));
    });
