import 'package:flutter/material.dart' show AlertDialog, BuildContext, Navigator, Text, TextButton, Widget, showDialog;


showAlertDialog({required BuildContext context, required String title, String? message, Widget? messageWidget, String? okText}) {
  if (message == null && messageWidget == null) {
    throw Exception('Both message and messageWidget cannot be null.');
  }

  if (message != null && messageWidget != null) {
    throw Exception('Both message and messageWidget cannot be specified, only one must be present.');
  }

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: message != null ? Text(message) : messageWidget,
        actions: [
          TextButton(
            onPressed: () {Navigator.pop(context);},
            child: Text(okText ?? 'OK'),
          ),
        ],
      );
    },
  );
}
