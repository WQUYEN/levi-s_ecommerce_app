import 'package:get/get.dart';

import '../../routes/routes_name.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigateToLogin();
  }

  void navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 4)); // Chờ 3 giây
    Get.offNamed(RoutesName.loginPage); // Điều hướng tới LoginPage
  }
}
