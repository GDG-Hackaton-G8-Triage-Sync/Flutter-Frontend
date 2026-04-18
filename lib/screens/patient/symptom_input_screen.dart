import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../services/backend_service.dart';
import 'success_screen.dart';

class SymptomInputScreen extends StatefulWidget {
  const SymptomInputScreen({super.key, this.onSubmitted});

  final VoidCallback? onSubmitted;

  @override
  State<SymptomInputScreen> createState() => _SymptomInputScreenState();
}

class _SymptomInputScreenState extends State<SymptomInputScreen> {
  static const int _maxChars = 500;

  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final BackendService _backend = BackendService.instance;

  XFile? _attachedImage;
  bool _isSubmitting = false;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      _speechEnabled = await _speech.initialize(
        onStatus: (status) => debugPrint('STT Status: $status'),
        onError: (error) => debugPrint('STT Error: $error'),
      );
    } catch (_) {
      _speechEnabled = false;
    }
    setState(() {});
  }

  void _listenToggle() async {
    if (!_isListening) {
      if (_speechEnabled) {
        setState(() => _isListening = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listening... speak now. (Native SDK)')),
        );
        await _speech.listen(
          onResult: (val) {
            setState(() {
              _controller.text = val.recognizedWords;
            });
          },
        );
      } else {
        // Fallback for emulators testing without hardware mic configs
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Simulating Spanish speech block for translation demo...',
            ),
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          setState(() {
            _controller.text =
                "Tengo un dolor muy fuerte en el pecho que comenzó hace una hora. Me cuesta respirar.";
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      await _speech.stop();
    }
  }

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file == null) return;

    setState(() {
      _attachedImage = file;
    });
  }

  Future<void> _submit() async {
    final description = _controller.text.trim();
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe your symptoms before submitting.'),
        ),
      );
      return;
    }

    if (description.length > _maxChars) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Description cannot exceed 500 characters.'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _backend.submitSymptoms(
        description: description,
        photoName: _attachedImage?.name,
      );

      if (!mounted) return;

      _controller.clear();
      setState(() => _attachedImage = null);

      // Track whether the user already triggered the callback from SuccessScreen
      bool callbackFired = false;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SuccessScreen(
            onViewStatus: () {
              callbackFired = true;
              Navigator.pop(context);
              widget.onSubmitted?.call();
            },
          ),
        ),
      );

      // If user pressed back instead of "View My Status", still trigger callback
      if (!callbackFired) widget.onSubmitted?.call();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Submission failed. Check backend and try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final count = _controller.text.length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFDAD6).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFFDAD6)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.emergency, color: Color(0xFFBA1A1A), size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "In an emergency, call 911 or your local emergency services immediately.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFBA1A1A),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'How are you feeling right now?',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Color(0xFF00478D),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Describe your symptoms in your own words. Our triage system will prioritize your case.',
          style: TextStyle(fontSize: 14, color: Color(0xFF44474E), height: 1.5),
        ),
        const SizedBox(height: 18),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  maxLength: _maxChars,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    counterText: '',
                    hintText:
                        'Example: Chest pain and sweating for 30 minutes.',
                    border: InputBorder.none,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const Divider(height: 1),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$count / $_maxChars characters',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF005EB8,
                            ).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: _listenToggle,
                            icon: Icon(
                              _isListening ? Icons.mic : Icons.mic_none,
                              color: _isListening
                                  ? const Color(0xFFBA1A1A)
                                  : const Color(0xFF005EB8),
                            ),
                            tooltip: 'Voice Input',
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.attach_file),
                          label: const Text('Attach Photo'),
                        ),
                      ],
                    ),
                  ],
                ),
                if (_attachedImage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F0FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.photo,
                            color: Color(0xFF005EB8),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _attachedImage!.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              setState(() => _attachedImage = null),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Card(
          child: ListTile(
            leading: const Icon(Icons.lightbulb_outline),
            title: const Text('Helpful tip'),
            subtitle: const Text(
              'Mention when symptoms started and what makes them worse or better.',
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _isSubmitting ? null : _submit,
            icon: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send),
            label: Text(_isSubmitting ? 'Submitting...' : 'Submit for Triage'),
          ),
        ),
      ],
    );
  }
}
