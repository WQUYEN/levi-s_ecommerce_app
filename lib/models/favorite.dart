import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  final String id;
  final String productId;
  final String userId;

  Favorite({required this.id, required this.productId, required this.userId});

  // Chuyển đổi từ Firestore document thành Favorite object
  factory Favorite.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Favorite(
      id: doc.id,
      productId: data['productId'],
      userId: data['userId'],
    );
  }

  // Chuyển đổi từ Favorite object thành Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'userId': userId,
    };
  }
}
