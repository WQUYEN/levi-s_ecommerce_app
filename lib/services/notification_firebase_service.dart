import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:levis_store/routes/routes_name.dart';

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();

    //Get token
    print(("fCMToken: $fCMToken"));
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    Get.toNamed(RoutesName.notificationPage, arguments: {
      'message': message,
    });
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Xử lý thông báo trong nền: ${message.notification?.title}");
  }
}
