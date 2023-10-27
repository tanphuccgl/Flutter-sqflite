import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:async';
import 'package:flutterdb/models/course_model.dart';
import 'package:flutterdb/models/student_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseLocal {
  static late Database db; // Đối tượng cơ sở dữ liệu
  static const _name = 'FlutterDB'; // Tên cơ sở dữ liệu
  static const _executeStudent =
      'CREATE TABLE Student(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,address TEXT,phone INTEGER)'; // Câu lệnh SQL tạo bảng Student
  static const _executeCourse =
      'CREATE TABLE Course (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,score REAL,student_id INTEGER,FOREIGN KEY (student_id) REFERENCES Student(id))'; // Câu lệnh SQL tạo bảng Course

  static Future<void> init() async {
    db = await openDatabase(
      join(await getDatabasesPath(), _name), // Tạo hoặc mở cơ sở dữ liệu
      onCreate: (db, ver) {
        db.execute(_executeStudent); // Tạo bảng Student
        db.execute(_executeCourse); // Tạo bảng Course
      },
      version: 1,
    );
    return;
  }

  static Future<int> insertCourse(CourseModel course) async {
    return await db.insert(
      'Course', // Tên bảng
      course.toMap(), // Dữ liệu được chèn
      conflictAlgorithm: ConflictAlgorithm.replace, // Xử lý xung đột
    );
  }

  static Future<void> insertStudent(StudentModel student) async {
    await db.insert(
      'Student', // Tên bảng
      student.mapStudent(), // Dữ liệu sinh viên được chèn
      conflictAlgorithm: ConflictAlgorithm.replace, // Xử lý xung đột
    );
  }

  static Future<List<CourseModel>> getCoursesByStudent(int studentId) async {
    // Lấy danh sách các môn học của học sinh có ID tương ứng từ bảng Course
    final List<Map<String, dynamic>> maps = await db
        .query('Course', where: 'student_id = ?', whereArgs: [studentId]);

    // Tạo danh sách các đối tượng CourseModel từ dữ liệu thu thập được
    return List.generate(maps.length, (i) {
      return CourseModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        score: maps[i]['score'],
        studentId: maps[i]['student_id'],
      );
    });
  }

  static Future<List<StudentModel>> getStudents() async {
    // Lấy danh sách tất cả học sinh từ bảng Student
    final List<Map<String, dynamic>> studentMaps = await db.query('Student');

    // Tạo danh sách các đối tượng StudentModel từ dữ liệu thu thập được
    return List.generate(studentMaps.length, (i) {
      return StudentModel(
        id: studentMaps[i]['id'],
        name: studentMaps[i]['name'],
        address: studentMaps[i]['address'],
        phone: studentMaps[i]['phone'],
      );
    });
  }

  static Future<int> updateCourse(CourseModel course) async {
    // Cập nhật thông tin của một khóa học trong bảng Course dựa trên id
    return await db.update(
      'Course', // Tên bảng
      course.toMap(), // Dữ liệu mới của khóa học
      where: 'id = ?', // Điều kiện cập nhật - id bằng giá trị được truyền vào
      whereArgs: [
        course.id
      ], // Giá trị được truyền vào điền vào dấu chấm hỏi trong điều kiện where
    );
  }

  static Future<void> updateStudent(StudentModel student) async {
    // Cập nhật thông tin của một sinh viên trong bảng Student dựa trên id
    await db.update(
      'Student', // Tên bảng
      student.mapStudent(), // Dữ liệu mới của sinh viên
      where: 'id = ?', // Điều kiện cập nhật - id bằng giá trị được truyền vào
      whereArgs: [
        student.id
      ], // Giá trị được truyền vào điền vào dấu chấm hỏi trong điều kiện where
    );
  }

  static Future<int> deleteCourse(int id) async {
    // Xoá một khóa học từ bảng Course dựa trên id
    return await db.delete(
      'Course', // Tên bảng
      where: 'id = ?', // Điều kiện xoá - id bằng giá trị được truyền vào
      whereArgs: [
        id
      ], // Giá trị được truyền vào điền vào dấu chấm hỏi trong điều kiện where
    );
  }

  static Future<void> deleteStudent(int email) async {
    // Xoá một sinh viên từ bảng Student dựa trên id (email)
    await db.delete(
      'Student', // Tên bảng
      where:
          'id = ?', // Điều kiện xoá - id bằng giá trị được truyền vào (email)
      whereArgs: [
        email
      ], // Giá trị được truyền vào điền vào dấu chấm hỏi trong điều kiện where
    );
  }
}
