import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:way_to_work/locale/translation_strings.dart';

toast(String message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      textColor: Colors.white,
      backgroundColor: Colors.black,
      fontSize: 16.0);
}

showConnectionDialog(BuildContext context) {
  Widget okButton = FlatButton(
    child: Text("${Translations.of(context).ok}"),
    onPressed: () => Navigator.pop(context),
  );

  AlertDialog alert = AlertDialog(
    title: Text("${Translations.of(context).noInternet}"),
    content: Text(
        "${Translations.of(context).checkYourInternetConnectionAndTryAgain}"),
    actions: [
      okButton,
    ],
  );

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showLangDialog(BuildContext context, data) {
  showDialog(
    context: context,
    child: SimpleDialog(
      title: Text('${Translations.of(context).selectLanguage}'),
      children: <Widget>[
        SimpleDialogOption(
          child: Text('English'),
          onPressed: () {
            data.changeDirection(Locale('en'));
            Navigator.pop(context);
          },
        ),
        SimpleDialogOption(
          child: Text('Russian'),
          onPressed: () {
            data.changeDirection(Locale('ru'));
            Navigator.pop(context);
          },
        ),
        SimpleDialogOption(
          child: Text('Estonian'),
          onPressed: () {
            data.changeDirection(Locale('et'));
            Navigator.pop(context);
          },
        ),
        SimpleDialogOption(
          child: Text('Finnish'),
          onPressed: () {
            data.changeDirection(Locale('fi'));
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
