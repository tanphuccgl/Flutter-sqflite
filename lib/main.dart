// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_typing_uninitialized_variables, depend_on_referenced_packages
// Dòng chú thích trên đây được sử dụng để tắt đi các cảnh báo cụ thể trong mã nguồn.

import 'package:flutterdb/database/database_local.dart'; // Import file liên quan đến cơ sở dữ liệu

import 'package:flutter/material.dart'; // Import thư viện Flutter Material

import 'pages/student/students_page.dart'; // Import trang Students

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Đảm bảo đã khởi tạo Flutter trước khi chạy ứng dụng
  await DatabaseLocal.init(); // Khởi tạo cơ sở dữ liệu cục bộ
  runApp(MyApp()); // Chạy ứng dụng chính
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StudentList(), // Trang chính của ứng dụng là StudentList
    );
  }
}
