import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:translation_app_provider/i18n/strings.dart';
import 'package:translation_app_provider/util/translation.dart';

class Dialogs {
  final MLTranslation _translation = MLTranslation();

  /// 相手に相手の言語でこのアプリの説明を表示するダイアログ
  ///
  /// このアプリの説明を[languageCode]を元にML Kitで翻訳して表示する
  void showExplainDialog(languageCode, context) async {
    String body;

    if (await MLTranslation.checkModel(languageCode)) {
      _translation.init("en", languageCode);
      body = await _translation.translation(
          "We\'ll take turns talking and listening "
          "to translations in the phone.");
    } else {
      body = "We\'ll take turns talking and listening to "
          "translations in the phone.\n## Displayed "
          "in English because no model exists. ##";
    }

    showDialog(
        context: context,
        builder: (BuildContext context) =>
            _explainDialog(context, body));
  }

  Dialog _explainDialog(context, body) {
    final Size size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)),
      //this right here
      child: SizedBox(
        height: size.height * 0.6,
        width: size.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: AutoSizeText(
                    Strings.of(context).aboutDialogHeader),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    body,
                    style:
                        Theme.of(context).textTheme.title,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: AutoSizeText(
                    Strings.of(context).aboutDialogFooter),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
