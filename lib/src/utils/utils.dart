import 'package:flutter/material.dart';
import 'package:tainopersonnel/src/data/database.dart';

Future<bool> confirmationRequest(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        ThemeData theme = Theme.of(context);
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          alignment: AlignmentDirectional.center,
          title: const Text(
            "Log out?",
            textAlign: TextAlign.center,
          ),
          content: const Text("Are you sure you want to log out",
              textAlign: TextAlign.center, maxLines: 2),
          actions: <ElevatedButton>[
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(theme.primaryColor)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(theme.secondaryHeaderColor)),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No"),
            ),
          ],
        );
      }).then((value) => value ?? false);
}
