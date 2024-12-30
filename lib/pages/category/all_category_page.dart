import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:levis_store/pages/home/home_controller.dart';

class AllCategoryPage extends StatelessWidget {
  AllCategoryPage({super.key});

  final HomeController controller =
      Get.put(tag: DateTime.now().toString(), HomeController());

  @override
  Widget build(BuildContext context) {
    controller.fetchCategories();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: 120,
          child: Obx(() {
            if (controller.categories.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.onTapCategory(category);
                        },
                        child: ClipOval(
                          child: Image.network(
                            category.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.image_not_supported,
                              size: 60,
                              color: Colors.grey,
                            ),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
