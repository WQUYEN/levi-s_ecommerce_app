import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:levis_store/models/cart.dart';
import 'package:levis_store/pages/cart/cart_controller.dart';
import 'package:levis_store/routes/routes_name.dart';
import 'package:levis_store/services/user_info_service.dart';

import '../../models/category.dart';
import '../../models/color_model.dart';
import '../../models/product.dart';
import '../../models/sizeInfo.dart';

class ProductDetailController extends GetxController {
  var product = Rx<Product?>(null);
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var errorMessageDialog = ''.obs;
  var selectedColorIndex = (-1).obs;
  var selectedSizeIndex = (-1).obs;
  var imageUrls = Rx<List<String>>([]);
  var availableSizes = Rx<List<SizeInfo>>([]);
  var defaultColor = Rx<Color>(Colors.black);
  var quantity = 0.obs;
  var maxQuantity = 0;
  var currentIndex = 0.obs;
  final CartController cartController = Get.put(CartController());
  var isFavorite = false.obs;

  @override
  void onClose() {
    super.onClose();
    cartController;
  }

  Future<void> checkFavorite({required String productId}) async {
    try {
      final UserInfoService userInfoService = UserInfoService();
      String userId = userInfoService.getUid() ?? "";

      if (userId.isEmpty) {
        isFavorite.value = false;
        return;
      }

      final firestore = FirebaseFirestore.instance;

      final querySnapshot = await firestore
          .collection('favorites')
          .where('userId', isEqualTo: userId)
          .where('productId', isEqualTo: productId)
          .get();

      isFavorite.value = querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Failed to check favorite status: $e");
      isFavorite.value = false;
    }
  }

  void addFavorite({required String productId}) async {
    try {
      final UserInfoService userInfoService = UserInfoService();
      String userId = userInfoService.getUid() ?? "";

      if (userId.isEmpty) {
        Get.snackbar(
          "Error",
          "User not logged in.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        );
        return;
      }

      final firestore = FirebaseFirestore.instance;

      // Kiểm tra xem sản phẩm đã có trong favorites chưa
      final querySnapshot = await firestore
          .collection('favorites')
          .where('userId', isEqualTo: userId)
          .where('productId', isEqualTo: productId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Get.snackbar(
          "Favorites",
          "This product is already in your favorites.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        );
        return;
      }

      // Thêm sản phẩm vào favorites
      await firestore.collection('favorites').add({
        'userId': userId,
        'productId': productId,
        'addedAt': FieldValue.serverTimestamp(),
      });

      // Get.snackbar(
      //   "Favorites",
      //   "Product added to favorites successfully.",
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.green,
      //   duration: const Duration(seconds: 2),
      // );
    } catch (e) {
      print("Failed to add product to favorites: $e");
      Get.snackbar(
        "Error",
        "Failed to add product to favorites. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void updateCurrentIndex(int index) {
    currentIndex.value = index;
  }

// Xóa sản phẩm khỏi danh sách yêu thích
  Future<void> removeFavorite({required String productId}) async {
    try {
      final UserInfoService userInfoService = UserInfoService();
      String userId = userInfoService.getUid() ?? "";

      if (userId.isEmpty) {
        return;
      }

      final firestore = FirebaseFirestore.instance;

      // Query để tìm sản phẩm yêu thích của userId và productId
      final querySnapshot = await firestore
          .collection('favorites')
          .where('userId', isEqualTo: userId)
          .where('productId', isEqualTo: productId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Lấy document đầu tiên (nếu có)
        final doc = querySnapshot.docs.first;

        // Xóa sản phẩm khỏi collection 'favorites'
        await doc.reference.delete();

        isFavorite.value = false;
        // Get.snackbar(
        //   "Favorites",
        //   "Product removed from favorites.",
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.orange,
        //   duration: const Duration(seconds: 2),
        // );
      } else {
        Get.snackbar(
          "Error",
          "Product not found in favorites.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print("Failed to remove product from favorites: $e");
      Get.snackbar(
        "Error",
        "Failed to remove product from favorites. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> fetchProductWithDetails(String productId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      imageUrls.value = [];
      availableSizes.value = [];
      await checkFavorite(productId: productId);
      // Lấy dữ liệu product
      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (!productDoc.exists) {
        throw Exception('Product not found');
      }

      final product = Product.fromFirestore(productDoc);

      imageUrls.value = List<String>.from(productDoc['imageUrl'] ?? []);

      final categories = await fetchCategoriesByIds(product.categories);

      final colors = await fetchColorsByIds(product.colors);

      this.product.value = product.copyWith(
        detailedCategories: categories,
        detailedColors: colors,
      );

      if (colors.isNotEmpty) {
        updateAvailableSizes(colors.first);
        defaultColor.value = parseHexColor(colors.first.hex);
      } else {
        defaultColor.value = Colors.black;
      }
    } catch (e) {
      print('Error fetching product with details: $e');
      errorMessage.value = "Failed to fetch product details.";
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch colors by IDs
  Future<List<ColorModel>> fetchColorsByIds(List<String> ids) async {
    try {
      final futures = ids.map((id) =>
          FirebaseFirestore.instance.collection('colors').doc(id).get());
      final docs = await Future.wait(futures);

      return docs
          .where((doc) => doc.exists)
          .map((doc) => ColorModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching colors: $e');
      return [];
    }
  }

  // Fetch categories by IDs
  Future<List<Category>> fetchCategoriesByIds(List<String> ids) async {
    try {
      final futures = ids.map((id) =>
          FirebaseFirestore.instance.collection('categories').doc(id).get());
      final docs = await Future.wait(futures);

      return docs
          .where((doc) => doc.exists)
          .map((doc) => Category.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<List<SizeInfo>> fetchSizesByColorId(String colorId) async {
    try {
      final sizesSnapshot = await FirebaseFirestore.instance
          .collection('colors')
          .doc(colorId)
          .collection('size')
          .get();

      if (sizesSnapshot.docs.isEmpty) {
        throw Exception('No sizes found for color $colorId');
      }

      return sizesSnapshot.docs.map((doc) {
        final sizeData = doc.data();
        return SizeInfo(
          id: doc.id,
          size: sizeData['size'],
          quantity: sizeData['quantity'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching sizes for color $colorId: $e');
      return [];
    }
  }

  void updateAvailableSizes(ColorModel color) async {
    try {
      final sizes = await fetchSizesByColorId(color.id);

      availableSizes.value = sizes;

      selectedSizeIndex.value = -1;
    } catch (e) {
      print('Error updating available sizes: $e');
    }
  }

  Color parseHexColor(String hexCode) {
    if (!hexCode.startsWith('#')) {
      hexCode = '#$hexCode';
    }
    try {
      return Color(int.parse(hexCode.replaceFirst('#', '0xff')));
    } catch (e) {
      print('Invalid hex color: $hexCode. Error: $e');
      return Colors.black;
    }
  }

  void updateMaxQuantity() {
    if (selectedSizeIndex.value >= 0 &&
        selectedSizeIndex.value < availableSizes.value.length) {
      maxQuantity = availableSizes.value[selectedSizeIndex.value].quantity;
    } else {
      maxQuantity = 0;
    }
  }

  Future<void> showQuantityDialog(BuildContext context) async {
    errorMessageDialog.value = "";
    TextEditingController quantityController =
        TextEditingController(text: "${quantity.value}");

    Get.defaultDialog(
      title: "Enter Quantity",
      content: Column(
        children: [
          TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Enter quantity"),
          ),
          Obx(
            () => Text(
              errorMessageDialog.value,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            'Cancel',
            style:
                TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
        ),
        TextButton(
          onPressed: () {
            try {
              int newQuantity = int.parse(quantityController.text);
              if (newQuantity < maxQuantity) {
                updateQuantity(quantityController.text);
                Get.back();
              } else {
                errorMessageDialog.value =
                    "Quantity must be less than $maxQuantity";
              }
            } catch (e) {
              errorMessageDialog.value = "Please enter a valid number";
            }
          },
          child: Text(
            'OK',
            style:
                TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
        ),
      ],
    );
  }

  void updateQuantity(String value) {
    try {
      int newQuantity = int.parse(value);

      if (newQuantity >= 0 && newQuantity <= maxQuantity) {
        quantity.value = newQuantity;
      } else {
        Get.snackbar(
          "Warning",
          "Quantity must be between 0 and $maxQuantity.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      resetQuantity();
      Get.snackbar(
        "Error",
        "Invalid quantity. Resetting to 0.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void resetQuantity() {
    quantity.value = 0;
  }

  void increaseQuantity() {
    if (quantity.value < maxQuantity) {
      quantity.value++;
    } else {
      Get.snackbar(
        "Warning",
        "You cannot add more than $maxQuantity items.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void decreaseQuantity() {
    if (quantity.value > 0) {
      quantity.value--;
    } else {
      Get.snackbar(
        "Warning",
        "Quantity cannot be less than 0.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void onClickAddToCart({
    required Product product,
    required String selectedColor,
    required String selectedSize,
    required int selectedQuantity,
  }) async {
    try {
      final UserInfoService userInfoService = UserInfoService();
      var userId = userInfoService.getUid();

      if (selectedQuantity > maxQuantity) {
        Get.snackbar("WQ Levi's", "Quantity exceeds the maximum limit");
        return;
      }

      final firestore = FirebaseFirestore.instance;

      final cartQuerySnapshot = await firestore
          .collection('carts')
          .where('userId', isEqualTo: userId)
          .where('productId', isEqualTo: product.id)
          .where('selectedColor', isEqualTo: selectedColor)
          .where('selectedSize', isEqualTo: selectedSize)
          .get();

      if (cartQuerySnapshot.docs.isNotEmpty) {
        final cartDoc = cartQuerySnapshot.docs.first;
        int currentQuantity = cartDoc['quantity'] ?? 0;

        int updatedQuantity = currentQuantity + selectedQuantity;

        if (updatedQuantity > maxQuantity) {
          Get.snackbar("WQ Levi's", "Exceeds maximum quantity");
          return;
        }

        await cartDoc.reference.update({
          'quantity': updatedQuantity,
        });

        Get.snackbar(
          "Cart",
          "Product quantity updated in cart.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        );
      } else {
        await firestore.collection('carts').add({
          'userId': userId,
          'productId': product.id,
          'productName': product.name,
          'productPrice': product.price,
          'productPrimaryImage': product.primaryImage,
          'selectedColor': selectedColor,
          'selectedSize': selectedSize,
          'quantity': selectedQuantity,
          'createdAt': FieldValue.serverTimestamp(),
        });

        Get.snackbar(
          "Cart",
          "Product added to cart successfully.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        );
        cartController.increaseCartLength();
      }
    } catch (error) {
      print("Failed to add product to cart: $error");
      Get.snackbar(
        "Error",
        "Failed to add product to cart: $error",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void onClickBuyNow({
    required Product product,
    required String selectedColor,
    required String selectedSize,
    required int selectedQuantity,
  }) async {
    final UserInfoService userInfoService = UserInfoService();
    String? userId = userInfoService.getUid() ?? "";
    if (quantity.value > maxQuantity) {
      Get.snackbar("WQ Levi's", "Quantity error");
    } else {
      final cartItem = Cart(
          id: "id",
          productId: product.id,
          productName: product.name,
          productPrice: product.price,
          productPrimaryImage: product.primaryImage,
          quantity: selectedQuantity,
          selectedColor: selectedColor,
          selectedSize: selectedSize,
          userId: userId,
          isChecked: false,
          createdAt: DateTime.now());
      List<Cart>? cartList;
      cartList ??= [];
      cartList.add(cartItem);

      Get.toNamed(RoutesName.orderPage, arguments: {
        'selectedItems': cartList,
        'totalPrice': product.price * selectedQuantity,
      });
    }
  }
}
