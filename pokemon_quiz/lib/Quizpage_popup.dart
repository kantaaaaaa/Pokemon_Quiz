import 'dart:ui';

import 'package:flutter/material.dart';

class TimeOutPopup {
  final String title;
  final String answer;
  final String imageUrl;
  final VoidCallback onNextProblemPressed;

  TimeOutPopup({
    required this.title,
    required this.answer,
    required this.imageUrl,
    required this.onNextProblemPressed,
  });
}

Future<void> showTimeOutPopup(BuildContext context, TimeOutPopup popup) async {
  print("aaaaaaaaaaaaaaaaa");
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          popup.title,
          style: TextStyle(fontSize: 30),
        ),
        content: Column(
          children: [
            Text(
              popup.answer,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 300,
              width: 300,
              child: Image.network(popup.imageUrl),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('次の問題へ進む'),
            onPressed: popup.onNextProblemPressed,
          ),
        ],
      );
    },
  );
}
