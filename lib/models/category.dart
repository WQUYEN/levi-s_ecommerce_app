import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String imageUrl;
  final String name;
  final String slug;

  Category({
    required this.imageUrl,
    required this.name,
    required this.slug,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Category(
      imageUrl: data['imageUrl'] ?? '', // Gán giá trị mặc định nếu null
      name: data['name'] ?? 'Unknown', // Gán giá trị mặc định nếu null
      slug: data['slug'] ?? 'unknown', // Gán giá trị mặc định nếu null
    );
  }
}
