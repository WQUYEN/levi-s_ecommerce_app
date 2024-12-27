import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:levis_store/models/sizeInfo.dart';

class ColorModel {
  final String id; // ID của document trong Firestore
  final String name; // Tên của màu sắc
  final String hex; // Mã hex của màu sắc
  final List<SizeInfo> size; // Danh sách size và số lượng tương ứng

  ColorModel({
    required this.id,
    required this.name,
    required this.hex,
    required this.size,
  });

  // Factory để tạo một instance của ColorModel từ Firestore
  factory ColorModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ColorModel(
      id: doc.id,
      name: data['name'] ?? '', // Tên màu, mặc định là chuỗi rỗng nếu null
      hex: data['hex'] ?? '', // Mã hex, mặc định là chuỗi rỗng nếu null
      size: (data['size'] as List<dynamic>? ?? [])
          .map((size) => SizeInfo.fromMap(size as Map<String, dynamic>))
          .toList(), // Chuyển đổi danh sách size từ Firestore
    );
  }

  // Phương thức toMap để chuyển model thành Map (nếu cần upload lên Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'hex': hex,
      'size': size.map((size) => size.toMap()).toList(),
    };
  }
}
