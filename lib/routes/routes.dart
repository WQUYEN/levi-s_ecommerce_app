import 'package:get/get.dart';
import 'package:levis_store/pages/address/address_add_page.dart';
import 'package:levis_store/pages/address/address_page.dart';
import 'package:levis_store/pages/cart/cart_page.dart';
import 'package:levis_store/pages/notification/notification_page.dart';
import 'package:levis_store/pages/order/order_page.dart';
import 'package:levis_store/pages/order/order_status_page.dart';
import 'package:levis_store/pages/order/payment_method_page.dart';
import 'package:levis_store/pages/product_detail/product_detail_page.dart';
import 'package:levis_store/routes/main_page.dart';
import 'package:levis_store/routes/routes_name.dart';

import '../pages/auth/login/login_page.dart';
import '../pages/home/home_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/setting/setting_page.dart';
import '../pages/splash/splash_page.dart';
import '../pages/success/success_page.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
            name: RoutesName.splashPage,
            page: () => SplashPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.cupertino),
        GetPage(
            name: RoutesName.homePage,
            page: () => const HomePage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.cupertino),
        GetPage(
            name: RoutesName.settingPage,
            page: () => const SettingPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.cupertino),
        GetPage(
            name: RoutesName.loginPage,
            page: () => const LoginPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.cupertino),
        GetPage(
            name: RoutesName.profilePage,
            page: () => const ProfilePage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.cupertino),
        GetPage(
            name: RoutesName.mainPage,
            page: () => const MainPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.cupertino),
        GetPage(
            name: RoutesName.productDetailPage,
            page: () => const ProductDetailPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.cupertino),
        GetPage(
            name: RoutesName.cartPage,
            page: () => const CartPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.cupertino),
        GetPage(
            name: RoutesName.orderPage,
            page: () => OrderPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.cupertino),
        GetPage(
            name: RoutesName.successPage,
            page: () => const SuccessPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.cupertino),
        GetPage(
            name: RoutesName.addressPage,
            page: () => const AddressPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.cupertino),
        GetPage(
            name: RoutesName.addAddressPage,
            page: () => const AddressAddPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.cupertino),
        GetPage(
            name: RoutesName.orderPageByStatus,
            page: () => OrderStatusPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.cupertino),
        GetPage(
            name: RoutesName.paymentMethodPage,
            page: () => PaymentMethodPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.cupertino),
        GetPage(
            name: RoutesName.notificationPage,
            page: () => const NotificationPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.cupertino),
      ];
}
