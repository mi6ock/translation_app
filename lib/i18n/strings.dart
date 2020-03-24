import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:translation_app_provider/i18n/messages_all.dart';

/// 多言語化で使うクラス
///
/// [load]やスタティックメソッドはほぼ決まり切ったコードになっている
///
class Strings {
  static Future<Strings> load(Locale locale) {
    final String name = locale.countryCode.isEmpty
        ? locale.languageCode
        : locale.toString();
    final String localeName =
        Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return Strings();
    });
  }

  static Strings of(BuildContext context) {
    return Localizations.of<Strings>(context, Strings);
  }

  static final Strings instance = Strings();

  /// ここから多言語化したい文字列を追加していく

  String get aboutDialogFooter => Intl.message(
      "We\'ll take turns talking and "
      "listening to translations in the phone.",
      name: "aboutDialogFooter");

  String get aboutDialogHeader =>
      Intl.message("Show this to other person.",
          name: "aboutDialogHeader");

  String get appTitle =>
      Intl.message("Translator", name: "appTitle");

  String get chooseLanguage =>
      Intl.message('Languages', name: 'chooseLanguage');

  String get languages =>
      Intl.message('Languages', name: 'languages');

  String get notExistModel =>
      Intl.message('Not enough data for translation',
          name: 'notExistModel');

  String get download =>
      Intl.message('Download', name: 'download');

  String get close => Intl.message('Close', name: 'close');

  String languageString(String languageCode) => Intl.select(
        languageCode,
        {
          'af': 'Afrikaans',
          'ar': 'Arabic',
          'be': 'Belarusian',
          'bg': 'Bulgarian',
          'bn': 'Bengali',
          'ca': 'Catalan',
          'cs': 'Czech',
          'cy': 'Welsh',
          'da': 'Danish',
          'de': 'German',
          'el': 'Greek',
          'en': 'English',
          'eo': 'Esperanto',
          'es': 'Spanish',
          'et': 'Estonian',
          'fa': 'Persian',
          'fi': 'Finnish',
          'fr': 'French',
          'ga': 'Irish',
          'gl': 'Galician',
          'gu': 'Gujarati',
          'he': 'Hebrew',
          'hi': 'Hindi',
          'hr': 'Croatian',
          'ht': 'Haitian',
          'hu': 'Hungarian',
          'id': 'Indonesian',
          'is': 'Icelandic',
          'it': 'Italian',
          'ja': 'Japanese',
          'ka': 'Georgian',
          'kn': 'Kannada',
          'ko': 'Korean',
          'lt': 'Lithuanian',
          'lv': 'Latvian',
          'mk': 'Macedonian',
          'mr': 'Marathi',
          'ms': 'Malay',
          'mt': 'Maltese',
          'nl': 'Dutch',
          'no': 'Norwegian',
          'pl': 'Polish',
          'pt': 'Portuguese',
          'ro': 'Romanian',
          'ru': 'Russian',
          'sk': 'Slovak',
          'sl': 'Slovenian',
          'sq': 'Albanian',
          'sv': 'Swedish',
          'sw': 'Swahili',
          'ta': 'Tamil',
          'te': 'Telugu',
          'th': 'Thai',
          'tl': 'Tagalog',
          'tr': 'Turkish',
          'uk': 'Ukrainian',
          'ur': 'Urdu',
          'vi': 'Vietnamese',
          'zh': 'Chinese',
          'ot': ''
        },
        name: "languageString",
        args: [languageCode],
      );
}
