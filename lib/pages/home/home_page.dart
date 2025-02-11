import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:levis_store/pages/cart/cart_controller.dart';
import 'package:levis_store/services/user_info_service.dart';
import 'package:levis_store/widgets/banner.dart';
import 'package:levis_store/widgets/curated_items.dart';

import 'home_controller.dart';

class HomePage extends StatefulWidget {
  // final NotchBottomBarController? controller;

  // const HomePage({super.key, this.controller});
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

    // Fetch categories and products asynchronously
    controller.fetchCategories();
    controller.fetchProducts();

    // Fetch cart by userId and then get the cart length
    _loadCartData();
  }

  Future<void> _loadCartData() async {
    await cartController
        .fetchCartByUserId(userId!); // Đảm bảo fetchCartByUserId hoàn tất trước
    var cartLength = cartController
        .cartList.length; // Lấy độ dài giỏ hàng sau khi fetch hoàn tất
    controller.saveCartLength(cartLength); // Lưu độ dài giỏ hàng vào controller
    print(cartLength); // In ra độ dài giỏ hàng
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: RefreshIndicator(
          onRefresh: () => controller.onRefresh(userId!),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),

                  ///Logo and cart icon
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Lottie.network(
                        //   "https://lottie.host/7c413d24-257a-448c-b8a0-ad6912a0df8e/ZsjUqTOUnG.json",
                        //   width: 110,
                        //   height: 60,
                        //   fit: BoxFit.fill,
                        // ),
                        Image.asset(
                          "assets/levi's_logo.png",
                          width: 80,
                          height: 40,
                          fit: BoxFit.fill,
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.onTapCartIcon();
                          },
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
                                  )),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  ///Banner
                  const MyBanner(),

                  /// Section category
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Shop By Category",
                          style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 0,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "See All",
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      ],
                    ),
                  ),
                  // For category
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 120,
                      child: Obx(() {
                        if (controller.categories.isEmpty) {
                          return const Center(
                              child: CircularProgressIndicator());
                          // return Center(
                          //   child: Text("Error"),
                          // );
                        }
                        return InkWell(
                          onTap: () {
                            Get.snackbar("Levi's", "Click item category");
                          },
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.categories.length,
                            itemBuilder: (context, index) {
                              final category = controller.categories[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    ClipOval(
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
                                        loadingBuilder:
                                            (context, child, progress) {
                                          if (progress == null) return child;
                                          return const SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: CircularProgressIndicator(),
                                          );
                                        },
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
                          ),
                        );
                      }),
                    ),
                  ),

                  /// Section curated
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Curated For You",
                          style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 0,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "See All",
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 400,
                    child: Obx(() {
                      if (controller.products.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return InkWell(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.products.length,
                              itemBuilder: (context, index) {
                                final product = controller.products[index];
                                return Padding(
                                  padding: index == 0
                                      ? const EdgeInsets.symmetric(
                                          horizontal: 20)
                                      : const EdgeInsets.only(right: 20),
                                  child: InkWell(
                                    onTap: () {
                                      controller.onTapProduct(product);
                                    },
                                    child: CuratedItems(
                                        product: product, size: size),
                                  ),
                                );
                              }),
                        );
                      }
                    }),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
