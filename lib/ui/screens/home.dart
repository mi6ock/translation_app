import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translation_app_provider/config/language_code.dart';
import 'package:translation_app_provider/i18n/strings.dart';
import 'package:translation_app_provider/notifier/language_notifier.dart';
import 'package:translation_app_provider/notifier/speech_and_listening_notifier.dart';
import 'package:translation_app_provider/ui/widgets/buttons.dart';
import 'package:translation_app_provider/ui/widgets/dialogs.dart';
import 'package:translation_app_provider/ui/widgets/select_language.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/";

  String listeningLanguage = "";

  Dialogs dialogs = Dialogs();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    var languages = Provider.of<LanguageNotifier>(context);
    var speechAndListening =
        Provider.of<SpeechAndListeningNotifier>(context);

    if (languages.sortedLanguages == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(Strings.of(context).appTitle),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () => dialogs.showExplainDialog(
                  languages.sortedLanguages[1], context),
              icon: Icon(Icons.pan_tool),
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: _textWidget(Colors.white, size,
                      speechAndListening.leftText)),
              Expanded(
                flex: 1,
                child: Builder(builder: (context) {
                  return Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SelectButton(
                        level: speechAndListening
                            .leftSoundLevel,
                        language: LanguageCodes.isoLangs[
                                languages
                                    .sortedLanguages[0]]
                            ['nativeName'],
                        color: speechAndListening.hasSpeech
                            ? Colors.blue.shade400
                            : Colors.grey,

                        /// 音声認識開始
                        onStartListening: () async {
                          if (speechAndListening
                              .hasSpeech) {
                            if (!(await speechAndListening
                                .startListening(
                                    context, true))) {
                              _showSnackBar(context);
                            }
                          }
                        },

                        /// 言語選択
                        onSelectLanguage: () async =>
                            await _navigateAndDisplaySelection(
                                context, true, languages),
                      ),
                      SelectButton(
                        level: speechAndListening
                            .rightSoundLevel,
                        language: LanguageCodes.isoLangs[
                                languages
                                    .sortedLanguages[1]]
                            ['nativeName'],
                        color: speechAndListening.hasSpeech
                            ? Colors.orangeAccent.shade200
                            : Colors.grey,

                        /// 音声認識開始
                        onStartListening: () async {
                          if (speechAndListening
                              .hasSpeech) {
                            if (!(await speechAndListening
                                .startListening(
                                    context, false))) {
                              _showSnackBar(context);
                            }
                          }
                        },

                        /// 言語選択
                        onSelectLanguage: () =>
                            _navigateAndDisplaySelection(
                                context, false, languages),
                      ),
                    ],
                  );
                }),
              ),
              Expanded(
                flex: 3,
                child: _textWidget(
                  Colors.grey.shade300,
                  size,
                  speechAndListening.rightText,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  _navigateAndDisplaySelection(BuildContext context,
      bool isLeft, LanguageNotifier languages) async {
    final result = await Navigator.pushNamed(
      context,
      SelectLanguage.routeName,
    );
    if (result != "")
      await languages.swapLanguage(result, isLeft);
  }

  _showSnackBar(context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(Strings.of(context).notExistModel),
      ),
    );
  }

  _textWidget(color, size, text) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: color,
        elevation: 8,
        child: SizedBox(
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: AutoSizeText(
              text,
              style: TextStyle(fontSize: 30.0),
              maxLines: 8,
            ),
          ),
        ),
      ),
    );
  }
}
