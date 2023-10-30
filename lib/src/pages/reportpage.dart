import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tainopersonnel/src/intl/intl.dart';
import 'package:tainopersonnel/src/model/employee.dart';
import 'package:tainopersonnel/src/model/state.dart';
import 'package:tainopersonnel/src/pages/reportlist.dart';
import 'package:tainopersonnel/src/widget/appbar.dart';
import 'package:tainopersonnel/src/widget/connection_state.dart';
import 'package:tainopersonnel/src/widget/loading.dart';
import 'package:tainopersonnel/src/widget/mytile.dart';

import 'package:tainopersonnel/src/operation/operation.dart' as operation;

// ignore: must_be_immutable
class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  final pageTitle = "Reports";

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<Employee> employees = [];
  bool isLoading = false;
  int page = 0, size = 10;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppState state = context.watch<AppState>();
    Language language = context.watch<AppLanguage>().language;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.pageTitle,
            style: TextStyle(color: theme.primaryColorLight),
          ),
          backgroundColor: theme.primaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const BackButtonIcon()),
        ),
        body: FutureBuilder(
            future: operation.getSubordonatesLastReportDate(state),
            builder: (context, snapshot) {
              employees = [Employee(id: state.empid, name: language.me)];
              employees.addAll(snapshot.data ?? []);

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loading();
              }

              return Column(
                children: [
                  const ConnectionStateShower(),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        var employeeList = [
                          Employee(id: state.empid, name: language.me)
                        ];
                        employeeList.addAll(await operation
                            .getSubordonatesLastReportDate(state));
                        setState(() {
                          employees = employeeList;
                        });
                      },
                      child: ListView.builder(
                          itemCount: employees.length,
                          itemBuilder: (context, index) {
                            String lastReportDate = operation
                                .formatDate(employees[index].lastReportDate);
                            return SizedBox(
                              height: 60,
                              child: MyTile(
                                textTheme: const TextStyle(fontSize: 20),
                                icon: Logo(
                                  content: employees[index].name,
                                ),
                                title: Text(
                                  employees[index].name,
                                  style: theme.textTheme.bodyLarge,
                                ),
                                subTitle: lastReportDate.isNotEmpty
                                    ? Text(
                                        lastReportDate,
                                        style: theme.textTheme.bodySmall,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : null,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReportList(
                                        empId: employees[index].id,
                                        empName: employees[index].name,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
