import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:levis_store/pages/review/review_controller.dart';

class AddReview extends StatefulWidget {
  const AddReview({super.key});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  final ReviewController controller = Get.put(ReviewController());
  double padding = 16.0;
  var productId = '';
  var orderId = '';

  @override
  void initState() {
    // TODO: implement initState
    productId = Get.arguments['productId'] ?? '';
    orderId = Get.arguments['orderId'] ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rating"),
      ),
      body: Obx(() {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Đánh giá của bạn:',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              RatingBar.builder(
                initialRating: controller.rating.value,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  controller.rating.value = rating;
                },
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: TextField(
                  controller: controller.contentController,
                  maxLength: 200,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Input your review'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(padding),
                child: ElevatedButton(
                  onPressed: () async {
                    controller.uploadReview(
                        productId, orderId, controller.rating.value);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        "Post",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
