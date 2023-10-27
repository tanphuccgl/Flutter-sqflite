// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutterdb/b.dart';
import 'package:flutterdb/main.dart';

class EditCourse extends StatefulWidget {
  final Course course;
  final Student student;

  const EditCourse({super.key, required this.course, required this.student});

  @override
  _EditCourseState createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _rollNoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.course.name;

    _rollNoController.text = widget.course.score.toString();
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
              controller: _rollNoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Điểm'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                updateCourse(
                  Course(
                    id: widget.course.id,
                    name: _nameController.text,
                    score: int.tryParse(_rollNoController.text) ?? 0,
                    studentId: widget.course.studentId,
                  ),
                );
                Navigator.pop(context);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return CourseList(
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
