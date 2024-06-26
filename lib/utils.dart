import 'package:flutter/material.dart' show AlertDialog, BuildContext, Navigator, Text, TextButton, Widget, showDialog;
import 'dart:math' as Math;

String milisecondsTimeStampToYearMonthDay(int timestamp) {
  final datetime = DateTime.fromMillisecondsSinceEpoch(timestamp);

  final yearLength = datetime.year.toString().length;

  final year = datetime.year.toString().padLeft(Math.max(4, yearLength), '0');

  final month = datetime.month.toString().padLeft(2, '0');

  final day = datetime.day.toString().padLeft(2, '0');

  final dateString = '${year}-${month}-${day}';

  return dateString;
}

Future<void> showAlertDialog({required BuildContext context, required String title, String? message, Widget? childMessage, String? okText}) {
  if (message == null && childMessage == null) {
    throw Exception('Both message and messageWidget cannot be null.');
  }

  if (message != null && childMessage != null) {
    throw Exception('Both message and messageWidget cannot be specified, only one must be present.');
  }

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: message != null ? Text(message) : childMessage,
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
