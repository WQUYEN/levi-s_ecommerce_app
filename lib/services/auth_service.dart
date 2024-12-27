import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:levis_store/services/user_info_service.dart';

class AuthService {
  /// Google sign-in
  Future<UserCredential> signInWithGoogle() async {
    // Begin interactive sign-in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // Obtain auth details from the request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // Create new credentials for the user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Sign in to Firebase with the credentials
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  /// Sign-out
  Future<void> signOut() async {
    try {
      // Sign out from Google
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
        final userInfoService = UserInfoService();
        userInfoService.clearUserInfoFromPreferences();
        Get.snackbar("Wq Fashion", "Logged out successfully");
      }
    } catch (e) {
      print("Logout failed: $e");
      Get.snackbar("Wq Fashion", "Logout failed. Please try again!");
    }
  }
}
