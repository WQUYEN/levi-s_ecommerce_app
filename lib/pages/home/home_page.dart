import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:levis_store/pages/cart/cart_controller.dart';
import 'package:levis_store/services/user_info_service.dart';
import 'package:levis_store/widgets/banner.dart';
import 'package:levis_store/widgets/curated_items.dart';

import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = Get.put(HomeController());
  final CartController cartController = Get.put(CartController());
  final userId = UserInfoService().getUid();

  @override
  void initState() {
    super.initState();
    controller.fetchCategories();
    controller.fetchProducts();
    _loadCartData();
  }

  Future<void> _loadCartData() async {
    await cartController.fetchCartByUserId(userId!);
    var cartLength = cartController.cartList.length;
    controller.saveCartLength(cartLength);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: () => controller.onRefresh(userId!),
        child: CustomScrollView(
          slivers: [
            /// SliverAppBar for logo and cart icon
            SliverAppBar(
              floating: false,
              // Không cần xuất hiện lại khi cuộn lên
              snap: false,
              pinned: true,
              // Giữ cố định khi cuộn
              backgroundColor: Theme.of(context).colorScheme.surface,
              expandedHeight: size.height / 16,
              // Chiều cao ban đầu của AppBar
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin, // Nội dung sẽ co lại khi cuộn
                background: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/levi's_logo.png",
                        width: 80,
                        height: 40,
                        fit: BoxFit.fill,
                      ),
                      GestureDetector(
                        onTap: controller.onTapCartIcon,
                        child: Stack(
                          children: [
                            const Icon(
                              Iconsax.shopping_cart,
                              size: 34,
                            ),
                            Positioned(
                              right: -2,
                              top: -7,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Obx(
                                    () => Text(
                                      "${cartController.cartList.length}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Banner Section
            const SliverToBoxAdapter(
              child: MyBanner(),
            ),

            /// Category Section
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Shop By Category",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
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
                                  Get.snackbar("Levi's Store", "message");
                                },
                                child: ClipOval(
                                  child: Image.network(
                                    category.imageUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
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
            ),

            /// Curated Products Section
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Curated For You",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 400,
                child: Obx(() {
                  if (controller.products.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.products.length,
                    itemBuilder: (context, index) {
                      final product = controller.products[index];
                      return Padding(
                        padding: index == 0
                            ? const EdgeInsets.symmetric(horizontal: 20)
                            : const EdgeInsets.only(right: 20),
                        child: InkWell(
                          onTap: () {
                            controller.onTapProduct(product);
                          },
                          child: CuratedItems(
                            product: product,
                            size: size,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
