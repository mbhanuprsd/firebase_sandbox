import 'package:flutter/material.dart';

class AppUtils {
  static showAlert(BuildContext context, String title, String message,
      String buttonText, Function callBack) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(title),
            content: new Text(message),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text(buttonText),
                onPressed: () => callBack(),
              ),
            ],
          );
        });
  }
}

class ButtonAction {
  String name;
  Function callBack;

  ButtonAction(this.name, this.callBack);
}
