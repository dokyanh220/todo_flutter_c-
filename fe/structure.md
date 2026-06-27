lib/
├── core/                  # Chứa các thành phần dùng chung toàn hệ thống
│   ├── api/
│   │   └── api_client.dart    # Cấu hình Dio & Interceptors
│   ├── constants/
│   │   └── api_constants.dart # Lưu Base URL và các hằng số
│   └── exceptions/
│       └── app_exception.dart # Xử lý lỗi từ API trả về
├── features/              # Chia theo từng chức năng nghiệp vụ
│   ├── auth/
│   │   ├── models/
│   │   ├── repositories/
│   │   ├── providers/
│   │   └── views/
│   └── todo/
│       ├── models/
│       ├── repositories/
│       ├── providers/
│       └── views/
└── main.dart              # Điểm entry, bọc ProviderScope