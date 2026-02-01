import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_pay_application/view_models/auth_controller.dart';
import 'package:plan_pay_application/views/login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final AuthController authController = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();

  final fullNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  bool hidePassword = true;

  @override
  void dispose() {
    fullNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              /// Full Name
              TextFormField(
                controller: fullNameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Full name required' : null,
              ),
              const SizedBox(height: 12),

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
              const SizedBox(height: 12),

              /// Phone
              TextFormField(
                controller: phoneCtrl,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v != null && v.length >= 10
                        ? null
                        : 'Valid phone number required',
              ),
              const SizedBox(height: 12),

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
              const SizedBox(height: 12),

              /// Confirm Password
              TextFormField(
                controller: confirmPasswordCtrl,
                obscureText: hidePassword,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (v) =>
                    v == passwordCtrl.text
                        ? null
                        : 'Passwords do not match',
              ),
              const SizedBox(height: 24),

              /// Submit Button
              Obx(
                () => ElevatedButton(
                  onPressed: authController.isLoading.value
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            authController.register(
                              fullNameCtrl.text.trim(),
                              emailCtrl.text.trim(),
                              phoneCtrl.text.trim(),
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
                      : const Text('Create Account'),
                ),
              ),

              const SizedBox(height: 16),

              /// Login redirect
              TextButton(
                onPressed: () => Get.off(const LoginView()),
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
