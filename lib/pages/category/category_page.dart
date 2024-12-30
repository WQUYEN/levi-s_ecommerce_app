import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:levis_store/pages/category/category_controller.dart';

import '../../widgets/curated_items.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  var categoryId = "";
  final CategoryController controller = Get.put(CategoryController());

  @override
  void initState() {
    // TODO: implement initState
    categoryId = Get.arguments['categoryId'] ?? "";
    print(categoryId);
    controller.fetchProductByCategoryId(categoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Category $categoryId"),
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
              return InkWell(
                onTap: () {
                  // Xử lý khi nhấn vào sản phẩm
                  controller.onTapProduct(product);
                },
                child: CuratedItems(
                  product: product,
                  size: size,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
