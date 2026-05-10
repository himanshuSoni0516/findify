import 'package:findify/screens/widgets/app_text_field.dart';
import 'package:findify/screens/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../core/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  final auth = Get.find<AuthController>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.background(context)),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo Section
                  Center(
                    child: Image.asset(
                      "assets/Findify_rounded_logo.png",
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Header
                  Text(
                    'Welcome Back',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Log in to find your lost items',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Email field
                  AppTextField(
                    controller: _emailCtrl,
                    label: 'Email Address',
                    hint: 'email address',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Password field
                  AppTextField(
                    controller: _passCtrl,
                    label: 'Password',
                    hint: 'password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _login(),
                  ),
                  const SizedBox(height: 12),

                  // Error message
                  Obx(
                    () => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: auth.errorMessage.value.isNotEmpty
                          ? Container(
                              key: ValueKey(auth.errorMessage.value),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colorScheme.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colorScheme.error.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 18,
                                    color: colorScheme.error,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      auth.errorMessage.value,
                                      style: TextStyle(
                                        color: colorScheme.error,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Login button
                  Obx(
                    () => SizedBox(
                      height: 56,
                      child: GradientButton(
                        onPressed: auth.isLoading.value ? null : _login,
                        isLoading: auth.isLoading.value,
                        borderRadius: 12,
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed('/signup'),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() {
    FocusScope.of(context).unfocus();
    if (_emailCtrl.text.trim().isEmpty || _passCtrl.text.isEmpty) {
      auth.errorMessage.value = 'Please fill in all fields';
      return;
    }
    auth.signIn(email: _emailCtrl.text.trim(), password: _passCtrl.text);
  }
}
