// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tainopersonnel/src/class/api.dart';
import 'package:tainopersonnel/src/class/state.dart';
import 'package:tainopersonnel/src/widget/inputfield.dart';

class AddReport extends StatefulWidget {
  const AddReport({super.key});

  @override
  State<AddReport> createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  TextEditingController dayController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  bool canSend = false;

  void sendAble() {
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
    AppState state = context.watch<AppState>();
    return Column(
      children: [
        Row(
          children: [
            const Text('New Report'),
            ElevatedButton(
              onPressed: canSend
                  ? null
                  : () {
                      API.sendDailyReport(state.report, state.token);
                    },
              child: const Icon(Icons.arrow_forward),
            )
          ],
        ),
        InputField(
          controller: dayController,
          labelText: "Day",
          content: state.report.day,
        ),
        InputField(
          controller: contentController,
          labelText: 'Your report',
          content: state.report.content,
        ),
      ],
    );
  }
}
