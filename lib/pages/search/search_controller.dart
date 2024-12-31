import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../models/product.dart';
import '../../routes/routes_name.dart';

class SearchControllerGet extends GetxController {
  final products = <Product>[].obs; // Toàn bộ danh sách sản phẩm
  final filteredProducts = <Product>[].obs; // Danh sách sản phẩm được lọc

  void onSearchTextChanged(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products.where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase())),
      );
      filteredProducts.refresh();
      print("Product list: ${products.length}");
      print("Filter list: ${filteredProducts.length}");
    }
  }

  Future<void> fetchProducts() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();

      print("Fetched ${querySnapshot.docs.length} documents from Firestore.");

      final fetchedProducts = querySnapshot.docs.map((doc) {
        print("Document data: ${doc.data()}");
        return Product.fromFirestore(doc);
      }).toList();

      products.assignAll(fetchedProducts);
      filteredProducts.assignAll(fetchedProducts); // Cập nhật danh sách lọc

      print("Products list populated with ${products.length} items.");
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void onTapProduct(Product product) {
    Get.toNamed(RoutesName.productDetailPage, arguments: {
      'productID': product.id,
    });
  }

  @override
  void onInit() async {
    super.onInit();
    await fetchProducts(); // Tải dữ liệu sản phẩm khi khởi tạo
  }
}
