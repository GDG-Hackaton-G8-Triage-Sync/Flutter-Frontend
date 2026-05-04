import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_frontend/core/config/api_config.dart';
import 'package:flutter_frontend/core/models/api_models.dart';
import 'package:flutter_frontend/core/services/backend_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.initialProfile});

  final PatientProfile initialProfile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final BackendService _backend = BackendService.instance;
  final ImagePicker _imagePicker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _ageController;
  late final TextEditingController _genderController;
  late final TextEditingController _bloodTypeController;
  late final TextEditingController _healthHistoryController;
  late final TextEditingController _allergiesController;
  late final TextEditingController _medicationsController;
  late final TextEditingController _lifestyleHabitsController;

  Uint8List? _profilePhotoBytes;
  String? _profilePhotoName;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = widget.initialProfile;
    _nameController = TextEditingController(text: profile.name);
    _emailController = TextEditingController(text: profile.email);
    _ageController = TextEditingController(text: profile.age?.toString() ?? '');
    _genderController = TextEditingController(text: profile.gender ?? '');
    _bloodTypeController = TextEditingController(text: profile.bloodType ?? '');
    _healthHistoryController = TextEditingController(
      text: profile.healthHistory ?? '',
    );
    _allergiesController = TextEditingController(text: profile.allergies ?? '');
    _medicationsController = TextEditingController(
      text: profile.medications ?? '',
    );
    _lifestyleHabitsController = TextEditingController(
      text: profile.lifestyleHabits ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _bloodTypeController.dispose();
    _healthHistoryController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    _lifestyleHabitsController.dispose();
    super.dispose();
  }

  Future<void> _pickProfilePhoto() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image == null) return;

    final bytes = await image.readAsBytes();
    if (!mounted) return;

    setState(() {
      _profilePhotoBytes = bytes;
      _profilePhotoName = image.name;
    });
  }

  void _clearProfilePhotoSelection() {
    setState(() {
      _profilePhotoBytes = null;
      _profilePhotoName = null;
    });
  }

  Future<void> _saveProfile() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final updated = await _backend.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        age: int.tryParse(_ageController.text.trim()),
        gender: _genderController.text.trim().isEmpty
            ? null
            : _genderController.text.trim(),
        bloodType: _bloodTypeController.text.trim().isEmpty
            ? null
            : _bloodTypeController.text.trim(),
        healthHistory: _healthHistoryController.text.trim().isEmpty
            ? null
            : _healthHistoryController.text.trim(),
        allergies: _allergiesController.text.trim().isEmpty
            ? null
            : _allergiesController.text.trim(),
        medications: _medicationsController.text.trim().isEmpty
            ? null
            : _medicationsController.text.trim(),
        lifestyleHabits: _lifestyleHabitsController.text.trim().isEmpty
            ? null
            : _lifestyleHabitsController.text.trim(),
        profilePhotoBytes: _profilePhotoBytes,
        profilePhotoName: _profilePhotoName,
      );

      if (!mounted) return;
      Navigator.pop<Map<String, String>>(context, updated);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile. Try again.')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FB),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w800,
            color: Color(0xFF00478D),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  final v = (value ?? '').trim();
                  if (v.isEmpty) return 'Name is required';
                  if (v.length < 2) return 'Name is too short';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  final v = (value ?? '').trim();
                  if (v.isEmpty) return 'Email is required';
                  if (!v.contains('@') || !v.contains('.')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age (optional)',
                  prefixIcon: Icon(Icons.cake_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _genderController,
                decoration: const InputDecoration(
                  labelText: 'Gender (optional)',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bloodTypeController,
                decoration: const InputDecoration(
                  labelText: 'Blood Type (optional)',
                  prefixIcon: Icon(Icons.bloodtype_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _healthHistoryController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Health History (optional)',
                  prefixIcon: Icon(Icons.medical_information_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _allergiesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Allergies (optional)',
                  prefixIcon: Icon(Icons.warning_amber_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _medicationsController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Medications (optional)',
                  prefixIcon: Icon(Icons.medication_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lifestyleHabitsController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Lifestyle Habits (optional)',
                  prefixIcon: Icon(Icons.self_improvement_outlined),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F9FB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDDE4F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profile Photo',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPhotoPreview(),
                    const SizedBox(height: 8),
                    Text(
                      _profilePhotoName ??
                          widget.initialProfile.profilePhotoName ??
                          'No photo selected',
                      style: const TextStyle(color: Color(0xFF4A4F57)),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _pickProfilePhoto,
                          icon: const Icon(Icons.upload_file_outlined),
                          label: const Text('Choose Photo'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _clearProfilePhotoSelection,
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Clear Selection'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveProfile,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPreview() {
    final profile = widget.initialProfile;
    if (_profilePhotoBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          _profilePhotoBytes!,
          height: 140,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    final photoUrl = profile.profilePhotoUrl?.trim();
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          photoUrl.startsWith('http://') ||
                  photoUrl.startsWith('https://') ||
                  photoUrl.startsWith('data:') ||
                  photoUrl.startsWith('blob:')
              ? photoUrl
              : photoUrl.startsWith('/')
              ? '${ApiConfig.baseUrl}$photoUrl'
              : '${ApiConfig.baseUrl}/$photoUrl',
          height: 140,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPhotoPlaceholder();
          },
        ),
      );
    }

    return _buildPhotoPlaceholder();
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      height: 140,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE4F0)),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 32, color: Color(0xFF005EB8)),
          SizedBox(height: 8),
          Text(
            'No profile photo available',
            style: TextStyle(color: Color(0xFF4A4F57)),
          ),
        ],
      ),
    );
  }
}
