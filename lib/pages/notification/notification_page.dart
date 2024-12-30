import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // RemoteMessage? message;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // message = Get.arguments['message'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(message!.notification!.title.toString()),
          // Text(message!.notification!.body.toString()),
          // Text(message!.notification!.title.toString()),
        ],
      ),
    );
  }
}
