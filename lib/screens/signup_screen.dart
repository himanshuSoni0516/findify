import 'package:findify/screens/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../core/app_theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _courseCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _selectedSemester;
  bool _obscure = true;

  final auth = Get.find<AuthController>();
  final semesters = ['1st', '2nd', '3rd', '4th', '5th', '6th', '7th', '8th'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _courseCtrl.dispose();
    _phoneCtrl.dispose();
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Back button ──────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 8),

                // ── Logo ─────────────────────────────────
                Center(
                  child: Image.asset(
                    'assets/Findify_rounded_logo.png',
                    width: 80,
                    height: 80,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Header ───────────────────────────────
                Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Join your college lost & found',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 36),

                // ── Full Name ────────────────────────────
                _buildLabel('Full Name *'),
                TextField(
                  controller: _nameCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Raj Kumar',
                    prefixIcon: Icon(Icons.person_outline, size: 22),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Email ────────────────────────────────
                _buildLabel('Email Address *'),
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'raj@college.edu',
                    prefixIcon: Icon(Icons.email_outlined, size: 22),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Phone ────────────────────────────────
                _buildLabel('Phone Number'),
                TextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: '9876543210',
                    prefixIcon: Icon(Icons.phone_outlined, size: 22),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Course ───────────────────────────────
                _buildLabel('Course'),
                TextField(
                  controller: _courseCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'B.Tech CSE',
                    prefixIcon: Icon(Icons.school_outlined, size: 22),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Semester ─────────────────────────────
                _buildLabel('Semester'),
                DropdownButtonFormField<String>(
                  value: _selectedSemester,
                  hint: Text('Select semester',
                      style: TextStyle(color: colorScheme.onSurfaceVariant)),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.calendar_today_outlined, size: 22),
                    // inherits AppTheme.inputDecorationTheme automatically
                  ),
                  dropdownColor: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  items: semesters
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedSemester = val),
                ),
                const SizedBox(height: 20),

                // ── Password ─────────────────────────────
                _buildLabel('Password *'),
                TextField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _signup(),
                  decoration: InputDecoration(
                    hintText: 'Min. 6 characters',
                    prefixIcon: const Icon(Icons.lock_outline, size: 22),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ── Error message ────────────────────────
                Obx(() => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: auth.errorMessage.value.isNotEmpty
                      ? Container(
                    key: ValueKey(auth.errorMessage.value),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: colorScheme.error.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline,
                            size: 18, color: colorScheme.error),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            auth.errorMessage.value,
                            style: TextStyle(
                                color: colorScheme.error, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  )
                      : const SizedBox.shrink(),
                )),

                const SizedBox(height: 32),

                // ── Signup button ────────────────────────
                Obx(() => SizedBox(
                  height: 56,
                  child: GradientButton(
                    onPressed: auth.isLoading.value ? null : _signup,
                    isLoading: auth.isLoading.value,
                    borderRadius: 12,
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )),

                const SizedBox(height: 24),

                // ── Login link ───────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signup() {
    FocusScope.of(context).unfocus();
    if (_nameCtrl.text.trim().isEmpty ||
        _emailCtrl.text.trim().isEmpty ||
        _passCtrl.text.isEmpty) {
      auth.errorMessage.value = 'Please fill in all required fields (*)';
      return;
    }
    if (_passCtrl.text.length < 6) {
      auth.errorMessage.value = 'Password must be at least 6 characters';
      return;
    }
    auth.signUp(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      name: _nameCtrl.text.trim(),
      course: _courseCtrl.text.trim(),
      semester: _selectedSemester,
      phone: _phoneCtrl.text.trim(),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
    ),
  );
}