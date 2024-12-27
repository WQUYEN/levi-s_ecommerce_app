import 'package:intl/intl.dart';

class Validator {
  static String formatCurrency(double price) {
    // Kiểm tra xem giá trị có hợp lệ hay không
    if (price <= 0) {
      return "0 đ";
    }
    // Định dạng tiền tệ VND
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return formatter.format(price); // Định dạng giá trị thành VND
  }
}
