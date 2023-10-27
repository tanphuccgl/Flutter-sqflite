// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutterdb/pages/course/courses_page.dart';
import 'package:flutterdb/database/database_local.dart';
import 'package:flutterdb/models/student_model.dart';
import 'package:flutterdb/pages/student/create_student_page.dart';
import 'package:flutterdb/pages/student/edit_student_page.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  List<StudentModel> _students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  // Hàm _loadStudents được gọi trong initState để tải danh sách sinh viên từ cơ sở dữ liệu.
  _loadStudents() async {
    List<StudentModel> students = await DatabaseLocal.getStudents();

    setState(() {
      _students = students;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Đặt tiêu đề của ứng dụng khi hiển thị danh sách sinh viên.
        automaticallyImplyLeading: false,
        title: const Text('Danh sách sinh viên'),
      ),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Khi người dùng chọn một sinh viên, họ sẽ được chuyển đến trang CoursesPage.
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CoursesPage(student: _students[index]),
                ),
              );
            },
            child: ListTile(
              title: Text(_students[index].name),
              subtitle: Text('Địa chỉ: ${_students[index].address}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Khi người dùng nhấn vào biểu tượng chỉnh sửa, họ sẽ được chuyển đến trang EditStudentPage.
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              EditStudentPage(student: _students[index]),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Khi người dùng nhấn vào biểu tượng xóa, sinh viên sẽ bị xóa khỏi cơ sở dữ liệu.
                      DatabaseLocal.deleteStudent(_students[index].id ?? 0);

                      // Sau khi xóa, danh sách sinh viên sẽ được cập nhật.
                      _loadStudents();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Khi người dùng nhấn vào nút "Thêm", họ sẽ được chuyển đến trang CreateStudentPage để thêm mới sinh viên.
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateStudentPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
