import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translation_app_provider/ui/widgets/dialogs.dart';
import 'package:translation_app_provider/util/translation.dart';

enum AudioState { playing, listening, waiting }

class SpeechAndListeningNotifier extends ChangeNotifier {
  final SpeechToText stt = SpeechToText();
  final FlutterTts tts = FlutterTts();
  final MLTranslation mlTranslation = MLTranslation();

  Dialogs dialogs = Dialogs();

  AudioState audioState = AudioState.waiting;

  /// 音量をUIで表示するため
  double leftSoundLevel = 0;
  double rightSoundLevel = 0;

  bool listeningLeftLang = true;
  List<String> sortedLanguages;
  String listeningLanguage;
  bool hasSpeech = false;

  String leftText = "";
  String rightText = "";

  SpeechAndListeningNotifier();

  Future<void> initListening() async {
    hasSpeech = await stt.initialize(
        onError: errorListener, onStatus: statusListener);
    notifyListeners();
  }

  /// モデルがダウンロードされているか→
  /// どちらの言語を選択したか→
  /// 音声認識開始の処理を行う
  ///
  /// [isLeft]は、どちらの言語を選択されているかのフラグ
  Future<bool> startListening(context, isLeft) async {
    var leftIsFetched =
        await MLTranslation.checkModel(sortedLanguages[0]);
    var rightIsFetched =
        await MLTranslation.checkModel(sortedLanguages[1]);

    String languageCode;
    if (isLeft) {
      languageCode = sortedLanguages[0];
    } else {
      languageCode = sortedLanguages[1];
    }

    if (leftIsFetched && rightIsFetched) {
      if (audioState == AudioState.playing) {
        await stopSpeech();
      }
      if (audioState == AudioState.listening) {
        stopListening();
      }

      listeningLeftLang = isLeft;

      stt.listen(
          onResult: resultListener,
          listenFor: Duration(seconds: 15),
          localeId: languageCode,
          onSoundLevelChange: soundLevelListener);

      audioState = AudioState.listening;
      listeningLanguage = languageCode;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<void> stopListening() async {
    await stt.stop();
    leftSoundLevel = 0;
    rightSoundLevel = 0;
    notifyListeners();
  }

  Future<void> cancelListening() async {
    await stt.cancel();
    leftSoundLevel = 0;
    rightSoundLevel = 0;
    notifyListeners();
  }

  void resultListener(
      SpeechRecognitionResult result) async {
    String translated;
    if (result.recognizedWords != null &&
        result.finalResult) {
      if (sortedLanguages[0] == listeningLanguage) {
        mlTranslation.init(
            sortedLanguages[0], sortedLanguages[1]);
        translated = await mlTranslation
            .translation(result.recognizedWords);
        leftText =
            "${result.recognizedWords}\n\n$translated";
        await stopListening;
        startSpeech(translated, sortedLanguages[1]);
      } else {
        mlTranslation.init(
            sortedLanguages[1], sortedLanguages[0]);
        translated = await mlTranslation
            .translation(result.recognizedWords);
        rightText =
            "${result.recognizedWords}\n\n$translated";
        await stopListening;
        startSpeech(translated, sortedLanguages[0]);
      }
      audioState = AudioState.waiting;
      notifyListeners();
    }
  }

  void soundLevelListener(double level) {
    if (listeningLeftLang) {
      leftSoundLevel = level;
    } else {
      rightSoundLevel = level;
    }
    notifyListeners();
  }

  void errorListener(SpeechRecognitionError error) {
    audioState = AudioState.waiting;
    notifyListeners();
  }

  void statusListener(String status) {}

  Future startSpeech(word, lang) async {
    if (audioState == AudioState.playing) {
      await stopSpeech();
    }
    if (audioState == AudioState.listening) {
      stopListening();
    }

    tts.setLanguage(lang);
    var result = await tts.speak(word);
    if (result == 1) audioState = AudioState.playing;
    notifyListeners();
  }

  Future stopSpeech() async {
    var result = await tts.stop();
    if (result == 1) audioState = AudioState.waiting;
    notifyListeners();
  }
}
