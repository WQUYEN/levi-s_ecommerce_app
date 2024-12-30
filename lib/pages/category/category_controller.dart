import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:levis_store/models/category.dart';
import 'package:levis_store/models/product.dart';

import '../../routes/routes_name.dart';

class CategoryController extends GetxController {
  var isLoading = false.obs;
  var categories = <Category>[].obs;
  var products = <Product>[].obs;

  Future<void> fetchProductByCategoryId(String categoryId) async {
    try {
      isLoading.value = true;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('categories', arrayContains: categoryId)
          .get();

      products.value = querySnapshot.docs.map((doc) {
        return Product.fromFirestore(doc);
      }).toList();
      print("list: ${products.length}");
    } catch (e) {
      Get.log("$e");
      print("Failed fetch Products by category id: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void onTapProduct(Product product) {
    Get.toNamed(RoutesName.productDetailPage, arguments: {
      'productID': product.id,
    });
  }
}
