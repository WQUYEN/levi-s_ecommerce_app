import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'spash_controller.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  // Khởi tạo SplashController
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Center(
        child: Lottie.network(
          "https://lottie.host/7c413d24-257a-448c-b8a0-ad6912a0df8e/ZsjUqTOUnG.json",
          width: MediaQuery.of(context).size.width,
          height: 200,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
