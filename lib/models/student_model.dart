class StudentModel {
  final int? id; // ID của sinh viên, có thể là null
  final String name; // Tên của sinh viên
  final String address; // Địa chỉ của sinh viên
  final int phone; // Số điện thoại của sinh viên

  StudentModel({
    this.id, // ID, có thể là null
    required this.name, // Tên là thông tin bắt buộc
    required this.address, // Địa chỉ là thông tin bắt buộc
    required this.phone, // Số điện thoại là thông tin bắt buộc
  });

  // Hàm chuyển đổi dữ liệu sinh viên thành một Map dùng cho lưu trữ cơ sở dữ liệu.
  Map<String, dynamic> mapStudent() {
    return {
      'id': id, // Thêm ID vào Map nếu nó không phải là null
      'name': name, // Thêm tên
      'address': address, // Thêm địa chỉ
      'phone': phone, // Thêm số điện thoại
    };
  }
}
