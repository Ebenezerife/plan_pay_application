import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plan_pay_application/views/home.dart';
import 'package:plan_pay_application/views/login_view.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService authService = AuthService();

  var isLoading = false.obs;
  var user = Rxn<User>();

  @override
  void onInit() {
    user.value = authService.currentUser;
    super.onInit();
  }

  Future<void> register(
    String fullName,
    String email,
    String phone,
    String password,
  ) async {
    try {
      isLoading.value = true;
      user.value = await authService.register(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );
      Get.offAll(Home());
    } catch (e) {
      Get.snackbar('Registration Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      user.value = await authService.login(email: email, password: password);
      Get.offAll(Home());
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await authService.logout();
    user.value = null;
    Get.offAll(LoginView());
  }

  Future<void> forgotPassword(String email) async {
    await authService.resetPassword(email);
    Get.snackbar('Success', 'Password reset email sent');
  }
}
