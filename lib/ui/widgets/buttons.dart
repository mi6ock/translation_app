import 'package:flutter/material.dart';

class SelectButton extends StatelessWidget {
  final VoidCallback onStartListening;
  final VoidCallback onSelectLanguage;
  final Color color;
  double level = 0;
  final String language;

  SelectButton({
    Key key,
    this.level,
    @required this.language,
    @required this.color,
    @required this.onStartListening,
    @required this.onSelectLanguage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: onSelectLanguage,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 60,
                child: Text(
                  language,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
              ),
            ],
          ),
        ),
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: .26,
                spreadRadius: level * 2,
                color: Colors.blueGrey.withOpacity(.3),
              )
            ],
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(300)),
          ),
          child: IconButton(
            icon: Icon(
              Icons.mic,
              color: Colors.white,
            ),
            onPressed: onStartListening,
          ),
        ),
      ],
    );
  }
}
