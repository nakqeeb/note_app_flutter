import 'package:flutter/material.dart';

import '../core/l10n/l18n.dart';
import '../services/locale_prefs.dart';

class LocaleNotifier extends ChangeNotifier {
  Locale? _locale;
  LocalePrefs localPrefs = LocalePrefs();

  bool get isArabic => _locale == const Locale('ar');

  Locale? get locale => _locale;

  set setLocal(String value) {
    _locale = Locale(value);
    localPrefs.setLocal(value);
    notifyListeners();
  }

  void setLanguage(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
}
