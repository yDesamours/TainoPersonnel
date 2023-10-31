// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tainopersonnel/src/intl/intl.dart';
import 'package:tainopersonnel/src/model/report.dart';
import 'package:tainopersonnel/src/model/state.dart';
import 'package:tainopersonnel/src/operation/operation.dart' as operation;
import 'package:tainopersonnel/src/utils/utils.dart';
import 'package:tainopersonnel/src/widget/newReport.dart';

class ReportTile extends StatefulWidget {
  ReportTile({super.key, required this.item, this.showUpdate = false});

  Report item;
  bool showUpdate;

  @override
  State<ReportTile> createState() => _ReportTile();
}

class _ReportTile extends State<ReportTile> {
  @override
  Widget build(BuildContext context) {
    AppState state = context.watch<AppState>();
    ThemeData theme = Theme.of(context);
    Language language = context.watch<AppLanguage>().language;

    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color.fromARGB(0, 27, 19, 2),
      ),
      child: ExpansionTile(
        collapsedBackgroundColor: theme.colorScheme.onBackground,
        collapsedTextColor: theme.colorScheme.secondary,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        childrenPadding: const EdgeInsets.all(20.0),
        textColor: theme.colorScheme.primary,
        iconColor: theme.primaryColor,
        maintainState: true,
        onExpansionChanged: (v) {
          if (widget.item.content.isEmpty && v) {
            operation.getDailyReport(widget.item.id, state).then((v) {
              if (v == null) {
                widget.item.content = language.loadFail;
                return;
              }
              setState(() {
                widget.item.content = v.content;
              });
            });
          }
        },
        title: Text(
          widget.item.day.substring(0, 10),
          style: theme.textTheme.bodyLarge,
        ),
        children: [
          Text(
            widget.item.content,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            child: widget.showUpdate
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          state.report = Report(
                              content: widget.item.content,
                              day: widget.item.day);
                          await showModal(
                            context,
                            AddReport(
                              title: "Update Report",
                              action: ReportAction.update,
                            ),
                          );
                          state.report = Report();
                        },
                        child: const Text("Update"),
                      ),
                    ],
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
