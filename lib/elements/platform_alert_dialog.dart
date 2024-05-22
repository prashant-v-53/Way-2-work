
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Base class to be extended by all platform aware widgets
abstract class PlatformWidget extends StatelessWidget {
  PlatformWidget({Key key}) : super(key: key);

  Widget buildCupertinoWidget(BuildContext context);
  Widget buildMaterialWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      // Use Cupertino on iOS
      return buildCupertinoWidget(context);
    }
    // Use Material design on Android and other platforms
    return buildMaterialWidget(context);
  }
}

class PlatformAlertDialog extends PlatformWidget {
  PlatformAlertDialog({
    @required this.title,
    @required this.content,
    this.cancelText,
    this.titleColor = Colors.black,
    @required this.confirmText,
  })  : assert(title != null),
        assert(content != null),
        assert(confirmText != null);

  final String title;
  final Color titleColor;
  final String content;
  final String cancelText;
  final String confirmText;

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title,style: TextStyle(color: titleColor),),
      content: Padding(
        padding:  EdgeInsets.symmetric(vertical:8.0),
        child: Text(content),
      ),
      actions: _actions(context, cancelText?.toUpperCase(), confirmText.toUpperCase()),
    );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title,style: TextStyle(color: titleColor),),
      content: Padding(
        padding:  EdgeInsets.symmetric(vertical:8.0),
        child: Text(content),
      ),
      actions: _actions(context, cancelText, confirmText),
    );
  }

  List<Widget> _actions(BuildContext context, String cancelText, String confirmText) {
    var actions = <Widget>[];
    if (cancelText != null) {
      actions.add(PlatformAlertDialogAction(
        child: Text(cancelText),
        onPressed: () => _dismiss(context, false),
      ));
    }
    actions.add(PlatformAlertDialogAction(
      child: Text(confirmText),
      onPressed: () => _dismiss(context, true),
    ));
    return actions;
  }

  Future<bool> show(BuildContext context,{bool barrierDismissible}) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => this,
    );
    // showDialog returns null if the dialog has been dismissed with the back
    // button on Android.
    // here we ensure that we return only true or false
    // return Future.value(result ?? false);
    return Future.value(result);
  }

  void _dismiss(BuildContext context, bool value) {
    Navigator.of(context, rootNavigator: true).pop(value);
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  PlatformAlertDialogAction({this.child, this.onPressed});

  final Widget child;
  final VoidCallback onPressed;

  @override
  FlatButton buildMaterialWidget(BuildContext context) {
    return FlatButton(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  CupertinoDialogAction buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }
}
