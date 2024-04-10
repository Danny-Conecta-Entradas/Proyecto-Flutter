import 'package:flutter/material.dart' show AlertDialog, BuildContext, Navigator, Text, TextButton, Widget, showDialog;
import 'dart:math' as Math;

milisecondsTimeStampToYearMonthDay(int timestamp) {
  final datetime = DateTime.fromMillisecondsSinceEpoch(timestamp);

  final yearLength = datetime.year.toString().length;

  final year = datetime.year.toString().padLeft(Math.max(4, yearLength), '0');

  final month = datetime.month.toString().padLeft(2, '0');

  final day = datetime.day.toString().padLeft(2, '0');

  final dateString = '${year}-${month}-${day}';

  return dateString;
}

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
