// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;
import 'package:provider/provider.dart';
import 'package:tainopersonnel/src/intl/intl.dart';
import 'package:tainopersonnel/src/model/state.dart';
import 'package:tainopersonnel/src/widget/actionbutton.dart';
import 'package:tainopersonnel/src/widget/inputfield.dart';
import 'package:tainopersonnel/src/operation/operation.dart' as operation;

enum ReportAction { create, update }

class AddReport extends StatefulWidget {
  AddReport({
    super.key,
    required this.title,
    required this.action,
  });

  final String title;
  ReportAction action;

  @override
  State<AddReport> createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  TextEditingController dayController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  bool canSend = false;
  bool isLoading = false;
  late AppState state;
  DateTime? day;

  void sendAble() {
    state.report.content = contentController.text;
    try {
      day = DateTime.parse(dayController.text);
      String date = day!.toIso8601String();
      state.report.day = date;
    } catch (_) {}

    if (dayController.text.isEmpty || contentController.text.trim().isEmpty) {
      setState(() {
        canSend = false;
      });
      return;
    }

    setState(() {
      canSend = true;
    });
  }

  @override
  void initState() {
    super.initState();
    dayController.addListener(sendAble);
    contentController.addListener(sendAble);
  }

  @override
  Widget build(BuildContext context) {
    state = context.watch<AppState>();
    Language language = context.watch<AppLanguage>().language;
    ThemeData theme = Theme.of(context);
    contentController.text = state.report.content;
    try {
      day = DateTime.parse(state.report.day);
      dayController.text = day!.toIso8601String().substring(0, 10);
    } catch (_) {}

    void sendReport() async {
      bool ok = false;
      String toastMsg = '';

      if (widget.action == ReportAction.create) {
        ok = await operation.createDailyReport(state);
        toastMsg = ok ? language.reportAdded : language.reportAdded;
      } else {
        ok = await operation.updateDailyReport(state);
        toastMsg = ok ? language.reportAdded : language.reportAdded;
      }

      toast.Fluttertoast.showToast(
        msg: toastMsg,
        gravity: toast.ToastGravity.TOP,
      );

      if (!mounted) return;
      Navigator.of(context).pop(ok);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 2 / 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 8,
            ),
            DateSelection(
              controller: dayController,
              labelText: "Day",
              date: day,
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: InputField(
                controller: contentController,
                labelText: 'Report',
                content: state.report.content,
                expands: true,
                hint: 'Your text goes here',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ActionButton(
                    canPress: canSend,
                    loginFunction: sendReport,
                    icon: Icon(
                      Icons.send,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
