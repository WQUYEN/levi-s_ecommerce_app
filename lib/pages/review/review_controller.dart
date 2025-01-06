import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:levis_store/pages/order/order_controller.dart';
import 'package:levis_store/services/user_info_service.dart';

import '../../models/review.dart';
import '../../routes/routes_name.dart';

class ReviewController extends GetxController {
  var rating = 0.0.obs;
  TextEditingController contentController = TextEditingController();
  final OrderController orderController =
      Get.put(tag: DateTime.now().toString(), OrderController());
  var isLoadingReviews = false.obs;
  var errorMessageReview = ''.obs;
  var reviews = <Review>[].obs;
  var productReviews =
      <String, List<Review>>{}.obs; // Lưu đánh giá theo productId

  double calculateAverageRatingForProduct(String productId) {
    final reviews = productReviews[productId] ?? [];
    if (reviews.isEmpty) {
      return 0.0;
    }
    final totalRating = reviews.fold(0.0, (sum, review) => sum + review.rating);
    return totalRating / reviews.length;
  }

  double calculateAverageRating() {
    if (reviews.isEmpty) {
      return 0.0; // Trả về 0 nếu không có review nào
    }

    double totalRating =
        reviews.fold(0.0, (sum, review) => sum + review.rating);
    return totalRating / reviews.length;
  }

  Future<void> fetchReviewsByProductId(String productId) async {
    try {
      isLoadingReviews.value = true;
      errorMessageReview.value = '';

      // Lấy dữ liệu từ Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('productId', isEqualTo: productId)
          .get();

      reviews.value = querySnapshot.docs.map((doc) {
        return Review.fromFirestore(doc);
      }).toList();

      print("Fetching review data success");
    } catch (e) {
      print("Error fetching review data: $e");
      errorMessageReview.value = 'Error fetching review data';
      reviews.clear();
    } finally {
      isLoadingReviews.value = false;
    }
  }

  Future<void> uploadReview(
      String productId, String orderId, double rating) async {
    try {
      final userId = UserInfoService().getUid();
      final userName = UserInfoService().getDisplayName();
      final avatarUrl = UserInfoService().getPhotoUrl();
      if (contentController.text.isEmpty) {
        Get.snackbar("Error", "Content cannot be empty.",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      final review = Review(
        id: "",
        userId: userId!,
        userName: userName!,
        avatarUrl: avatarUrl!,
        productId: productId,
        orderId: orderId,
        rating: rating,
        content: contentController.text,
        createdAt: DateTime.now(),
      );
      await FirebaseFirestore.instance.collection('reviews').add(
            review.toFirestore(),
          );
      await markOrderAsRated(orderId);

      orderController.orders.refresh();
      Get.offNamed(RoutesName.mainPage);
      Get.snackbar("Success", "Review posted successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print("Error: $e");
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> markOrderAsRated(String orderId) async {
    try {
      final orderDoc =
          FirebaseFirestore.instance.collection('orders').doc(orderId);
      await orderDoc.update({'isRating': true});
    } catch (e) {
      print(e);
    }
  }
}
