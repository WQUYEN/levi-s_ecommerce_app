import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:levis_store/models/cart.dart';
import 'package:levis_store/pages/order/order_controller.dart';
import 'package:levis_store/routes/routes_name.dart';
import 'package:levis_store/widgets/common_widget.dart';

import '../../utils/validator.dart';
import '../../widgets/cart_item.dart';

class OrderPage extends StatefulWidget {
  OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final OrderController controller = Get.put(OrderController());
  var totalPrice = 0.0;
  List<Cart> selectedItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalPrice = Get.arguments['totalPrice'] ?? 0;
    selectedItems = Get.arguments['selectedItems'] ?? '';
    controller.getDefaultAddress();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Lắng nghe khi màn hình quay trở lại
  //   if (Get.routing.isBack == true) {
  //     controller.getDefaultAddress();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final floatBtnHeight = size.height / 17;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: const Text("Order"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(
            children: [
              Obx(() {
                final address = controller.selectedAddress.value;
                if (address == null) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(RoutesName.addressPage);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Chưa có địa chỉ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 100),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(RoutesName.addressPage);
                    },
                    child: CommonWidget.addressItem(
                        context: context,
                        address: controller.selectedAddress.value,
                        isAddressList: false),
                  );
                }
              }),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedItems.length,
                  itemBuilder: (context, index) {
                    final item = selectedItems[index];
                    return CartItem(
                      onTap: () {},
                      onTapCheckBox: () {},
                      onTapIncrement: () {},
                      onTapDecrease: () {},
                      isChecked: false,
                      isCartPage: false,
                      cart: item,
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: floatBtnHeight),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: buildPaymentSelected(context, floatBtnHeight),
                ),
              )
            ],
          );
        }
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: buildFloatingActionButton(
          context, size, totalPrice, selectedItems, floatBtnHeight),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context,
      Size size, double totalPrice, List<Cart> selectedItems, floatBtnHeight) {
    return FloatingActionButton.extended(
      backgroundColor: Theme.of(context).colorScheme.surface,
      onPressed:
          () {}, // Sự kiện cho FloatingActionButton chính, có thể để trống
      label: SizedBox(
        width: size.width,
        child: Column(
          children: [
            // buildPaymentSelected(context, size),
            Row(
              children: [
                buildTotalPrice(context, totalPrice, floatBtnHeight),
                buildBuyBtn(context, selectedItems, totalPrice, floatBtnHeight),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildPaymentSelected(BuildContext context, floatBtnHeight) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RoutesName.paymentMethodPage);
      },
      child: Container(
        height: floatBtnHeight,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                if (controller.selectedPaymentMethod.value == 1) {
                  return Row(
                    children: [
                      Text(
                        "Thanh toán qua ví ZaloPay",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Image.asset(
                        "assets/zalopay_logo_2.png",
                        height: 24,
                      ),
                    ],
                  );
                } else if (controller.selectedPaymentMethod.value == 2) {
                  return Row(
                    children: [
                      Text(
                        "Thanh toán Khi nhận hàng",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        "assets/flying-money.png",
                        height: 34,
                      )
                    ],
                  );
                } else {
                  return Text(
                    "Chưa chọn phương thức thanh toán",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
              }),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 16,
              )
            ],
          ),
        ),
      ),
    );
  }

  buildTotalPrice(BuildContext context, double totalPrice, floatBtnHeight) {
    return Expanded(
      flex: 4,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: floatBtnHeight,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
            ),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Hiển thị icon nếu có
              // Văn bản tiêu đề
              Text(
                'Tổng thanh toán',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  letterSpacing: -1,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                Validator.formatCurrency(totalPrice),
                style: const TextStyle(
                    color: Colors.red, letterSpacing: -1, fontSize: 18),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildBuyBtn(BuildContext context, List<Cart> selectedItems, double totalPrice,
      floatBtnHeight) {
    return Expanded(
      flex: 2,
      child: GestureDetector(
        onTap: () async {
          if (controller.selectedAddress.value == null) {
            Get.snackbar("Levi's Store", "Please select address",
                backgroundColor: Colors.red, colorText: Colors.white);
          } else {
            if (controller.selectedPaymentMethod.value == 1) {
              String zpToken = await controller.createOrder1(totalPrice);
              if (zpToken.isNotEmpty) {
                controller.payOrder(zpToken, selectedItems, totalPrice, true);
              } else {
                Get.snackbar("Levi's Store", "Failed to create order",
                    backgroundColor: Colors.red, colorText: Colors.white);
              }
            } else if (controller.selectedPaymentMethod.value == 2) {
              controller.onTapOrder(selectedItems, totalPrice, false);
            } else {
              Get.snackbar("Levi's Store", "Please select payment method",
                  backgroundColor: Colors.red, colorText: Colors.white);
            }
          }
        },
        child: Container(
          height: floatBtnHeight,
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
                'Đặt hàng',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.surface, fontSize: 14),
              ),
              Text(
                '(${selectedItems.length})',
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
