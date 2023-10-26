// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutterdb/main.dart';

class EditStudent extends StatefulWidget {
  final Student student;

  const EditStudent({super.key, required this.student});

  @override
  _EditStudentState createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.student.name;
    _ageController.text = widget.student.address.toString();
    _rollNoController.text = widget.student.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sửa thông tin sinh viên'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Địa chỉ'),
            ),
            TextField(
              controller: _rollNoController,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                updateStudent(
                  Student(
                    id: widget.student.id,
                    name: _nameController.text,
                    address: _ageController.text,
                    phone: _rollNoController.text,
                  ),
                );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return StudentList();
                    },
                  ),
                );
              },
              child: const Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );
  }
}
