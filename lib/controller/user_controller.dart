import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserController extends GetxController {
  final Rx<String?> UserEmail = Rx<String?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initialized();
  }

  void _initialized() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      UserEmail.value = user.email;
    }
  }

  Future<void> setUserEmail(String? email) async {
    UserEmail.value = email;
  }

  Future<void> signOut() async {
    isLoading.value = true;
    try {
      await Supabase.instance.client.auth.signOut();
      UserEmail.value = null;

      Get.offAllNamed('/');
    } finally {
      isLoading.value = false;
    }
  }
}
