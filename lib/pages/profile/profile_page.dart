import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:levis_store/widgets/common_widget.dart';

import '../../routes/routes_name.dart';
import '../../services/auth_service.dart';
import '../../services/user_info_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserInfoService userInfoService = UserInfoService();
  String email = "Guest";
  String name = "";
  String avatarUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = userInfoService.getEmail() ?? "Guest";
    name = userInfoService.getDisplayName() ?? "";
    avatarUrl =
        userInfoService.getPhotoUrl() ?? "https://via.placeholder.com/150";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 80),
          child: Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                    image: NetworkImage(avatarUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                name,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              Text(
                email,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 16),
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              // SizedBox(
              //   width: size.width * 0.5,
              //   height: 60,
              //   child: ElevatedButton(
              //     onPressed: () {},
              //     style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.red,
              //         side: BorderSide.none,
              //         shape: const StadiumBorder()),
              //     child: const Text(
              //       "Edit Profile",
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 30,
              // ),
              const Divider(
                color: Colors.transparent,
              ),
              const SizedBox(
                height: 10,
              ),
              CommonWidget.profileBtn(
                  onTap: () {
                    Get.toNamed(RoutesName.settingPage);
                  },
                  context: context,
                  text: "Settings",
                  iconData: Iconsax.setting),
              const SizedBox(
                height: 10,
              ),
              CommonWidget.profileBtn(
                  onTap: () {},
                  context: context,
                  text: "User Management",
                  iconData: Icons.perm_identity_sharp),
              const SizedBox(
                height: 10,
              ),
              CommonWidget.profileBtn(
                  onTap: () {
                    Get.toNamed(RoutesName.orderPageByStatus);
                    print("CLick order");
                  },
                  context: context,
                  text: "Delivery",
                  iconData: Icons.delivery_dining_outlined),
              const SizedBox(
                height: 10,
              ),
              CommonWidget.profileBtn(
                  onTap: () {
                    Get.toNamed(RoutesName.addressPage);
                  },
                  context: context,
                  text: "Address",
                  iconData: Icons.location_on),
              const SizedBox(
                height: 100,
              ),
              CommonWidget.profileBtn(
                  onTap: () {},
                  context: context,
                  text: "Information",
                  iconData: Iconsax.info_circle),
              const SizedBox(
                height: 10,
              ),
              CommonWidget.profileBtn(
                  onTap: () async {
                    await AuthService().signOut();
                    Get.offNamed(RoutesName.loginPage);
                  },
                  context: context,
                  text: "Logout",
                  textColor: Colors.red,
                  iconData: Iconsax.logout,
                  endIcon: false),
            ],
          ),
        ),
      ),
    );
    // return Scaffold(
    //   body: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Center(
    //         child: Text(
    //           "Welcome, $email",
    //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.all(20.0),
    //         child: ElevatedButton(
    //           onPressed: () {
    //             Get.toNamed(RoutesName.settingPage);
    //           },
    //           style: ElevatedButton.styleFrom(
    //             foregroundColor: Colors.black,
    //             backgroundColor: Colors.white,
    //             minimumSize: const Size(double.infinity, 50),
    //             side: const BorderSide(color: Colors.grey),
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(8.0),
    //             ),
    //           ),
    //           child: Text(
    //             "Setting",
    //             style: GoogleFonts.poppins(
    //               fontSize: 16,
    //               fontWeight: FontWeight.w500,
    //             ),
    //           ),
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.all(20.0),
    //         child: ElevatedButton(
    //           onPressed: () async {
    //             await AuthService().signOut();
    //             Get.offNamed(RoutesName.loginPage);
    //           },
    //           style: ElevatedButton.styleFrom(
    //             foregroundColor: Colors.black,
    //             backgroundColor: Colors.white,
    //             minimumSize: const Size(double.infinity, 50),
    //             side: const BorderSide(color: Colors.grey),
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(8.0),
    //             ),
    //           ),
    //           child: Text(
    //             "Logout",
    //             style: GoogleFonts.poppins(
    //               fontSize: 16,
    //               fontWeight: FontWeight.w500,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
