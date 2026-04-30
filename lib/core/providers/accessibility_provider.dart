import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilityState {
  final bool largeText;
  final bool highContrast;
  final bool reduceMotion;
  final String language;

  AccessibilityState({
    this.largeText = false,
    this.highContrast = false,
    this.reduceMotion = false,
    this.language = 'English',
  });

  AccessibilityState copyWith({
    bool? largeText,
    bool? highContrast,
    bool? reduceMotion,
    String? language,
  }) {
    return AccessibilityState(
      largeText: largeText ?? this.largeText,
      highContrast: highContrast ?? this.highContrast,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      language: language ?? this.language,
    );
  }
}

class AccessibilityNotifier extends StateNotifier<AccessibilityState> {
  AccessibilityNotifier() : super(AccessibilityState()) {
    _loadSettings();
  }

  static const _largeTextKey = 'accessibility_large_text';
  static const _highContrastKey = 'accessibility_high_contrast';
  static const _reduceMotionKey = 'accessibility_reduce_motion';
  static const _languageKey = 'accessibility_language';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(
      largeText: prefs.getBool(_largeTextKey) ?? false,
      highContrast: prefs.getBool(_highContrastKey) ?? false,
      reduceMotion: prefs.getBool(_reduceMotionKey) ?? false,
      language: prefs.getString(_languageKey) ?? 'English',
    );
  }

  Future<void> setLargeText(bool value) async {
    state = state.copyWith(largeText: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_largeTextKey, value);
  }

  Future<void> setHighContrast(bool value) async {
    state = state.copyWith(highContrast: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_highContrastKey, value);
  }

  Future<void> setReduceMotion(bool value) async {
    state = state.copyWith(reduceMotion: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reduceMotionKey, value);
  }

  Future<void> setLanguage(String value) async {
    state = state.copyWith(language: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, value);
  }
}

final accessibilityProvider =
    StateNotifierProvider<AccessibilityNotifier, AccessibilityState>((ref) {
  return AccessibilityNotifier();
});
