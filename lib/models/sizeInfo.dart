class SizeInfo {
  final String id;
  final String size; // Kích cỡ
  final int quantity; // Số lượng

  SizeInfo({
    required this.id,
    required this.size,
    required this.quantity,
  });

  // Factory để tạo một instance của SizeInfo từ Map
  factory SizeInfo.fromMap(Map<String, dynamic> map) {
    return SizeInfo(
      id: map['id'] ?? '',
      size: map['size'] ?? '', // Giá trị kích cỡ
      quantity: map['quantity'] ?? 0, // Số lượng, mặc định là 0 nếu null
    );
  }

  // Phương thức toMap để chuyển SizeInfo thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'size': size,
      'quantity': quantity,
    };
  }
}
