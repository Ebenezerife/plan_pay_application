import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_pay_application/view_models/auth_controller.dart';
import 'package:plan_pay_application/views/register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool hidePassword = true;

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 40),

              /// Email
              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    v != null && GetUtils.isEmail(v)
                        ? null
                        : 'Enter a valid email',
              ),
              const SizedBox(height: 16),

              /// Password
              TextFormField(
                controller: passwordCtrl,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => hidePassword = !hidePassword),
                  ),
                ),
                validator: (v) =>
                    v != null && v.length >= 8
                        ? null
                        : 'Minimum 8 characters',
              ),
              const SizedBox(height: 24),

              /// Login Button
              Obx(
                () => ElevatedButton(
                  onPressed: authController.isLoading.value
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            authController.login(
                              emailCtrl.text.trim(),
                              passwordCtrl.text,
                            );
                          }
                        },
                  child: authController.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Login'),
                ),
              ),

              const SizedBox(height: 12),

              /// Forgot password
              TextButton(
                onPressed: () {
                  if (emailCtrl.text.isEmpty) {
                    Get.snackbar(
                      'Email required',
                      'Enter your email to reset password',
                    );
                    return;
                  }
                  authController.forgotPassword(emailCtrl.text.trim());
                },
                child: const Text('Forgot Password?'),
              ),

              const SizedBox(height: 12),

              /// Register redirect
              TextButton(
                onPressed: () => Get.off(const RegisterView()),
                child: const Text('Don’t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
