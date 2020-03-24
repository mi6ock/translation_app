import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:translation_app_provider/i18n/strings.dart';
import 'package:translation_app_provider/util/translation.dart';

enum ModelState { notExist, changing, exist }

class SelectModelListItem extends StatefulWidget {
  final String languageCode;
  ModelState modelState;
  final bool isSelected;

  SelectModelListItem(
      {Key key, this.languageCode, this.modelState, this.isSelected})
      : super(key: key);

  @override
  _SelectModelListItemState createState() => _SelectModelListItemState();
}

class _SelectModelListItemState extends State<SelectModelListItem> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () => _rowTap(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 32,
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 60,
                      child: widget.isSelected ? Icon(Icons.check) : SizedBox(),
                    ),
                    Text(
                      Strings.of(context).languageString(widget.languageCode),
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ],
                ),
                if (widget.modelState == ModelState.exist)
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteModel(widget.languageCode),
                  )
                else if (widget.modelState == ModelState.changing)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(),
                    ),
                  )
                else
                  IconButton(
                    icon: Icon(Icons.file_download),
                    onPressed: () => _fetchModel(widget.languageCode),
                  )
              ],
            ),
          ),
        ),
      );
    });
  }

  void _rowTap(context) {
    Navigator.pop(context, widget.languageCode);
  }

  Future<String> _fetchModel(String languageCode) async {
    setState(() {
      widget.modelState = ModelState.changing;
    });
    if ((await MLTranslation.downloadModel(languageCode)) == "Downloaded") {
      widget.modelState = ModelState.exist;
    } else {
      widget.modelState = ModelState.notExist;
    }
    setState(() {});
  }

  Future<String> _deleteModel(String languageCode) async {
    setState(() {
      widget.modelState = ModelState.changing;
    });
    if ((await MLTranslation.deleteModel(languageCode)) == "Deleted") {
      widget.modelState = ModelState.notExist;
    } else {
      widget.modelState = ModelState.exist;
    }
    setState(() {});
  }
}
