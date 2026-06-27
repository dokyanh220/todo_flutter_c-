import 'package:fe/features/todo/providers/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/views/login_screen.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  void _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authNotifierProvider.notifier).logout();
    if (context.mounted) {
      // Xóa toàn bộ stack màn hình cũ và đẩy về Login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm công việc'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nhập tiêu đề...'),
          autofocus: true, // Tự động bật bàn phím
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = controller.text.trim();
              if (title.isNotEmpty) {
                // Gọi action thêm mới và đóng popup
                ref.read(todoNotifierProvider.notifier).addTodo(title);
                Navigator.pop(context);
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lắng nghe trạng thái từ Provider
    final todoState = ref.watch(todoNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách công việc'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context, ref),
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      // Xử lý UI dựa trên AsyncValue của Riverpod
      body: todoState.when(
        data: (todos) {
          if (todos.isEmpty) {
            return const Center(child: Text('Chưa có công việc nào.'));
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              // Format thời gian hiển thị (VD: 28/6 12:30)
              final timeString =
                  "${todo.createdAt.day}/${todo.createdAt.month} ${todo.createdAt.hour}:${todo.createdAt.minute.toString().padLeft(2, '0')}";

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Cột 1: Tiêu đề (flex: 3)
                      Expanded(
                        flex: 3,
                        child: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: todo.isCompleted
                                ? Colors.grey
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow:
                              TextOverflow.ellipsis, // Cắt chữ nếu quá dài
                        ),
                      ),

                      // Cột 2: Thời gian tạo (flex: 2)
                      Expanded(
                        flex: 2,
                        child: Text(
                          timeString,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),

                      // Cột 3: Hoàn thành (flex: 1)
                      Expanded(
                        flex: 1,
                        child: Checkbox(
                          value: todo.isCompleted,
                          onChanged: (_) {
                            ref
                                .read(todoNotifierProvider.notifier)
                                .toggleStatus(todo.id, todo.isCompleted);
                          },
                        ),
                      ),

                      // Cột 4: Xóa (flex: 1)
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            ref
                                .read(todoNotifierProvider.notifier)
                                .deleteTodo(todo.id);
                          },
                          padding: EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(), // Thu gọn khoảng trắng thừa của IconButton
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Lỗi: $error', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(todoNotifierProvider.notifier).fetchTodos(),
                child: const Text('Tải lại'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
