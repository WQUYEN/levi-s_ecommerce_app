import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:levis_store/services/cart_service.dart';

import '../../models/category.dart';
import '../../models/product.dart';
import '../../routes/routes_name.dart';
import '../cart/cart_controller.dart';

class HomeController extends GetxController {
  final categories = <Category>[].obs;
  final products = <Product>[].obs;
  final CartController cartController = Get.put(CartController());

  Future<void> onRefresh(String userId) async {
    try {
      await fetchCategories();
      await fetchProducts();
      await cartController
          .fetchCartByUserId(userId); // Lấy lại giỏ hàng của người dùng
      cartController.cartList.refresh();
    } catch (error) {
      print("Error during refresh: $error");
    }
  }

  void saveCartLength(int cartLength) {
    CartService().updateCart(cartLength);
  }

  Future<void> fetchCategories() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      final fetchedCategories =
          querySnapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();

      // Cập nhật danh sách categories
      categories.assignAll(fetchedCategories);
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  Future<void> fetchProducts() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      final fetchedProducts =
          querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
      products.assignAll(fetchedProducts);
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void onTapProduct(Product product) {
    Get.toNamed(RoutesName.productDetailPage, arguments: {
      'productID': product.id,
    });
  }

  void onTapCartIcon() {
    Get.toNamed(RoutesName.cartPage);
  }

  void onTapCategory() {
    Get.toNamed(RoutesName.cartPage);
  }
}
