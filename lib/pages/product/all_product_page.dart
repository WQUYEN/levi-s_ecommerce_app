import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/curated_items.dart';
import '../home/home_controller.dart';
import '../review/review_controller.dart';

class AllProductPage extends StatefulWidget {
  const AllProductPage({super.key});

  @override
  State<AllProductPage> createState() => _AllProductPageState();
}

class _AllProductPageState extends State<AllProductPage> {
  final HomeController controller = Get.put(HomeController());
  final ReviewController reviewController = Get.put(
      tag: DateTime.now().millisecondsSinceEpoch.toString(),
      ReviewController());

  @override
  void dispose() {
    // TODO: implement dispose
    reviewController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
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
