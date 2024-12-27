import 'package:get/get.dart';

import '../../routes/routes_name.dart';

class SuccessController extends GetxController {
  void navigateToHome() async {
    await Future.delayed(const Duration(seconds: 1)); // Chờ 3 giây
    Get.offNamed(RoutesName.mainPage); // Điều hướng tới LoginPage
  }
}
