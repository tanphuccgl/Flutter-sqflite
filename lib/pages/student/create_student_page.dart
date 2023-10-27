// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutterdb/database/database_local.dart';
import 'package:flutterdb/models/student_model.dart';
import 'package:flutterdb/pages/student/students_page.dart';

class CreateStudentPage extends StatefulWidget {
  const CreateStudentPage({super.key});

  @override
  _CreateStudentPageState createState() => _CreateStudentPageState();
}

class _CreateStudentPageState extends State<CreateStudentPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm sinh viên'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên học sinh'),
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Địa chỉ'),
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Kiểm tra xem các trường thông tin đã được điền đầy đủ.
                if (_nameController.text.isEmpty ||
                    _phoneController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Điền đủ thông tin')));
                  return;
                }
                // Kiểm tra xem kiểu dữ liệu số điện thoại hợp lệ và tên không chứa số.
                if (int.tryParse(_phoneController.text) == null ||
                    containsNumber(_nameController.text) == true) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Nhập sai kiểu dữ liệu. Vui lòng nhập lại')));
                  return;
                }
                // Thêm thông tin học sinh vào cơ sở dữ liệu.
                DatabaseLocal.insertStudent(
                  StudentModel(
                    name: _nameController.text,
                    address: _addressController.text,
                    phone: int.tryParse(_phoneController.text) ?? 0,
                  ),
                );
                // Sau khi thêm, quay lại trang danh sách sinh viên.
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return const StudentList();
                    },
                  ),
                );
              },
              child: const Text('Thêm'),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm này kiểm tra xem tên có chứa số không.
  bool containsNumber(String name) {
    for (int i = 0; i < name.length; i++) {
      if (name[i].contains(RegExp(r'[0-9]'))) {
        return true;
      }
    }
    return false;
  }
}
