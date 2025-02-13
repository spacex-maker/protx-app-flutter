import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'), // English
    const Locale('zh'), // 中文
    const Locale('es'), // Español
    const Locale('fr'), // Français
    const Locale('ar'), // العربية
    const Locale('ru'), // Русский
    const Locale('de'), // Deutsch
    const Locale('ja'), // 日本語
    const Locale('ko'), // 한국어
    const Locale('it'), // Italiano
  ];

  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'zh':
        return '中文';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'ar':
        return 'العربية';
      case 'ru':
        return 'Русский';
      case 'de':
        return 'Deutsch';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'it':
        return 'Italiano';
      default:
        return 'English';
    }
  }

  static String getFlag(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '🇺🇸';
      case 'zh':
        return '🇨🇳';
      case 'es':
        return '🇪🇸';
      case 'fr':
        return '🇫🇷';
      case 'ar':
        return '🇸🇦';
      case 'ru':
        return '🇷🇺';
      case 'de':
        return '🇩🇪';
      case 'ja':
        return '🇯🇵';
      case 'ko':
        return '🇰🇷';
      case 'it':
        return '🇮🇹';
      default:
        return '🇺🇸';
    }
  }
}
