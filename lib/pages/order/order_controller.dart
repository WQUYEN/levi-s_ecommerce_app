import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:levis_store/models/cart.dart';
import 'package:levis_store/models/order.dart';
import 'package:levis_store/routes/routes_name.dart';
import 'package:levis_store/services/user_info_service.dart';

import '../../models/address.dart';
import '../../models/create_order_response.dart';
import '../../repo/payment.dart';
import '../cart/cart_controller.dart';

class OrderController extends GetxController {
  var selectedAddress = Rx<Address?>(null);
  var isLoading = false.obs;
  var orders = <OrderModel>[].obs;
  final CartController cartController = Get.put(CartController());
  final userId = UserInfoService().getUid();
  var currentTab = 0.obs;
  final List<String> statuses = ["pending", "completed", "canceled"];
  var isMoreMap = <String, bool>{}.obs;
  var selectedPaymentMethod = 0.obs;
  static const MethodChannel platform =
      MethodChannel('flutter.native/channelPayOrder');
  var zpTransToken = ''.obs;
  var payResult = ''.obs;
  var payAmount = '10000'.obs;
  var showResult = false.obs;
  var itemId = ''.obs;

  @override
  void onReady() {
    super.onReady();
    getDefaultAddress();
  }

  @override
  void onInit() {
    super.onInit();
    getDefaultAddress(); // Lấy địa chỉ mặc định khi khởi tạo controller
  }

  void onTapBuyBack(String productId) {
    Get.toNamed(RoutesName.productDetailPage,
        arguments: {'productID': productId});
  }

  void onTapReview(String productId, String orderId) {
    Get.toNamed(RoutesName.addReviewPage, arguments: {
      'productId': productId,
      'orderId': orderId,
    });
  }

  Future<String> createOrder1(double totalPrice) async {
    if (totalPrice <= 0) {
      Get.snackbar(
        "Levi's Store",
        "Số tiền không hợp lệ",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return "";
    }

    try {
      // Gọi hàm createOrder
      CreateOrderResponse? response = await createOrder(totalPrice.toInt());

      // Kiểm tra phản hồi
      if (response == null || response.zptranstoken.isEmpty) {
        // Get.snackbar(
        //   "Levi's Store",
        //   "Tạo đơn hàng thất bại",
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        // );
        print("Tạo đơn hàng thành công ");

        return "";
      }
      print("Tạo đơn hàng thành công ");
      // Get.snackbar(
      //   "Levi's Store",
      //   "Tạo đơn hàng thành công",
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      // );

      return response.zptranstoken; // Trả về token giao dịch
    } catch (e) {
      // Xử lý lỗi khi gọi API
      Get.snackbar(
        "Levi's Store",
        "Lỗi khi tạo đơn hàng: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Lỗi khi tạo đơn hàng: $e");
      return "";
    }
  }

  Future<void> payOrder(String zpToken, List<Cart> selectedItems,
      double totalPrice, bool isPayment) async {
    try {
      final dynamic result =
          await platform.invokeMethod('payOrder', {"zptoken": zpToken});
      String response = result.toString();
      print("Payment Result: $response");
      if (result == 1) {
        onTapOrder(selectedItems, totalPrice, isPayment);
      } else if (result == 4) {
        Get.snackbar("Levi's Store", "Failed to place order");
      } else {
        Get.snackbar("Levi's Store", "Failed to payment. Please try again.");
      }
    } on PlatformException catch (e) {
      Get.snackbar("Levi's Store", "Payment Failed: ${e.message}",
          backgroundColor: Colors.red, colorText: Colors.white);
      print("Payment Failed: ${e.message}");
    }
  }

  void selectPaymentMethod({int? paymentMethod}) {
    selectedPaymentMethod.value = paymentMethod!;
  }

  void isMore(OrderModel model) {
    model.isMore = !model.isMore;
    orders.refresh();
  }

  void toggleIsMore(String orderItemId) {
    bool? currentIsMore = isMoreMap[orderItemId] ?? false;
    isMoreMap[orderItemId] = !currentIsMore;
    print(
        "$orderItemId update isMore: $currentIsMore -> ${isMoreMap[orderItemId]}");
    orders.refresh();
  }

  @override
  void onClose() {
    super.onClose();
    cartController;
  }

  void fetchOrdersByCurrentTab() {
    fetchOrdersByStatus(statuses[currentTab.value]);
  }

  Future<void> fetchOrdersByStatus(String status) async {
    try {
      isLoading.value = true;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('status', isEqualTo: status)
          .where('userId', isEqualTo: userId)
          .get();

      Map<String, bool> newIsMoreMap = {};
      List<OrderModel> newOrders = querySnapshot.docs.map((doc) {
        OrderModel order = OrderModel.fromFirestore(doc);
        newIsMoreMap[order.id] = false;
        return order;
      }).toList();

      orders.value = newOrders;
      isMoreMap.value = newIsMoreMap;
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getDefaultAddress() async {
    try {
      final defaultQuerySnapshot = await FirebaseFirestore.instance
          .collection('address')
          .where('userId', isEqualTo: userId)
          .where('isDefault', isEqualTo: true)
          .limit(1)
          .get();

      if (defaultQuerySnapshot.docs.isNotEmpty) {
        selectedAddress.value =
            Address.fromFirestore(defaultQuerySnapshot.docs.first);
        return;
      }

      final firstQuerySnapshot = await FirebaseFirestore.instance
          .collection('address')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (firstQuerySnapshot.docs.isNotEmpty) {
        selectedAddress.value =
            Address.fromFirestore(firstQuerySnapshot.docs.first);
        return;
      }

      selectedAddress.value = null;
    } catch (e) {
      print("Error fetching address: $e");
      selectedAddress.value = null;
    }
  }

  void onTapOrder(
      List<Cart> selectedItems, double totalPrice, bool isPayment) async {
    try {
      // Bắt đầu xử lý
      isLoading.value = true;

      if (selectedItems.isEmpty) {
        Get.snackbar("Levi's Store", "No items selected for order.");
        return;
      }

      // Tạo document mới trong collection 'orders'
      await FirebaseFirestore.instance.collection('orders').add({
        'items': selectedItems.map((item) => item.toMap()).toList(),
        'totalPrice': totalPrice,
        'orderDate': Timestamp.now(),
        'status': 'pending',
        'userId': selectedItems.first.userId,
        'isPayment': isPayment,
        'isRating': false,
      });
      for (var item in selectedItems) {
        await FirebaseFirestore.instance
            .collection('carts')
            .doc(item.id)
            .delete();
      }
      await updateProductStock(selectedItems);
      print(" placing order: ");

      Get.back();
      Get.offNamed(RoutesName.successPage);
      Get.snackbar("Levi's Store", "Order placed successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);
      cartController.decreaseCartLength(selectedItems.length);
    } catch (e) {
      print("Error placing order: $e");
      Get.snackbar("Levi's Store", "Failed to place order. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> updateProductStock(List<Cart> selectedItems) async {
  //   try {
  //     for (var item in selectedItems) {
  //       // Truy vấn màu sắc theo trường 'name'
  //       var colorQuerySnapshot = await FirebaseFirestore.instance
  //           .collection('colors')
  //           .where('name', isEqualTo: item.selectedColor)
  //           .get();
  //
  //       if (colorQuerySnapshot.docs.isNotEmpty) {
  //         var colorDoc = colorQuerySnapshot.docs.first;
  //
  //         // Truy vấn size theo trường 'size' trong collection con 'size'
  //         var sizeQuerySnapshot = await FirebaseFirestore.instance
  //             .collection('colors')
  //             .doc(colorDoc.id) // ID của tài liệu màu sắc
  //             .collection('size')
  //             .where('size', isEqualTo: item.selectedSize)
  //             .get();
  //
  //         if (sizeQuerySnapshot.docs.isNotEmpty) {
  //           var sizeDoc = sizeQuerySnapshot.docs.first;
  //           var sizeData = sizeDoc.data();
  //           int currentQuantity =
  //               sizeData['quantity'] ?? 0; // Số lượng hiện tại
  //           int newQuantity = currentQuantity - item.quantity; // Trừ số lượng
  //
  //           if (newQuantity < 0) {
  //             print("Not enough stock for size: ${item.selectedSize}");
  //             continue;
  //           }
  //
  //           // Cập nhật lại số lượng trong collection 'size'
  //           await sizeDoc.reference.update({
  //             'quantity': newQuantity,
  //           });
  //
  //           print(
  //               "Updated stock for color: ${item.selectedColor}, size: ${item.selectedSize}, new quantity: $newQuantity");
  //         } else {
  //           print(
  //               "Size not found for color: ${item.selectedColor}, size: ${item.selectedSize}");
  //         }
  //       } else {
  //         print("Color not found: ${item.selectedColor}");
  //       }
  //     }
  //
  //     Get.snackbar("Levi's Store", "Stock updated successfully!",
  //         backgroundColor: Colors.green, colorText: Colors.white);
  //   } catch (e) {
  //     print("Error updating stock: $e");
  //     Get.snackbar("Levi's Store", "Failed to update stock. Please try again.",
  //         backgroundColor: Colors.red, colorText: Colors.white);
  //   }
  // }
  Future<void> updateProductStock(List<Cart> selectedItems) async {
    try {
      for (var item in selectedItems) {
        // Truy vấn màu sắc theo ID (giả sử item.colorId chứa ID của tài liệu 'colors')
        var colorDoc = await FirebaseFirestore.instance
            .collection('colors')
            .doc(item.selectedColorId) // Sử dụng ID trực tiếp
            .get();

        if (colorDoc.exists) {
          // Truy vấn size trong collection con 'size' thuộc colorDoc
          var sizeQuerySnapshot = await colorDoc.reference
              .collection('size')
              .where('size', isEqualTo: item.selectedSize)
              .get();

          if (sizeQuerySnapshot.docs.isNotEmpty) {
            var sizeDoc = sizeQuerySnapshot.docs.first;
            var sizeData = sizeDoc.data();
            int currentQuantity =
                sizeData['quantity'] ?? 0; // Số lượng hiện tại
            int newQuantity = currentQuantity - item.quantity; // Trừ số lượng

            if (newQuantity < 0) {
              print("Not enough stock for size: ${item.selectedSize}");
              continue;
            }

            // Cập nhật lại số lượng trong collection 'size'
            await sizeDoc.reference.update({
              'quantity': newQuantity,
            });

            print(
                "Updated stock for color ID: ${item.selectedColorId}, size: ${item.selectedSize}, new quantity: $newQuantity");
          } else {
            print(
                "Size not found for color ID: ${item.selectedColorId}, size: ${item.selectedSize}");
          }
        } else {
          print("Color not found for ID: ${item.selectedColorId}");
        }
      }

      Get.snackbar("Levi's Store", "Stock updated successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      print("Error updating stock: $e");
      Get.snackbar("Levi's Store", "Failed to update stock. Please try again.",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
