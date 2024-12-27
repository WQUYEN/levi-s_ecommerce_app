import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  final String id;
  final String userId;
  final String province;
  final String district;
  final String ward;
  final String other;
  final String phoneNumber;
  final String nameUser;
  bool isDefault;

  Address({
    required this.id,
    required this.userId,
    required this.province,
    required this.district,
    required this.ward,
    required this.other,
    required this.phoneNumber,
    required this.nameUser,
    required this.isDefault,
  });

  factory Address.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Address(
      id: doc.id,
      userId: data['userId'] ?? '',
      province: data['province'] ?? '',
      district: data['district'] ?? '',
      ward: data['ward'] ?? '',
      other: data['other'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      nameUser: data['nameUser'] ?? 'Unknown',
      isDefault: data['isDefault'] ?? false,
    );
  }

  // Chuyển đổi từ Address object thành Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'province': province,
      'district': district,
      'ward': ward,
      'other': other,
      'nameUser': nameUser,
      'isDefault': isDefault,
    };
  }
}
