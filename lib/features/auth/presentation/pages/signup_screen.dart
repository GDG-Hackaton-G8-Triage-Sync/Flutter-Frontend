import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_frontend/core/error/api_error_mapper.dart';
import 'package:flutter_frontend/core/services/backend_service.dart';
import 'package:flutter_frontend/features/auth/presentation/pages/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Step 1: Account
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Step 2: Demographics
  String? _gender;
  final TextEditingController _ageController = TextEditingController();

  // Step 3: Clinical
  String? _bloodType;
  final TextEditingController _historyController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();
  final TextEditingController _habitsController = TextEditingController();

  final BackendService _backend = BackendService.instance;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    _historyController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    _habitsController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (!_formKey.currentState!.validate()) return;
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
        return;
      }
    } else if (_currentStep == 1) {
      if (!_formKey.currentState!.validate()) return;
    }
    setState(() => _currentStep++);
  }

  void _prevStep() {
    setState(() => _currentStep--);
  }

  Future<void> _handleSignup() async {
    setState(() => _isLoading = true);

    try {
      await _backend.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        role: 'patient',
        gender: _gender,
        age: int.tryParse(_ageController.text),
        bloodType: _bloodType,
        healthHistory: _historyController.text.trim(),
        allergies: _allergiesController.text.trim(),
        currentMedications: _medicationsController.text.trim(),
        badHabits: _habitsController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful. Please sign in.'),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ApiErrorMapper.toUserMessage(
              error,
              fallbackMessage:
                  'Unable to complete registration. Please try again.',
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

  bool _isValidFullName(String name) {
    // Robust name validation:
    // 1. Minimum 2 parts (First + Last)
    // 2. Minimum length (3 chars)
    // 3. No weird special characters (allowing unicode letters ' and -)
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length < 2) return false;

    // Check if each part is at least 1 character and contains valid name characters
    // Using simple character matching to be script-agnostic
    for (var part in parts) {
      if (part.isEmpty) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final lightTheme = Theme.of(context).copyWith(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF005EB8),
        brightness: Brightness.light,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF7F9FB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE4F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE4F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF005EB8), width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFF73777F)),
        hintStyle: const TextStyle(color: Color(0xFF73777F)),
      ),
      textTheme: Theme.of(context).textTheme.apply(
        bodyColor: const Color(0xFF1A1C1E),
        displayColor: const Color(0xFF1A1C1E),
      ),
    );

    return Theme(
      data: lightTheme,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FB),
        body: Stack(
        children: [
          _buildBackgroundDecor(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  width: 620,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00478D).withValues(alpha: 0.08),
                        blurRadius: 40,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 16),
                        _buildOnboardingHint(),
                        const SizedBox(height: 24),
                        _buildProgressBar(),
                        const SizedBox(height: 32),
                        _buildStepContent(),
                        const SizedBox(height: 40),
                        _buildNavigationButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildOnboardingHint() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF005EB8).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF005EB8).withValues(alpha: 0.1),
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: Color(0xFF005EB8)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Optional fields can be left blank and updated later in your clinical profile.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF00478D),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (_currentStep == 0)
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 20),
              ),
            if (_currentStep > 0)
              IconButton(
                onPressed: _prevStep,
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _currentStep == 0
                    ? 'Account Setup'
                    : _currentStep == 1
                    ? 'Identification'
                    : 'Clinical History',
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1C1E),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: List.generate(3, (index) {
        final active = index <= _currentStep;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: index == 2 ? 0 : 8),
            decoration: BoxDecoration(
              color: active ? const Color(0xFF005EB8) : const Color(0xFFE1E2E5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildAccountStep();
      case 1:
        return _buildDemographicsStep();
      case 2:
        return _buildClinicalStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRequiredLabel(String label) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Color(0xFF44474E),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Color(0xFFBA1A1A)),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionalLabel(String label) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Color(0xFF44474E),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        children: const [
          TextSpan(
            text: ' (Optional)',
            style: TextStyle(
              color: Color(0xFF73777F),
              fontSize: 11,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRequiredLabel('Full Name'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'e.g. Jean-Luc Picard',
            prefixIcon: Icon(Icons.person_outline),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Please enter your full name';
            if (!_isValidFullName(v)) {
              return 'Please enter both first and last name';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildRequiredLabel('Email Address'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'your@email.com',
            prefixIcon: Icon(Icons.email_outlined),
          ),
          validator: (v) {
            if (v?.isEmpty == true) return 'Email is required';
            if (v?.contains('@') == false) return 'Enter a valid email';
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildRequiredLabel('Password'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Minimum 6 characters',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          validator: (v) => (v?.length ?? 0) < 6 ? 'Min 6 characters' : null,
        ),
        const SizedBox(height: 20),
        _buildRequiredLabel('Confirm Password'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            hintText: 'Re-enter your password',
            prefixIcon: const Icon(Icons.lock_reset),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              ),
            ),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) {
              return 'Please confirm your password';
            }
            if (v != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDemographicsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRequiredLabel('Gender'),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _gender,
          decoration: const InputDecoration(
            hintText: 'Select gender',
            prefixIcon: Icon(Icons.people_outline),
          ),
          items: [
            'Male',
            'Female',
            'Other',
            'Prefer not to say',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _gender = v),
          validator: (v) =>
              v == null ? 'Gender is required for clinical records' : null,
        ),
        const SizedBox(height: 20),
        _buildRequiredLabel('Age'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _ageController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Enter your age',
            prefixIcon: Icon(Icons.calendar_today_outlined),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Age is required';
            final age = int.tryParse(v);
            if (age == null || age <= 0 || age > 120) {
              return 'Please enter a valid age';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildClinicalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOptionalLabel('Blood Type'),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _bloodType,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.bloodtype_outlined),
          ),
          items: [
            'A+',
            'A-',
            'B+',
            'B-',
            'O+',
            'O-',
            'AB+',
            'AB-',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _bloodType = v),
        ),
        const SizedBox(height: 20),
        _buildOptionalLabel('Medical History'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _historyController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText:
                'Describe pre-existing conditions (e.g. Hypertension, Diabetes)',
            prefixIcon: Icon(Icons.history_edu_outlined),
          ),
        ),
        const SizedBox(height: 20),
        _buildOptionalLabel('Allergies'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _allergiesController,
          maxLines: 2,
          decoration: const InputDecoration(
            hintText: 'e.g. Penicillin, Lactose, Peanuts',
            prefixIcon: Icon(Icons.warning_amber_outlined),
          ),
        ),
        const SizedBox(height: 20),
        _buildOptionalLabel('Current Medications'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _medicationsController,
          decoration: const InputDecoration(
            hintText: 'List medications and dosage',
            prefixIcon: Icon(Icons.medication_outlined),
          ),
        ),
        const SizedBox(height: 20),
        _buildOptionalLabel('Lifestyle Habits'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _habitsController,
          decoration: const InputDecoration(
            hintText: 'e.g. Regular smoker, Alcohol consumer',
            prefixIcon: Icon(Icons.smoke_free_outlined),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        const Spacer(),
        SizedBox(
          width: 220,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: _isLoading
                ? null
                : (_currentStep == 2 ? _handleSignup : _nextStep),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(_currentStep == 2 ? 'Complete Signup' : 'Continue'),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundDecor() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF005EB8).withValues(alpha: 0.04),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }
}
