import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tainopersonnel/src/model/report.dart';
import 'package:tainopersonnel/src/model/state.dart';
import 'package:tainopersonnel/src/operation/operation.dart' as operation;
import 'package:tainopersonnel/src/utils/utils.dart';
import 'package:tainopersonnel/src/widget/newReport.dart';

class ReportTile extends StatefulWidget {
  ReportTile({super.key, required this.item});

  Report item;

  @override
  State<ReportTile> createState() => _ReportTile();
}

class _ReportTile extends State<ReportTile> {
  @override
  Widget build(BuildContext context) {
    AppState state = context.watch<AppState>();
    ThemeData theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color.fromARGB(0, 27, 19, 2),
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        // border: Border.all(
        //   color: theme.primaryColor,
        //   width: 2.0,
        // ),
      ),
      child: ExpansionTile(
        iconColor: theme.primaryColor,
        backgroundColor: Color.fromARGB(0, 19, 7, 61),
        onExpansionChanged: (v) {
          if (widget.item.content.isEmpty && v) {
            operation.getDailyReport(widget.item.id, state).then((v) {
              setState(() {
                widget.item.content = v.content;
              });
            });
          }
        },
        title: Text(
          widget.item.day.substring(0, 10),
          style: theme.textTheme.bodySmall,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.item.content,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    state.report = Report(
                        content: widget.item.content, day: widget.item.day);
                    showModal(
                      context,
                      AddReport(
                        title: "Update Report",
                        action: ReportAction.update,
                      ),
                    );
                  },
                  child: const Text("Update"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
