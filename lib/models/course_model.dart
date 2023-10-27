class CourseModel {
  int? id; // ID của khóa học, có thể là null
  String name; // Tên của khóa học
  double score; // Điểm của khóa học
  int studentId; // ID của sinh viên mà khóa học liên quan đến

  CourseModel({
    this.id, // ID, có thể là null
    required this.name, // Tên là thông tin bắt buộc
    required this.score, // Điểm là thông tin bắt buộc
    required this.studentId, // ID sinh viên liên quan là thông tin bắt buộc
  });

  // Hàm chuyển đổi dữ liệu khóa học thành một Map dùng cho lưu trữ cơ sở dữ liệu.
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Thêm ID vào Map nếu nó không phải là null
      'name': name, // Thêm tên
      'score': score, // Thêm điểm
      'student_id': studentId, // Thêm ID sinh viên liên quan
    };
  }
}
