import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate the LoginController
    final LoginController controller = Get.put(LoginController());

    // Call checkLoginStatus when the page is first loaded
    // controller.checkLoginStatus();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or Title
                Text(
                  "Welcome",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Login to continue",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),

                // Login with Google button
                Obx(() {
                  if (controller.isLoading.value) {
                    return const CircularProgressIndicator();
                  } else {
                    return ElevatedButton(
                      onPressed: () async {
                        await controller.signInWithGoogle();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/google_logo.png',
                            height: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Login with Google",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),

                // Show error message if login failed
                Obx(() {
                  if (controller.errorMessage.value.isNotEmpty) {
                    return Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  return Container();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
