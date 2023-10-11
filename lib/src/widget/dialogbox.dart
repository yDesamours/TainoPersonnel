import "package:flutter/material.dart";

class DialogBox extends StatelessWidget {
  final String message;

  const DialogBox({super.key, this.message = ""});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Pour fermer la boîte de dialogue
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
