// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutterdb/database/database_local.dart';
import 'package:flutterdb/models/course_model.dart';
import 'package:flutterdb/models/student_model.dart';
import 'package:flutterdb/pages/course/courses_page.dart';

class CreateCoursePage extends StatefulWidget {
  final StudentModel student;

  // Constructor cho trang tạo môn học, chấp nhận một đối tượng StudentModel.
  const CreateCoursePage({
    Key? key,
    required this.student,
  }) : super(key: key);

  @override
  _CreateCoursePageState createState() => _CreateCoursePageState();
}

class _CreateCoursePageState extends State<CreateCoursePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm môn học'),
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
              controller: _scoreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Điểm'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Kiểm tra xem các trường thông tin đã được điền đầy đủ.
                if (_nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Điền đủ thông tin')));
                  return;
                }

                // Kiểm tra xem kiểu dữ liệu điểm hợp lệ.
                if (double.tryParse(_scoreController.text) == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Nhập sai kiểu dữ liệu. Vui lòng nhập lại')));
                  return;
                }

                if ((double.tryParse(_scoreController.text) ?? 0) < 0 ||
                    (double.tryParse(_scoreController.text) ?? 0) > 10) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Nhập sai kiểu dữ liệu. Vui lòng nhập lại')));
                  return;
                }

                // Thêm môn học vào cơ sở dữ liệu.
                DatabaseLocal.insertCourse(
                  CourseModel(
                    name: _nameController.text,
                    score: double.tryParse(_scoreController.text) ?? 0.0,
                    studentId: widget.student.id ?? 0,
                  ),
                );
                // Sau khi thêm môn học, quay lại trang danh sách môn học của sinh viên.
                Navigator.pop(context);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return CoursesPage(
                        student: widget.student,
                      );
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
}
