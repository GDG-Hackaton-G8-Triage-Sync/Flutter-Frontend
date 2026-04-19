import 'dart:ui';

import 'package:flutter/material.dart';

import '../../services/api_error_mapper.dart';
import '../../services/backend_service.dart';
import '../common/terms_of_use_screen.dart';
import '../login_screen.dart';
import 'privacy_security_screen.dart';

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
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Step 2: Demographics
  String? _gender;
  final TextEditingController _ageController = TextEditingController();

  // Step 3: Clinical
  String? _bloodType;
  final TextEditingController _historyController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();

  final BackendService _backend = BackendService.instance;
  bool _isLoading = false;
  bool _obscurePassword = true;

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
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (!_formKey.currentState!.validate()) return;
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }
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
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful. Please sign in.')),
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
              fallbackMessage: 'Unable to complete registration. Please try again.',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: Stack(
        children: [
          _buildBackgroundDecor(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  width: 580,
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
                    ? 'Create Account'
                    : _currentStep == 1
                        ? 'Demographics'
                        : 'Medical Background',
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
        const Padding(
          padding: EdgeInsets.only(left: 48, top: 4),
          child: Text(
            'Complete your medical profile to help our clinical team.',
            style: TextStyle(color: Color(0xFF73777F), fontSize: 13),
          ),
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

  Widget _buildAccountStep() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            prefixIcon: Icon(Icons.person_outline),
          ),
          validator: (v) => v?.isEmpty == true ? 'Name is required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            prefixIcon: Icon(Icons.email_outlined),
          ),
          validator: (v) {
            if (v?.isEmpty == true) return 'Email is required';
            if (v?.contains('@') == false) return 'Enter a valid email';
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Create Password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          validator: (v) => (v?.length ?? 0) < 6 ? 'Min 6 characters' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscurePassword,
          decoration: const InputDecoration(
            labelText: 'Confirm Password',
            prefixIcon: Icon(Icons.lock_reset),
          ),
        ),
      ],
    );
  }

  Widget _buildDemographicsStep() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _gender,
          decoration: const InputDecoration(
            labelText: 'Gender',
            prefixIcon: Icon(Icons.people_outline),
          ),
          items: ['Male', 'Female', 'Other', 'Prefer not to say']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _gender = v),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _ageController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Age',
            prefixIcon: Icon(Icons.calendar_today_outlined),
          ),
        ),
      ],
    );
  }

  Widget _buildClinicalStep() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _bloodType,
          decoration: const InputDecoration(
            labelText: 'Blood Type (Optional)',
            hintText: 'Select if known',
            prefixIcon: Icon(Icons.bloodtype_outlined),
          ),
          items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _bloodType = v),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _historyController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Medical History',
            hintText: 'e.g. Hypertension, Diabetes, Asthma',
            prefixIcon: Icon(Icons.history_edu_outlined),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _allergiesController,
          decoration: const InputDecoration(
            labelText: 'Known Allergies',
            hintText: 'e.g. Penicillin, Peanuts',
            prefixIcon: Icon(Icons.warning_amber_outlined),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _medicationsController,
          decoration: const InputDecoration(
            labelText: 'Current Medications',
            hintText: 'List any regular medications',
            prefixIcon: Icon(Icons.medication_outlined),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: _isLoading
            ? null
            : (_currentStep == 2 ? _handleSignup : _nextStep),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
              )
            : Text(_currentStep == 2 ? 'Complete Registration' : 'Continue'),
      ),
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
