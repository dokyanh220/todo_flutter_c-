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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: const Center(child: Text('Dữ liệu Todo sẽ được tải ở đây...')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic mở form thêm Todo
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
