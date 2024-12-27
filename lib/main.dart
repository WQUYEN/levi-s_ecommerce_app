import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:levis_store/routes/routes.dart';
import 'package:levis_store/routes/routes_name.dart';
import 'package:levis_store/themes/theme_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Nền thanh trạng thái trong suốt
    statusBarIconBrightness: Brightness.dark, // Icon (pin, giờ) màu đen
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Levi's Store",
      theme: Provider.of<ThemeProvider>(context).themeData,
      initialRoute: RoutesName.splashPage,
      getPages: AppRoutes.appRoutes(),
      debugShowCheckedModeBanner: false,
    );
  }
}
