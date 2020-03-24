import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:translation_app_provider/i18n/strings.dart';
import 'package:translation_app_provider/notifier/language_notifier.dart';
import 'package:translation_app_provider/notifier/speech_and_listening_notifier.dart';
import 'package:translation_app_provider/ui/screens/home.dart';
import 'package:translation_app_provider/ui/widgets/select_language.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageNotifier>(
          create: (context) {
            var language = LanguageNotifier(context);
            language.init();
            return language;
          },
        ),
        ChangeNotifierProxyProvider<LanguageNotifier,
            SpeechAndListeningNotifier>(
          create: (context) {
            var speechAndListeningNotifier =
                SpeechAndListeningNotifier();
            speechAndListeningNotifier.initListening();
            return speechAndListeningNotifier;
          },
          update: (context, language, speechModel) =>
              speechModel
                ..sortedLanguages =
                    language.sortedLanguages,
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        Locale('en', ''),
        Locale('ja', ''),
      ],
      localizationsDelegates: [
        _MyLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      initialRoute: HomeScreen.routeName,

      /// routesは、fullscreenDialogのような引数を渡せないので
      /// onGenerateRouteを使用
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case HomeScreen.routeName:
            return MaterialPageRoute(
              builder: (context) => HomeScreen(),
            );
            break;
          case SelectLanguage.routeName:
            return MaterialPageRoute(
              builder: (context) => SelectLanguage(),
              fullscreenDialog: true,
            );
          default:
            return MaterialPageRoute(
              builder: (context) => HomeScreen(),
            );
        }
      },
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
    );
  }
}

class _MyLocalizationsDelegate
    extends LocalizationsDelegate<Strings> {
  const _MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ja'].contains(locale.languageCode);

  @override
  Future<Strings> load(Locale locale) =>
      Strings.load(locale);

  @override
  bool shouldReload(_MyLocalizationsDelegate old) => false;
}
