import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/user_info_service.dart';
import '../../utils/validator.dart';
import '../../widgets/cart_item.dart';
import 'cart_controller.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController controller = Get.put(
      tag: DateTime.now().millisecondsSinceEpoch.toString(), CartController());
  final UserInfoService userInfoService = UserInfoService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String? userId = userInfoService.getUid();
    controller.fetchCartByUserId(userId!);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (controller.cartList.isEmpty) {
          return const Center(child: Text("No items in the cart"));
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(controller.errorMessage.value),
          );
        }
        return ListView.builder(
          itemCount: controller.cartList.length,
          physics: const BouncingScrollPhysics()
              .applyTo(const AlwaysScrollableScrollPhysics()),
          itemBuilder: (context, index) {
            final item = controller.cartList[index];
            return CartItem(
              onTap: () {
                controller.onTapCartItem(productId: item.productId);
              },
              onTapCheckBox: () {
                controller.toggleIsChecked(item.id);
              },
              onTapIncrement: () {
                controller.onTapIncrement(
                  cartItemId: item.id,
                  currentQuantity: item.quantity,
                );
              },
              onTapDecrease: () {
                controller.onTapDecrease(
                  cartItemId: item.id,
                  currentQuantity: item.quantity,
                );
              },
              isChecked: controller.isCheckedMap[item.id] ?? false,
              // Lấy giá trị từ map
              isCartPage: true,
              cart: item,
            );
          },
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Obx(() => buildFloatingActionButton(context, size)),
    );
  }

  FloatingActionButton buildFloatingActionButton(
      BuildContext context, Size size) {
    return FloatingActionButton.extended(
      backgroundColor: Theme.of(context).colorScheme.surface,
      onPressed:
          () {}, // Sự kiện cho FloatingActionButton chính, có thể để trống
      label: SizedBox(
        width: size.width,
        child: Row(
          children: [
            buildCheckedAll(context, size),
            buildTotalPrice(context, size),
            buildBuyBtn(context, size),
          ],
        ),
      ),
    );
  }

  buildCheckedAll(BuildContext context, Size size) {
    return Expanded(
      flex: 2,
      child: Container(
        height: size.height / 12,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // Căn giữa các phần tử trong Row
          children: [
            GestureDetector(
              onTap: controller.toggleIsCheckedAll,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: controller.isCheckedAll.value
                      ? Colors.red
                      : Colors.transparent,
                  border: Border.all(
                    color: controller.isCheckedAll.value
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: controller.isCheckedAll.value
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "All",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  letterSpacing: -1,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  buildTotalPrice(BuildContext context, Size size) {
    return Expanded(
      flex: 4,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: size.height / 12,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
            ),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hiển thị icon nếu có
              // Văn bản tiêu đề
              Text(
                'Tổng thanh toán',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  letterSpacing: -1,
                  fontSize: 14,
                ),
              ),
              Text(
                Validator.formatCurrency(controller.totalPrice),
                style: const TextStyle(
                    color: Colors.red, letterSpacing: -1, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildBuyBtn(BuildContext context, Size size) {
    return Expanded(
      flex: 2,
      child: GestureDetector(
        onTap: () {
          controller.onTapBuyBtn(
            selectedItems: controller.selectedItems,
            totalPrice: controller.totalPrice,
          );
        },
        child: Container(
          height: size.height / 12,
          // width: size.width / 4,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red,
            ),
            color: Colors.red,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Mua hàng',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.surface, fontSize: 14),
              ),
              Text(
                '(${controller.selectedItems.length})',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.surface, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
