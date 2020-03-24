import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translation_app_provider/config/language_code.dart';
import 'package:translation_app_provider/config/preference_key.dart';

class LanguageNotifier extends ChangeNotifier {
  List<String> sortedLanguages;

  final BuildContext context;

  LanguageNotifier(this.context);

  /// sharedPreferencesからソートされている言語コードを読み込む
  ///
  /// 保存されていなかった場合は空の配列を使う
  init() async {
    SharedPreferences preferences =
        await SharedPreferences.getInstance();
    sortedLanguages = preferences
            .getStringList(PreferenceKey.languageKey) ??
        [];
    if (sortedLanguages.isEmpty) {
      sortedLanguages = LanguageCodes.bcp47;
      preferences.setStringList(
          PreferenceKey.languageKey, LanguageCodes.bcp47);
    }
    notifyListeners();
  }

  /// 言語コードの順番を入れ替える
  ///
  /// 入れ替える必要がなければ、入れ替わらない
  ///
  /// [languageCode]を[isLeft]がtrueであれば1番目に、
  /// falseであれば2番目に格納する
  ///
  /// A　Bの状態で、BにAをセットすると入れ替わる
  swapLanguage(String languageCode, bool isLeft) async {
    SharedPreferences preferences =
        await SharedPreferences.getInstance();
    sortedLanguages = preferences
        .getStringList(PreferenceKey.languageKey);
    int indexMyLocale =
        sortedLanguages.indexOf(languageCode);
    if (isLeft) {
      if (languageCode == sortedLanguages[0]) {
        return;
      }

      if (languageCode == sortedLanguages[1]) {
        sortedLanguages.insert(
            0, sortedLanguages.removeAt(indexMyLocale));
      } else {
        sortedLanguages.insert(
            0, sortedLanguages.removeAt(indexMyLocale));
        sortedLanguages.insert(
            2, sortedLanguages.removeAt(1));
      }
    } else {
      sortedLanguages.insert(
          1, sortedLanguages.removeAt(indexMyLocale));
    }
    await preferences.setStringList(
        PreferenceKey.languageKey, sortedLanguages);
    notifyListeners();
  }
}
