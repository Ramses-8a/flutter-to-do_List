import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserController extends GetxController {
  final RxString userEmail = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeUser();
  }

  void _initializeUser() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      userEmail.value = user.email ?? '';
    }
  }

  Future<void> setUserEmail(String? email) async {
    userEmail.value = email ?? '';
  }

  Future<void> signOut() async {
    isLoading.value = true;
    try {
      await Supabase.instance.client.auth.signOut();
      userEmail.value = '';
      Get.offAllNamed('/');
    } finally {
      isLoading.value = false;
    }
  }
}
