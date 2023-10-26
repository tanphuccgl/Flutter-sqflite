// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'dart:async';
import 'package:flutterdb/a.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter/material.dart';

var db;

class Student {
  final int? id;
  final String name;
  final String address;
  final String phone;

  Student({
    this.id,
    required this.name,
    required this.address,
    required this.phone,
  });
  Map<String, dynamic> mapStudent() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
    };
  }
}

Future<void> insertStudent(Student student) async {
  final curDB = await db;

  await curDB.insert(
    'Student',
    student.mapStudent(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Student>> getStudents() async {
  final curDB = await db;

  final List<Map<String, dynamic>> studentMaps = await curDB.query('Student');

  return List.generate(studentMaps.length, (i) {
    return Student(
      id: studentMaps[i]['id'],
      name: studentMaps[i]['name'],
      address: studentMaps[i]['address'],
      phone: studentMaps[i]['phone'],
    );
  });
}

Future<void> updateStudent(Student student) async {
  final curDB = await db;

  await curDB.update(
    'Student',
    student.mapStudent(),
    where: 'id = ?',
    whereArgs: [student.id],
  );
}

Future<void> deleteStudent(int email) async {
  final curDB = await db;

  await curDB.delete(
    'Student',
    where: 'id = ?',
    whereArgs: [email],
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  db = openDatabase(
    join(await getDatabasesPath(), 'studentDB.1'),
    onCreate: (db, ver) {
      return db.execute(
        'CREATE TABLE Student(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,address TEXT,phone TEXT)',
      );
    },
    version: 1,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StudentList(),
    );
  }
}

class StudentList extends StatefulWidget {
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  List<Student> _students = [];

  @override
  void initState() {
    super.initState();

    _loadStudents();
  }

  _loadStudents() async {
    List<Student> students = await getStudents();

    setState(() {
      _students = students;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Danh sách sinh viên'),
      ),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_students[index].name),
            subtitle: Text('Email: ${_students[index].address}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            EditStudent(student: _students[index]),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    deleteStudent(_students[index].id ?? 0);

                    _loadStudents();
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddStudent(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddStudent extends StatefulWidget {
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
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
              decoration: const InputDecoration(labelText: 'Tên'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Địa chỉ'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                insertStudent(
                  Student(
                    name: _nameController.text,
                    address: _ageController.text,
                    phone: _phoneController.text,
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
              child: const Text('Thêm'),
            ),
          ],
        ),
      ),
    );
  }
}
