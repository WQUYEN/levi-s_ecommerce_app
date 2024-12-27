import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/routes_name.dart';
import '../../../services/auth_service.dart';

class LoginController extends GetxController {
  // Observable state variables
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Check if the user is already logged in
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Lấy thông tin email từ SharedPreferences
      final email = prefs.getString('email') ?? "Guest";

      // Redirect to HomePage if logged in
      Get.offNamed(RoutesName.mainPage, arguments: {
        'email': email,
      });
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      // Đăng nhập Google thông qua AuthService
      final userCredential = await AuthService().signInWithGoogle();
      final user = userCredential.user;

      if (user != null) {
        // Lưu thông tin đăng nhập vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', user.email!);
        await prefs.setBool('isLoggedIn', true);

        // Chuyển hướng tới màn hình chính
        Get.offNamed(RoutesName.mainPage, arguments: {
          'email': user.email!,
        });

        Get.snackbar("Wq Fashion", "Login success");
      }
    } catch (e) {
      errorMessage.value = "Login failed. Please try again!";
      print("Login failed: $e");
      Get.snackbar("Wq Fashion", errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
