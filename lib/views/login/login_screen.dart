import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/toast_service.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'widgets/speed_lines_painter.dart';
import 'widgets/car_trio.dart';

/// Screen 1 — Login.
///
/// Landscape, game-like splash. Left half = branding, right half = a floating
/// login card. Demo credentials: `user` / `1234`. On success it routes to the
/// game (named route [LoginScreen.nextRoute]).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  /// Route pushed after a successful login.
  static const String nextRoute = '/game';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _attemptLogin() {
    final auth = context.read<AuthViewModel>();
    final ok = auth.login(_userController.text, _passController.text);
    if (ok) {
      Navigator.of(context).pushReplacementNamed(LoginScreen.nextRoute);
    } else {
      ToastService.error(context, 'Login failed', description: auth.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Background gradient: sky blue → navy (diagonal) ──────────
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.skyBlue, AppColors.navy],
                ),
              ),
            ),
          ),

          // ── Diagonal speed-line pattern @ 10% white ──────────────────
          const Positioned.fill(
            child: CustomPaint(painter: SpeedLinesPainter()),
          ),

          // ── Content: branding | form ─────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Expanded(child: _BrandingPanel()),
                  Expanded(
                    child: _LoginCard(
                      userController: _userController,
                      passController: _passController,
                      obscure: _obscure,
                      onToggleObscure: () =>
                          setState(() => _obscure = !_obscure),
                      onSubmit: _attemptLogin,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Footer version ───────────────────────────────────────────
          const Positioned(
            right: 12,
            bottom: 8,
            child: Text(
              AppStrings.appVersion,
              style: TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Left panel — branding ──────────────────────────────────────────────────────

class _BrandingPanel extends StatelessWidget {
  const _BrandingPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          AppStrings.loginLogo,
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: 1.5,
            shadows: [
              Shadow(color: AppColors.yellow, blurRadius: 18),
              Shadow(color: AppColors.yellow, blurRadius: 6),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          AppStrings.loginTagline,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: 20),
        CarTrio(width: 200),
      ],
    );
  }
}

// ── Right panel — floating login card ──────────────────────────────────────────

class _LoginCard extends StatelessWidget {
  final TextEditingController userController;
  final TextEditingController passController;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;

  const _LoginCard({
    required this.userController,
    required this.passController,
    required this.obscure,
    required this.onToggleObscure,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── "LOGIN" label ────────────────────────────────────────
              const Text(
                AppStrings.loginTitle,
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 14),

              // ── Username ─────────────────────────────────────────────
              _LoginField(
                controller: userController,
                hint: AppStrings.loginUsernameHint,
                icon: Icons.person_outline,
                onSubmitted: (_) => onSubmit(),
              ),
              const SizedBox(height: 12),

              // ── Password ─────────────────────────────────────────────
              _LoginField(
                controller: passController,
                hint: AppStrings.loginPasswordHint,
                icon: Icons.lock_outline,
                obscure: obscure,
                onSubmitted: (_) => onSubmit(),
                suffix: IconButton(
                  splashRadius: 18,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.navy,
                    size: 20,
                  ),
                  onPressed: onToggleObscure,
                ),
              ),
              const SizedBox(height: 12),

              // ── START RACING button ──────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                      side: const BorderSide(color: AppColors.yellow, width: 2),
                    ),
                  ),
                  child: const Text(
                    AppStrings.loginButton,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // ── Demo hint ────────────────────────────────────────────
              Text(
                'Demo: ${AppStrings.demoHint}',
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable outlined field ────────────────────────────────────────────────────

class _LoginField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final ValueChanged<String>? onSubmitted;

  const _LoginField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        onSubmitted: onSubmitted,
        style: const TextStyle(color: AppColors.navy, fontSize: 14),
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.navy.withValues(alpha: 0.5), fontSize: 13),
          prefixIcon: Icon(icon, color: AppColors.navy, size: 20),
          suffixIcon: suffix,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.navy, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.navy, width: 1.8),
          ),
        ),
      ),
    );
  }
}
