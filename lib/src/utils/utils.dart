import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tainopersonnel/src/intl/intl.dart';

Future<bool> confirmationRequest(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        ThemeData theme = Theme.of(context);
        Language language = context.watch<AppLanguage>().language;

        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          alignment: AlignmentDirectional.center,
          title: Text(
            language.logout,
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
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(theme.secondaryHeaderColor)),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "No",
                style: TextStyle(color: theme.primaryColor),
              ),
            ),
          ],
        );
      }).then((value) => value ?? false);
}

Future<T?> showModal<T>(BuildContext context, Widget widget) {
  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: widget,
    ),
  ).then((value) => value);
}
