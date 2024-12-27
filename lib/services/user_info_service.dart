import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoService {
  // Lấy thông tin từ Firebase
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  // Lấy email từ Firebase
  String? getEmail() {
    return getCurrentUser()?.email;
  }

  // Lấy UID từ Firebase
  String? getUid() {
    return getCurrentUser()?.uid;
  }

  // Lấy tên hiển thị từ Firebase
  String? getDisplayName() {
    return getCurrentUser()?.displayName;
  }

  // Lấy ảnh đại diện từ Firebase
  String? getPhotoUrl() {
    return getCurrentUser()?.photoURL;
  }

  // Lấy thông tin từ SharedPreferences
  Future<Map<String, dynamic>> getUserInfoFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? 'Unknown';
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    return {
      'email': email,
      'isLoggedIn': isLoggedIn,
    };
  }

  // Xóa thông tin người dùng khỏi SharedPreferences
  Future<void> clearUserInfoFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('isLoggedIn');
  }
}
