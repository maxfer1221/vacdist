import 'package:flutter/material.dart';

class SimpleAlertDialog extends StatelessWidget {
  SimpleAlertDialog({Key? key, required this.title, required this.subtitles})
      : super(key: key);

  final String title;
  final List<String> subtitles;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: subtitles.map((subtitle) => Text(subtitle)).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        )
      ],
    );
  }
}
