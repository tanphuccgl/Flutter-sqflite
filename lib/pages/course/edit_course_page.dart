// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutterdb/pages/course/courses_page.dart';
import 'package:flutterdb/database/database_local.dart';
import 'package:flutterdb/models/course_model.dart';
import 'package:flutterdb/models/student_model.dart';

class EditCoursePage extends StatefulWidget {
  final CourseModel course;
  final StudentModel student;

  const EditCoursePage(
      {super.key, required this.course, required this.student});

  @override
  _EditCoursePageState createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Hiển thị thông tin môn học cần chỉnh sửa lên giao diện.
    _nameController.text = widget.course.name;
    _scoreController.text = widget.course.score.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sửa môn học'),
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

                // Cập nhật thông tin môn học vào cơ sở dữ liệu.
                DatabaseLocal.updateCourse(
                  CourseModel(
                    id: widget.course.id,
                    name: _nameController.text,
                    score: double.tryParse(_scoreController.text) ?? 0.0,
                    studentId: widget.course.studentId,
                  ),
                );
                // Sau khi cập nhật, quay lại trang danh sách môn học của sinh viên.
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
              child: const Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );
  }
}
