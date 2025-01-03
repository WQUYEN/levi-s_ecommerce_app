import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String userId;
  final String userName;
  final String avatarUrl;
  final String productId;
  final String orderId;
  final double rating;
  final String content;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.avatarUrl,
    required this.productId,
    required this.orderId,
    required this.rating,
    required this.content,
    required this.createdAt,
  });

  // Chuyển từ Map Firestore -> Review
  factory Review.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Review(
      id: doc.id,
      userId: data['userId'] as String ?? "",
      userName: data['userName'] as String ?? "",
      avatarUrl: data['avatarUrl'] as String ?? "",
      productId: data['productId'] as String ?? "",
      orderId: data['orderId'] as String ?? "",
      content: data['content'] as String ?? "",
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Chuyển từ Review -> Map Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'avatarUrl': avatarUrl,
      'productId': productId,
      'orderId': orderId,
      'content': content,
      'rating': rating,
      'createdAt': createdAt,
    };
  }
}
