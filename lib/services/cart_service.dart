import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  void updateCart(int cartLength) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cartLength', cartLength);
  }

  Future<int> getCartLengthFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('cartLength') ?? 0;
  }

  Future<void> clearCartLengthFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartLength');
  }
}
