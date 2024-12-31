import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:levis_store/pages/home/home_page.dart';
import 'package:levis_store/pages/notification/notification_page.dart';
import 'package:levis_store/pages/profile/profile_page.dart';
import 'package:levis_store/pages/search/search_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final List pages = [
    const HomePage(),
    SearchPage(),
    const NotificationPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surface,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Theme.of(context).colorScheme.primary,
          selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
          currentIndex: selectedIndex,
          onTap: (value) {
            setState(() {});
            selectedIndex = value;
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Iconsax.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.search_normal), label: "Search"),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.notification), label: "Notification"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: "Profile"),
          ]),
      body: pages[selectedIndex],
    );
  }
}
