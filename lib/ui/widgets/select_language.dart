import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translation_app_provider/i18n/strings.dart';
import 'package:translation_app_provider/notifier/language_notifier.dart';
import 'package:translation_app_provider/ui/widgets/model_list_item.dart';
import 'package:translation_app_provider/util/translation.dart';

class SelectLanguage extends StatelessWidget {
  static const routeName = "/select_language";
  String lang = "";

  @override
  Widget build(BuildContext context) {
    var languages = Provider.of<LanguageNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Strings.of(context).chooseLanguage,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(
            context,
            lang,
          ),
          icon: Icon(Icons.close),
        ),
      ),

      /// FutureBuilderを使うことで、Future関数の戻り値の
      /// 読み込みを検知
      body: FutureBuilder<List<Widget>>(
        future: _buildModelList(languages.sortedLanguages),
        builder: (context, snapshot) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10),
            child: ListView(
              children: <Widget>[
                _buildTitle(context),
                if (snapshot.hasData)
                  ...snapshot.data
                else
                  Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Text(
        Strings.of(context).languages,
      ),
    );
  }

  Future<List<Widget>> _buildModelList(
      List<String> models) async {
    Widget divider = Divider(
      color: Colors.grey,
    );
    List<Widget> widgets = [];
    for (int index = 0; index < models.length; index++) {
      bool isFetched = await MLTranslation.checkModel(
          models.elementAt(index));
      widgets.add(
        SelectModelListItem(
          languageCode: models.elementAt(index),
          // 言語コードリストの上位2要素は選択されている
          // 状態なので以下の処理でチェックマークを付与
          isSelected: index < 2,
          modelState: isFetched
              ? ModelState.exist
              : ModelState.notExist,
        ),
      );
      widgets.add(divider);
    }

    return widgets;
  }
}
