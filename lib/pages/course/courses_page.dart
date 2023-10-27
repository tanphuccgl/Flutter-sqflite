// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutterdb/database/database_local.dart';
import 'package:flutterdb/models/course_model.dart';
import 'package:flutterdb/models/student_model.dart';
import 'package:flutterdb/pages/course/create_course_page.dart';
import 'package:flutterdb/pages/course/edit_course_page.dart';

class CoursesPage extends StatefulWidget {
  final StudentModel student;

  // Constructor cho trang danh sách khóa học, chấp nhận một đối tượng StudentModel.
  const CoursesPage({super.key, required this.student});

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<CourseModel> _courses = [];
  double averageScore = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  _loadCourses() async {
    // Tải danh sách các khóa học của sinh viên từ cơ sở dữ liệu.
    List<CourseModel> courses =
        await DatabaseLocal.getCoursesByStudent(widget.student.id ?? 0);
    double totalScore = 0.0;

    // Tính tổng số điểm của tất cả các khóa học.
    for (var course in courses) {
      totalScore += course.score;
    }

    setState(() {
      _courses = courses;
      averageScore = totalScore / courses.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách khóa học của ${widget.student.name}'),
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: _courses.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_courses[index].name),
                subtitle: Text('Điểm: ${_courses[index].score}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Chuyển đến trang chỉnh sửa khóa học.
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditCoursePage(
                              course: _courses[index],
                              student: widget.student,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Xóa khóa học khỏi cơ sở dữ liệu và cập nhật danh sách.
                        DatabaseLocal.deleteCourse(_courses[index].id ?? 0);

                        _loadCourses();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          if (_courses.isNotEmpty)
            Text('Tổng điểm trung bình: ${averageScore.toStringAsFixed(2)}'),
          if (_courses.isNotEmpty)
            Text('Xếp loại: ${calculateGrade(averageScore)}'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Chuyển đến trang thêm mới khóa học.
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateCoursePage(
                student: widget.student,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String calculateGrade(double averageScore) {
    // Tính toán và trả về xếp loại dựa trên điểm trung bình.
    if (averageScore >= 9.0) {
      return "Xuất sắc";
    } else if (averageScore >= 8.0) {
      return "Giỏi";
    } else if (averageScore >= 6.5) {
      return "Khá";
    } else if (averageScore >= 5.0) {
      return "Trung bình";
    } else {
      return "Yếu";
    }
  }
}
