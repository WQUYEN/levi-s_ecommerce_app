import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:levis_store/pages/favorite/favorite_controller.dart';

import '../../widgets/curated_items.dart';
import '../review/review_controller.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final FavoriteController controller = Get.put(FavoriteController());
  final ReviewController reviewController = Get.put(
      tag: DateTime.now().millisecondsSinceEpoch.toString(),
      ReviewController());

  @override
  void dispose() {
    // TODO: implement dispose
    reviewController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    controller.fetchProductFavoriteByUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: SizedBox(
        height: size.height,
        child: Obx(() {
          if (controller.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Số cột mỗi hàng
              mainAxisSpacing: 0, // Khoảng cách giữa các hàng
              crossAxisSpacing: 16.0, // Khoảng cách giữa các cột
              childAspectRatio: 0.5, // Tỷ lệ chiều rộng / chiều cao của item
            ),
            itemCount: controller.products.length,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemBuilder: (context, index) {
              final product = controller.products[index];
              final averageRating =
                  reviewController.calculateAverageRatingForProduct(product.id);
              return InkWell(
                onTap: () {
                  // Xử lý khi nhấn vào sản phẩm
                  controller.onTapProduct(product);
                },
                child: CuratedItems(
                  product: product,
                  size: size,
                  averageRating: averageRating,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
