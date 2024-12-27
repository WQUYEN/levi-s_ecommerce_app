import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double totalPrice;
  final Timestamp orderDate;
  final String status;
  final Map<String, dynamic>? address; // Địa chỉ duy nhất
  bool isMore = false;
  final bool isPayment;
  final String? zpTransToken; // Token thanh toán ZaloPay

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.orderDate,
    required this.status,
    required this.isPayment,
    this.address,
    this.zpTransToken,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      items: List<Map<String, dynamic>>.from(data['items'] ?? []),
      totalPrice: data['totalPrice']?.toDouble() ?? 0.0,
      orderDate: data['orderDate'] ?? Timestamp.now(),
      status: data['status'] ?? 'pending',
      address: data['address'],
      isPayment: data['isPayment'] ?? false,
      zpTransToken: data['zpTransToken'], // Nếu lưu trên Firestore
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items,
      'totalPrice': totalPrice,
      'orderDate': orderDate,
      'status': status,
      'address': address,
      'isPayment': isPayment,
      'zpTransToken': zpTransToken, // Nếu cần lưu trên Firestore
    };
  }
}
