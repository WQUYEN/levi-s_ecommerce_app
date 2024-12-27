import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection('products');

  /// Thêm sản phẩm mới
  Future<void> addProduct({
    required String name,
    required double price,
    required String description,
    required String imageUrl,
  }) async {
    try {
      await productsRef.add({
        'name': name,
        'price': price,
        'description': description,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  /// Lấy danh sách sản phẩm
  Stream<List<Map<String, dynamic>>> getProducts() {
    return productsRef.orderBy('createdAt', descending: true).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  /// Xóa sản phẩm
  Future<void> deleteProduct(String id) async {
    try {
      await productsRef.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
