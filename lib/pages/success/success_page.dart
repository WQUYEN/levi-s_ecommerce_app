import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:levis_store/pages/success/success_controller.dart';
import 'package:lottie/lottie.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage>
    with SingleTickerProviderStateMixin {
  final SuccessController controller = Get.put(SuccessController());
  late AnimationController _controller;
  int playCount = 0; // Biến để đếm số lần lặp lại
  @override
  void initState() {
    super.initState();

    // Khởi tạo AnimationController
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        playCount++; // Tăng số lần lặp
        if (playCount < 1) {
          _controller.forward(from: 0); // Phát lại từ đầu
        } else {
          controller.navigateToHome();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Lottie.network(
          "https://lottie.host/1a06b1b3-7524-44c6-ad0b-a5ddc58b6f8a/9VPttDdkbD.json",
          height: 200,
          fit: BoxFit.fill,
          controller: _controller,
          onLoaded: (composition) {
            // Gán duration cho controller và bắt đầu animation
            _controller.duration = composition.duration;
            _controller.forward();
          },
        ),
      ),
    );
  }
}
