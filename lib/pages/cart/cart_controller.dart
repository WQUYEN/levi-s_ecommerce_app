import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:levis_store/models/cart.dart';
import 'package:levis_store/routes/routes_name.dart';

import '../../services/cart_service.dart';

class CartController extends GetxController {
  var quantity = 0.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var cartList = <Cart>[].obs;
  var isCheckedAll = false.obs;
  var isCheckedMap = <String, bool>{}.obs;

  var hasError = false.obs;
  var cartLength = 0.obs;

  Future<void> fetchCartLength() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      // Gọi phương thức để lấy dữ liệu từ CartService
      final length = await CartService().getCartLengthFromPreferences();
      cartLength.value = length;
    } catch (error) {
      hasError.value = true;
      print("Error fetching cart length: $error");
    } finally {
      isLoading.value = false;
    }
  }

  void increaseCartLength() {
    int newCartLength = cartLength.value + 1;
    CartService().updateCart(newCartLength);
  }

  void decreaseCartLength(int listSelected) {
    int newCartLength = cartLength.value - listSelected;
    CartService().updateCart(newCartLength);
  }

  // Hàm lấy các item đã được chọn (checked)

  List<Cart> get selectedItems {
    return cartList.where((cart) => isCheckedMap[cart.id] == true).toList();
  }

  int get totalQuantityOfSelectedItems {
    // Lọc ra các item đã chọn và tính tổng quantity
    return selectedItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    return selectedItems.fold(
        0, (sum, item) => sum + (item.productPrice * item.quantity));
  }

  void toggleIsChecked(String cartItemId) {
    bool currentIsChecked =
        isCheckedMap[cartItemId] ?? false; // Lấy trạng thái hiện tại
    isCheckedMap[cartItemId] = !currentIsChecked; // Thay đổi trạng thái
    cartList.refresh();
  }

  Future<void> fetchCartByUserId(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Lấy dữ liệu từ Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('carts')
          .where('userId', isEqualTo: userId)
          .get();

      // Sử dụng Cart.fromFirestore để ánh xạ dữ liệu từ Firestore thành đối tượng Cart
      cartList.value = querySnapshot.docs.map((doc) {
        return Cart.fromFirestore(doc); // Sử dụng fromFirestore thay vì fromMap
      }).toList();
    } catch (e) {
      print("Error fetching cart data: $e");
      errorMessage.value = 'Error fetching cart data';
      cartList.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void toggleIsCheckedAll() {
    isCheckedAll.value = !isCheckedAll.value;
    if (isCheckedAll.value) {
      for (var cartItem in cartList) {
        isCheckedMap[cartItem.id] = true;
      }
      cartList.refresh();
    } else {
      for (var cartItem in cartList) {
        isCheckedMap[cartItem.id] = false;
      }
      cartList.refresh();
    }
  }

  void totalPriceAndItem() {
    if (isCheckedAll.value) {}
  }

  void onTapIncrement({String? cartItemId, int? currentQuantity}) async {
    try {
      if (cartItemId != null && currentQuantity != null) {
        final newQuantity = currentQuantity + 1;
        await FirebaseFirestore.instance
            .collection('carts')
            .doc(cartItemId)
            .update({
          'quantity': newQuantity,
        });
        int index = cartList.indexWhere((cart) => cart.id == cartItemId);
        if (index != -1) {
          cartList[index].quantity = newQuantity;
        }
        cartList.refresh();
      } else {
        print("Invalid cartItemId or currentQuantity");
      }
    } catch (error) {
      print("Failed to update item status: $error");
    }
  }

  void onTapDecrease({String? cartItemId, int? currentQuantity}) async {
    try {
      if (cartItemId != null && currentQuantity != null) {
        if (currentQuantity <= 0) {
          Get.snackbar("Levi's Store", "Quantity cannot be less than 0");
        } else {
          final newQuantity = currentQuantity - 1;
          await FirebaseFirestore.instance
              .collection('carts')
              .doc(cartItemId)
              .update({
            'quantity': newQuantity,
          });
          int index = cartList.indexWhere((cart) => cart.id == cartItemId);
          if (index != -1) {
            cartList[index].quantity = newQuantity;
          }
          cartList.refresh();
        }
      } else {
        print("Invalid cartItemId or currentQuantity");
      }
    } catch (error) {
      print("Failed to update item status: $error");
    }
  }

  void onTapCartItem({String? productId}) {
    Get.toNamed(RoutesName.productDetailPage, arguments: {
      'productID': productId,
    });
  }

  void onTapBuyBtn({List<Cart>? selectedItems, totalPrice}) {
    if (selectedItems!.isNotEmpty) {
      Get.toNamed(RoutesName.orderPage, arguments: {
        'selectedItems': selectedItems,
        'totalPrice': totalPrice,
      });
    } else {
      Get.snackbar("Levi's Store", "Please chose products");
    }
  }
// void toggleIsChecked(String cartItemId) {
//   // Tìm item có `id` tương ứng trong danh sách và thay đổi `isChecked`
//   // final index = cartList.indexWhere((cart) => cart.id == cartItemId);
//   // if (index != -1) {
//   //   cartList[index].isChecked = !cartList[index].isChecked;
//   //   cartList.refresh(); // Thông báo cho Obx cập nhật giao diện
//   // }
//   // Tìm item có `id` tương ứng trong danh sách và thay đổi trạng thái isChecked
//   bool currentIsChecked =
//       isCheckedMap[cartItemId] ?? false; // Lấy trạng thái hiện tại
//   isCheckedMap[cartItemId] = !currentIsChecked; // Thay đổi trạng thái
//   update();
// }
}
