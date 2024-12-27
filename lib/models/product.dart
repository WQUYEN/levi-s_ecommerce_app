import 'package:cloud_firestore/cloud_firestore.dart';

import 'category.dart';
import 'color_model.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final List<String> imageUrls; // imageUrl changed to a list
  final String primaryImage; // Added primaryImage field
  final double price;
  final int? buyCount; // Không cần nullable nếu luôn có giá trị mặc định
  final List<String> categories; // IDs của categories
  final List<String> colors; // IDs của colors
  final Timestamp createdAt; // Added createdAt timestamp

  // Chi tiết đầy đủ (dành cho hiển thị)
  final List<Category>? detailedCategories;
  final List<ColorModel>? detailedColors;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrls,
    required this.primaryImage, // Added primaryImage
    required this.price,
    required this.buyCount,
    required this.categories,
    required this.colors,
    required this.createdAt, // Added createdAt
    this.detailedCategories,
    this.detailedColors,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrls: List<String>.from(
          data['imageUrl'] ?? []), // Changed from imageUrl to imageUrls
      primaryImage: data['primaryImage'] ?? '', // Added primaryImage field
      price: (data['price'] ?? 0).toDouble(),
      buyCount: (data['buyCount'] ?? 0).toInt(),
      categories: List<String>.from(data['categories'] ?? []),
      colors: List<String>.from(data['colors'] ?? []),
      createdAt: data['createdAt'] ?? Timestamp.now(), // Added createdAt field
    );
  }

  Product copyWith({
    List<Category>? detailedCategories,
    List<ColorModel>? detailedColors,
    List<String>? imageUrls, // Added imageUrls to copyWith
    String? primaryImage, // Added primaryImage to copyWith
    int? buyCount, // Allow updating buyCount in copyWith
    List<String>? categories, // Allow updating categories in copyWith
    List<String>? colors, // Allow updating colors in copyWith
  }) {
    return Product(
      id: id,
      name: name,
      description: description,
      imageUrls: imageUrls ??
          this.imageUrls, // Default to existing imageUrls if not provided
      primaryImage:
          primaryImage ?? this.primaryImage, // Default to existing primaryImage
      price: price,
      buyCount: buyCount ??
          this.buyCount, // Default to existing buyCount if not provided
      categories:
          categories ?? this.categories, // Default to existing categories
      colors: colors ?? this.colors, // Default to existing colors
      createdAt: createdAt, // Do not update createdAt in copyWith
      detailedCategories: detailedCategories ?? this.detailedCategories,
      detailedColors: detailedColors ?? this.detailedColors,
    );
  }
}
