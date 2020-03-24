import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';

class MLTranslation {
  LanguageTranslator languageTranslator;
  void init(from, to) {
    languageTranslator = FirebaseLanguage.instance
        .languageTranslator(from, to);
  }

  Future<String> translation(String text) async {
    return languageTranslator != null
        ? (await languageTranslator.processText(text))
        : "";
  }

  /// 以下二つの返り値は言語コード
  static Future<String> downloadModel(language) async {
    final ModelManager modelManager =
        FirebaseLanguage.instance.modelManager();
    var model = modelManager.downloadModel(language);
    var res = await model;
    return res;
  }

  static Future<String> deleteModel(language) async {
    final ModelManager modelManager =
        FirebaseLanguage.instance.modelManager();
    var model = modelManager.deleteModel(language);
    var res = await model;
    return res;
  }

  /// ダウンロードされている言語モデルリスト(List<String>)を取得して、
  /// [language]と一致すればtrueを返す
  static Future<bool> checkModel(language) async {
    final ModelManager modelManager =
        FirebaseLanguage.instance.modelManager();
    var model = modelManager.viewModels();
    var res = await model;
    for (var mod in res) {
      if (mod == language) {
        return true;
      }
    }
    return false;
  }
}
