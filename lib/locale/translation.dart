import 'dart:async';

import 'package:flutter/material.dart';
import 'package:way_to_work/locale/translation_strings.dart';

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fi', 'et', 'ru'].contains(locale.languageCode);

  @override
  Future<Translations> load(Locale locale) => Translations.load(locale);

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}
