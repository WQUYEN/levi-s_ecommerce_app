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

  // @override
  // void onClose() {
  //   // contentController.dispose();
  //   orderController.dispose();
  //   super.onClose();
  // }

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
