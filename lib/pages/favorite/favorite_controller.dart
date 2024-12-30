import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:levis_store/models/favorite.dart';
import 'package:levis_store/models/product.dart';
import 'package:levis_store/services/user_info_service.dart';

import '../../routes/routes_name.dart';

class FavoriteController extends GetxController {
  var products = <Product>[].obs; // Danh sách sản phẩm yêu thích
  var isLoading = false.obs;
  var favorites = <Favorite>[].obs;

  // Lấy danh sách sản phẩm yêu thích dựa trên userId
  Future<void> fetchProductFavoriteByUserId() async {
    try {
      isLoading.value = true;
      var userId = UserInfoService().getUid();
      // Lấy danh sách favorite từ Firestore
      QuerySnapshot favoriteSnapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('userId', isEqualTo: userId)
          .get();

      // Chuyển danh sách favorite từ Firestore
      favorites.value = favoriteSnapshot.docs.map((doc) {
        return Favorite.fromFirestore(doc);
      }).toList();

      // Lấy danh sách sản phẩm dựa trên productId trong favorites
      List<String> productIds =
          favorites.map((favorite) => favorite.productId).toList();

      if (productIds.isNotEmpty) {
        QuerySnapshot productSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .where(FieldPath.documentId, whereIn: productIds)
            .get();

        products.value = productSnapshot.docs.map((doc) {
          return Product.fromFirestore(doc);
        }).toList();
      } else {
        products.value = [];
      }
    } catch (e) {
      print("Error fetching favorite products: $e");
      products.value = [];
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
