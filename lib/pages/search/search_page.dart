import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:levis_store/pages/search/search_controller.dart';
import 'package:levis_store/utils/validator.dart';

class SearchPage extends StatelessWidget {
  final SearchControllerGet controller = Get.put(SearchControllerGet());

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchProducts();
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) => controller.onSearchTextChanged(value),
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Obx(() {
        if (controller.filteredProducts.isEmpty) {
          return const Center(
            child: Text('No products found'),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: controller.filteredProducts.length,
            itemBuilder: (context, index) {
              final product = controller.filteredProducts[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text(
                  Validator.formatCurrency(product.price),
                  maxLines: 2,
                ),
                leading: Image.network(
                  product.primaryImage,
                  width: 50,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  controller.onTapProduct(product);
                },
              );
            },
          ),
        );
      }),
    );
  }
}
