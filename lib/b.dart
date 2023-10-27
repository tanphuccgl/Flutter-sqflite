// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutterdb/edit.dart';

import 'package:flutterdb/main.dart';

class CourseList extends StatefulWidget {
  final Student student;

  const CourseList({super.key, required this.student});

  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  List<Course> _courses = [];
  double averageScore = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  _loadCourses() async {
    List<Course> courses = await getCoursesByStudent(widget.student.id ?? 0);
    double totalScore = 0.0;

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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditCourse(
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
                        deleteCourse(_courses[index].id ?? 0);

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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddCourse(
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

class AddCourse extends StatefulWidget {
  final Student student;
  const AddCourse({
    Key? key,
    required this.student,
  }) : super(key: key);
  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

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
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Điểm'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                insertCourse(
                  Course(
                    name: _nameController.text,
                    score: int.tryParse(_ageController.text) ?? 0,
                    studentId: widget.student.id ?? 0,
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
              child: const Text('Thêm'),
            ),
          ],
        ),
      ),
    );
  }
}
