import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  final String id;
  final String productId;
  final String productName;
  final double productPrice;
  final String productPrimaryImage;
  int quantity;
  final String selectedColor;
  final String selectedSize;
  final String userId;
  bool isChecked;
  final DateTime createdAt;

  Cart({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productPrimaryImage,
    required this.quantity,
    required this.selectedColor,
    required this.selectedSize,
    required this.userId,
    required this.isChecked,
    required this.createdAt,
  });

  // Factory constructor để chuyển đổi từ Map (dữ liệu Firebase) sang model
  factory Cart.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Cart(
      id: doc.id,
      productId: data['productId'] ?? "",
      productName: data['productName'] ?? "",
      productPrice: data['productPrice'] ?? 0,
      productPrimaryImage: data['productPrimaryImage'] ?? "",
      quantity: data['quantity'] ?? 0,
      selectedColor: data['selectedColor'] ?? "",
      selectedSize: data['selectedSize'] ?? "",
      userId: data['userId'] ?? "",
      isChecked: data['isChecked'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Phương thức để chuyển đổi từ model sang Map (dùng để lưu vào Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'productPrimaryImage': productPrimaryImage,
      'quantity': quantity,
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
      'userId': userId,
      'isChecked': isChecked,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
