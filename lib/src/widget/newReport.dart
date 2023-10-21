// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tainopersonnel/src/class/state.dart';
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
  late AppState state;

  void sendAble() {
    state.report.content = contentController.text;
    state.report.day =
        '${DateTime.parse(dayController.text).toIso8601String()}Z';

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
    ThemeData theme = Theme.of(context);
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.title),
              const SizedBox(
                height: 8,
              ),
              DateSelection(
                controller: dayController,
                labelText: "Day",
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: InputField(
                  controller: contentController,
                  labelText: 'Your report',
                  content: state.report.content,
                  expands: true,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: canSend
                          ? () async {
                              bool ok = false;
                              if (widget.action == ReportAction.create) {
                                ok = await operation.createDailyReport(state);
                              } else if (widget.action == ReportAction.update) {
                                operation.updateDailyReport(state);
                              }
                              if (!mounted) return;
                              Navigator.of(context).pop(ok);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          disabledBackgroundColor: Colors.grey),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
