import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import 'package:flutter_frontend/core/models/api_models.dart';
import 'package:flutter_frontend/core/error/api_error_mapper.dart';
import 'package:flutter_frontend/core/services/backend_service.dart';
import 'package:flutter_frontend/core/services/session_service.dart';
import 'package:flutter_frontend/features/auth/presentation/pages/terms_of_use_screen.dart';
import 'package:flutter_frontend/features/patient/presentation/pages/patient_dashboard_screen.dart';
import 'package:flutter_frontend/features/auth/presentation/pages/privacy_security_screen.dart';
import 'package:flutter_frontend/features/auth/presentation/pages/signup_screen.dart';
import 'package:flutter_frontend/features/admin/presentation/pages/admin_portal_screen.dart';
import 'package:flutter_frontend/features/staff/presentation/pages/staff_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final BackendService _backend = BackendService.instance;

  bool _isLoading = false;
  bool _isBiometricLoading = false;
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final identifier = _emailController.text.trim();
    final password = _passwordController.text; // Do NOT trim passwords as spaces can be part of them

    setState(() => _isLoading = true);

    try {
      final auth = await _backend.login(username: identifier, password: password);
      // Store locally for future biometric fast-lane bypass
      await SessionService().saveBiometricCredentials(identifier, password);

      if (!mounted) return;
      _routeByRole(auth);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ApiErrorMapper.toUserMessage(
              error,
              fallbackMessage: 'Unable to sign in right now. Please try again.',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleBiometricLogin() async {
    if (_isLoading || _isBiometricLoading) {
      return;
    }

    setState(() => _isBiometricLoading = true);
    try {
      final LocalAuthentication auth = LocalAuthentication();
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometrics are not available on this device.'),
          ),
        );
        return;
      }

      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Authenticate to sign in to TriageSync',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );

      if (!didAuthenticate) {
        return;
      }

      final creds = await SessionService().getBiometricCredentials();
      if (creds == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No saved biometric credentials found. Sign in once with username and password first.',
            ),
          ),
        );
        return;
      }

      final email = creds['email'];
      final password = creds['password'];
      if (email == null || password == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Saved credentials are incomplete. Please sign in again.',
            ),
          ),
        );
        return;
      }

      _emailController.text = email;
      _passwordController.text = password;
      await _handleLogin();
    } on PlatformException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Biometric sign-in could not be completed. Please try again.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biometric sign-in is currently unavailable.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isBiometricLoading = false);
      }
    }
  }

  void _openFooterPage(String label) {
    Widget destination;
    switch (label) {
      case 'Privacy Policy':
      case 'HIPAA Compliance':
        destination = const PrivacySecurityScreen();
        break;
      case 'Terms of Use':
        destination = const TermsOfUseScreen();
        break;
      default:
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
  }

  void _routeByRole(AuthResponse auth) {
    if (auth.role == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminPortalScreen()),
      );
      return;
    }

    if (auth.role == 'staff' || auth.role == 'nurse' || auth.role == 'doctor') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StaffDashboardScreen()),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PatientDashboardScreen()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF005EB8).withValues(alpha: 0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00478D).withValues(alpha: 0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Container(
                    width: 520,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00478D).withValues(alpha: 0.1),
                          blurRadius: 40,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1C1E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Sign in with your account to continue securely.',
                          style: TextStyle(color: Color(0xFF73777F)),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            hintText: 'Enter your unique username',
                            prefixIcon: Icon(Icons.account_circle_outlined),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Username is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xFF73777F),
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Sign In'),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: OutlinedButton.icon(
                                onPressed: (_isLoading || _isBiometricLoading)
                                    ? null
                                    : () async {
                                        await HapticFeedback.mediumImpact();
                                        await _handleBiometricLogin();
                                      },
                                icon: _isBiometricLoading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.fingerprint,
                                        color: Color(0xFF005EB8),
                                      ),
                                label: const Text(
                                  'Sign In with Biometrics',
                                  style: TextStyle(
                                    color: Color(0xFF005EB8),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: const Color(
                                      0xFF005EB8,
                                    ).withValues(alpha: 0.15),
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignupScreen(),
                                ),
                              );
                            },
                            child: const Text('New here? Create your account'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _footerLink('Privacy Policy'),
                            _footerBullet(),
                            _footerLink('Terms of Use'),
                            _footerBullet(),
                            _footerLink('HIPAA Compliance'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Center(
                          child: Text(
                            'Protected access with enterprise-grade security.',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String label) {
    return InkWell(
      onTap: () {
        _openFooterPage(label);
      },
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF005EB8),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _footerBullet() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text('•', style: TextStyle(color: Colors.grey, fontSize: 10)),
    );
  }
}
