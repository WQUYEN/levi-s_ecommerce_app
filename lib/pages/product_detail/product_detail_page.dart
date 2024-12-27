import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:levis_store/models/product.dart';
import 'package:levis_store/pages/product_detail/product_detail_controller.dart';
import 'package:levis_store/routes/routes_name.dart';
import 'package:levis_store/widgets/common_widget.dart';

import '../../services/user_info_service.dart';
import '../cart/cart_controller.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ProductDetailController controller = Get.put(
      tag: DateTime.now().millisecondsSinceEpoch.toString(),
      ProductDetailController());
  final CartController cartController = Get.put(
      tag: DateTime.now().millisecondsSinceEpoch.toString(), CartController());
  var productId = "";
  var currentIndex = 0;
  var selectedColorIndex = 1;
  var selectedSizeIndex = 1;

  String formatCurrency(double price) {
    if (price <= 0) {
      return "Giá không hợp lệ";
    }
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return formatter.format(price);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    cartController.dispose();
  }

  @override
  void initState() {
    super.initState();
    productId = Get.arguments['productID'] ?? '';
    controller.fetchProductWithDetails(productId);
    final userId = UserInfoService().getUid();
    cartController.fetchCartByUserId(userId!);
    cartController.fetchCartLength();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        centerTitle: true,
        title: const Text("Product Detail"),
        actions: [
          Obx(() {
            if (cartController.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            } else if (cartController.hasError.value) {
              return IconButton(
                onPressed: () {
                  // Retry logic khi nhấn vào icon lỗi
                  cartController.fetchCartLength();
                },
                icon: const Icon(Icons.error, color: Colors.red),
              );
            } else {
              return buildShoppingCart(cartController.cartLength.value);
            }
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        final product = controller.product.value;
        final imageUrls = controller.imageUrls.value;
        if (product == null || imageUrls.isEmpty) {
          return const Center(
              child: Text("Product not found or no images available."));
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: ListView(
            children: [
              buildListImageProduct(size, imageUrls),
              buildContent(context, product, size),
            ],
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: buildFloatingActionButton(context, size),
    );
  }

  FloatingActionButton buildFloatingActionButton(
      BuildContext context, Size size) {
    return FloatingActionButton.extended(
      backgroundColor: Theme.of(context).colorScheme.surface,
      onPressed:
          () {}, // Sự kiện cho FloatingActionButton chính, có thể để trống
      label: SizedBox(
        width: size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            children: [
              // Nút "ADD TO CART"
              buildAddCartBtn(context),

              const SizedBox(width: 10),

              // Nút "BUY NOW"
              buildBuyNowBtn(context),
            ],
          ),
        ),
      ),
    );
  }

  buildBuyNowBtn(BuildContext context) {
    return Expanded(
      child: CommonWidget.button(
        onTap: () {
          if (controller.selectedColorIndex.value == -1 ||
              controller.selectedSizeIndex.value == -1) {
            Get.snackbar(
              "Levi's Store",
              "Please select a color and size before buy.",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            );
          } else {
            final selectedColor = controller.product.value!
                .detailedColors![controller.selectedColorIndex.value];
            final selectedSize = controller
                .availableSizes.value[controller.selectedSizeIndex.value];
            final selectedQuantity = controller.quantity.value;
            final product = controller.product.value;
            controller.onClickBuyNow(
                product: product!,
                selectedColor: selectedColor.name,
                selectedSize: selectedSize.size,
                selectedQuantity: selectedQuantity);
            print("ADD TO CART clicked");
          }
        },
        backGroundBtn: Colors.black,
        title: 'BUY NOW',
      ),
    );
  }

  buildAddCartBtn(BuildContext context) {
    return Expanded(
      child: CommonWidget.button(
          onTap: () {
            if (controller.selectedColorIndex.value == -1 ||
                controller.selectedSizeIndex.value == -1) {
              // Hiển thị snackbar yêu cầu người dùng chọn màu và size
              Get.snackbar(
                "Levi's Store",
                "Please select a color and size before adding to cart.",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
              );
            } else {
              // Thực hiện hành động thêm vào giỏ hàng nếu đã chọn màu và size
              print("ADD TO CART clicked");
              final selectedColor = controller.product.value!
                  .detailedColors![controller.selectedColorIndex.value];
              final selectedSize = controller
                  .availableSizes.value[controller.selectedSizeIndex.value];
              final selectedQuantity = controller.quantity.value;
              final product = controller.product.value;

              controller.onClickAddToCart(
                  product: product!,
                  selectedColor: selectedColor.name,
                  selectedSize: selectedSize.size,
                  selectedQuantity: selectedQuantity);
              print(
                  "product: $product,selectedColor: $selectedColor,selectedSize: $selectedSize,selectedQuantity: $selectedQuantity");
              // Thực hiện hành động thêm vào giỏ hàng tại đây
            }
          },
          title: 'ADD TO CARD',
          colorTitle: Theme.of(context).colorScheme.inversePrimary,
          borderBtn: Theme.of(context).colorScheme.inversePrimary,
          icon: Iconsax.shopping_cart,
          backGroundBtn: Theme.of(context).colorScheme.surface),
    );
  }

  Padding buildShoppingCart(int cartLength) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(RoutesName.cartPage);
            },
            child: const Icon(
              Iconsax.shopping_cart,
              size: 34,
            ),
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
                child: Text(
                  "$cartLength",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildContent(BuildContext context, Product product, Size size) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildRatingBar(context),
          const SizedBox(height: 10),
          buildProductName(product),
          const SizedBox(height: 10),
          buildProductPrice(product, context),
          const SizedBox(
            height: 15,
          ),
          buildProductDescription(product, context),
          const SizedBox(
            height: 20,
          ),
          buildCategories(size, context)
        ],
      ),
    );
  }

  buildCategories(Size size, BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phần Color
        buildSelectColor(size, context),

        // Phần Size
        buildSelectSize(size, context),
      ],
    );
  }

  SizedBox buildSelectSize(Size size, BuildContext context) {
    return SizedBox(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Size",
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.availableSizes.value.isEmpty) {
              return Text(
                "No sizes available",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: controller.availableSizes.value.map((sizeInfo) {
                    final isSelected =
                        controller.availableSizes.value.indexOf(sizeInfo) ==
                            controller.selectedSizeIndex.value;

                    return InkWell(
                      onTap: () {
                        controller.selectedSizeIndex.value =
                            controller.availableSizes.value.indexOf(sizeInfo);
                        controller.updateMaxQuantity();
                        print("quantity: ${controller.maxQuantity}");
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surface,
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.primary,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          sizeInfo.size,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.decreaseQuantity();
                      },
                      icon: Icon(
                        Icons.remove,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Gọi hàm từ controller để hiển thị dialog
                        controller.showQuantityDialog(
                          context,
                        );
                      },
                      child: Obx(
                        () => Text(
                          "${controller.quantity.value}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // if (controller.quantity.value <
                        //     controller.maxQuantity) {
                        //   controller.quantity.value++;
                        // }
                        controller.increaseQuantity();
                      },
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  SizedBox buildSelectColor(Size size, BuildContext context) {
    return SizedBox(
      width: size.width / 2.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Color",
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            // Kiểm tra nếu không có màu
            if (controller.product.value?.detailedColors?.isEmpty ?? true) {
              return Text(
                "No colors available",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.product.value!.detailedColors!
                    .asMap()
                    .entries
                    .map((entry) {
                  final index = entry.key;
                  final color = entry.value;
                  final isSelected =
                      controller.selectedColorIndex.value == index;

                  return InkWell(
                    onTap: () {
                      controller.selectedColorIndex.value = index;
                      controller.updateAvailableSizes(color);
                      Get.snackbar(
                          "Levi's Store", "Selected color: ${color.name}");
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: controller.parseHexColor(color.hex),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Text buildProductDescription(Product product, BuildContext context) {
    return Text(
      "${product.name} is ${product.description}",
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.inversePrimary,
        letterSpacing: -.5,
      ),
    );
  }

  Row buildProductPrice(Product product, BuildContext context) {
    return Row(
      children: [
        Text(
          formatCurrency(product.price),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.red,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          formatCurrency(product.price + 600000),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            decoration: TextDecoration.lineThrough,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Text buildProductName(Product product) {
    return Text(
      product.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        height: 1.5,
      ),
    );
  }

  Row buildRatingBar(BuildContext context) {
    return Row(
      children: [
        Text(
          "LEVI'S",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 10),
        ),
        const SizedBox(width: 5),
        const Icon(
          Icons.star,
          color: Colors.amber,
          size: 15,
        ),
        Text(
          "5.0",
          style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 10),
        ),
        const Spacer(),
        const Icon(Icons.favorite_border)
      ],
    );
  }

  SizedBox buildListImageProduct(Size size, List<String> imageUrls) {
    return SizedBox(
      height: size.height * 0.46,
      width: size.width,
      child: Column(
        children: [
          // PageView
          Expanded(
            child: PageView.builder(
              onPageChanged: (value) {
                controller.updateCurrentIndex(value);
              },
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.network(
                      imageUrls[index],
                      height: size.height * 0.41,
                      width: size.width * 0.72,
                      fit: BoxFit.cover,
                    ),
                  ],
                );
              },
            ),
          ),

          // Indicator Row
          const SizedBox(height: 10),
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                imageUrls.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: 4),
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: index == controller.currentIndex.value
                        ? Colors.blue
                        : Colors.grey.shade400,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
